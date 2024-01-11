//
//  MKNNBScanViewController.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNNBScanViewController.h"

#import <objc/runtime.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertController.h"

#import "MKNNBScanFilterView.h"
#import "MKNNBScanSearchButton.h"

#import "MKNNBCentralManager.h"
#import "MKNNBBaseBeacon.h"

#import "MKNNBScanPageAdopter.h"

#import "MKNNBScanInfoCellModel.h"

#import "MKNNBScanInfoCell.h"

#import "MKNNBAboutController.h"

static CGFloat const offset_X = 15.f;
static CGFloat const searchButtonHeight = 40.f;
static CGFloat const headerViewHeight = 90.f;

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKNNBScanViewController ()<UITableViewDelegate,
UITableViewDataSource,
MKNNBScanSearchButtonDelegate,
mk_nnb_centralManagerScanDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKNNBScanSearchButtonModel *buttonModel;

@property (nonatomic, strong)MKNNBScanSearchButton *searchButton;

@property (nonatomic, strong)UIImageView *refreshIcon;

@property (nonatomic, strong)UIButton *refreshButton;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@end

@implementation MKNNBScanViewController

- (void)dealloc {
    NSLog(@"MKNNBScanViewController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKNNBCentralManager shared] stopScan];
    [MKNNBCentralManager removeFromCentralList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self startRefresh];
}

#pragma mark - super method
- (void)rightButtonMethod {
    MKNNBAboutController *vc = [[MKNNBAboutController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MKNNBScanInfoCellModel *model = self.dataList[section];
    return (model.advertiseList.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //第一个row固定为设备信息帧
        MKNNBScanInfoCell *cell = [MKNNBScanInfoCell initCellWithTableView:tableView];
        cell.dataModel = self.dataList[indexPath.section];
        return cell;
    }
    MKNNBScanInfoCellModel *model = self.dataList[indexPath.section];
    return [MKNNBScanPageAdopter loadCellWithTableView:tableView dataModel:model.advertiseList[indexPath.row - 1]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return headerViewHeight;
    }
    MKNNBScanInfoCellModel *model = self.dataList[indexPath.section];
    return [MKNNBScanPageAdopter loadCellHeightWithDataModel:model.advertiseList[indexPath.row - 1]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    MKTableSectionLineHeaderModel *sectionData = [[MKTableSectionLineHeaderModel alloc] init];
    sectionData.contentColor = RGBCOLOR(237, 243, 250);
    headerView.headerModel = sectionData;
    return headerView;
}

#pragma mark - MKNNBScanSearchButtonDelegate
- (void)nnb_scanSearchButtonMethod {
    [MKNNBScanFilterView showSearchCondition:self.buttonModel.searchCondition 
                                        rssi:self.buttonModel.searchRssi
                                 searchBlock:^(NSString * _Nonnull searchCondition, NSInteger searchRssi) {
        self.buttonModel.searchRssi = searchRssi;
        self.buttonModel.searchCondition = searchCondition;
        self.searchButton.dataModel = self.buttonModel;
        
        self.refreshButton.selected = NO;
        [self refreshButtonPressed];
    }];
}

- (void)nnb_scanSearchButtonClearMethod {
    self.buttonModel.searchRssi = -100;
    self.buttonModel.searchCondition = @"";
    self.refreshButton.selected = NO;
    [self refreshButtonPressed];
}

#pragma mark - mk_nnb_centralManagerScanDelegate
- (void)mk_nnb_receiveBeacon:(NSArray <MKNNBBaseBeacon *>*)beaconList {
    for (MKNNBBaseBeacon *beacon in beaconList) {
        [self updateDataWithBeacon:beacon];
    }
}

- (void)mk_nnb_stopScan {
    //如果是左上角在动画，则停止动画
    if (self.refreshButton.isSelected) {
        [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.refreshButton setSelected:NO];
    }
}

#pragma mark - event method
- (void)refreshButtonPressed {
    if ([MKNNBCentralManager shared].centralStatus != mk_nnb_centralManagerStatusEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.refreshButton.selected = !self.refreshButton.selected;
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.refreshButton.isSelected) {
        //停止扫描
        [[MKNNBCentralManager shared] stopScan];
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //刷新顶部设备数量
    [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
    [self.refreshIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [[MKNNBCentralManager shared] startScan];
}

#pragma mark - notice method
- (void)showCentralStatus{
    if ([MKNNBCentralManager shared].centralStatus != mk_nnb_centralManagerStatusEnable) {
        NSString *msg = @"The current system of bluetooth is not available!";
        MKAlertController *alertController = [MKAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:moreAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self refreshButtonPressed];
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.refreshButton.selected = NO;
    [self refreshButtonPressed];
}

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    @weakify(self);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @strongify(self);
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (self.isNeedRefresh) {
                [self.tableView reloadData];
                [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

- (void)updateDataWithBeacon:(MKNNBBaseBeacon *)beacon{
    if (!beacon || beacon.frameType == MKNNBUnknownFrameType) {
        return;
    }
    if (ValidStr(self.buttonModel.searchCondition)) {
        //如果打开了过滤，先看是否需要过滤设备TagID
        //如果是设备信息帧,判断mac和名字是否符合要求
        if ([beacon.rssi integerValue] >= self.buttonModel.searchRssi) {
            [self filterBeaconWithSearchName:beacon];
        }
        return;
    }
    if (self.buttonModel.searchRssi > self.buttonModel.minSearchRssi) {
        //开启rssi过滤
        if ([beacon.rssi integerValue] >= self.buttonModel.searchRssi) {
            [self processBeacon:beacon];
        }
        return;
    }
    [self processBeacon:beacon];
}

/**
 通过设备tagID过滤设备，这个时候肯定开启了rssi
 
 @param beacon 设备
 */
- (void)filterBeaconWithSearchName:(MKNNBBaseBeacon *)beacon{
    if (beacon.frameType == MKNNBSensorInfoFrameType) {
        //如果是传感器信息帧
        MKNNBSensorInfoBeacon *tempBeacon = (MKNNBSensorInfoBeacon *)beacon;
        if ([[tempBeacon.tagID uppercaseString] containsString:[self.buttonModel.searchCondition uppercaseString]]) {
            //如果mac地址和设备名称包含搜索条件，则加入
            [self processBeacon:beacon];
        }
        return;
    }
    //如果不是设备信息帧，则判断对应的有没有设备信息帧在当前数据源，如果没有直接舍弃，如果存在，则加入
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (!contain) {
        return;
    }
    [MKNNBScanPageAdopter updateInfoCellModel:array[0] beaconData:beacon];
    [self needRefreshList];
}

- (void)processBeacon:(MKNNBBaseBeacon *)beacon{
    //查看数据源中是否已经存在相关设备
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (contain) {
        //如果是已经存在了，如果是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到MKNNBScanBeaconModel的dataArray里面去
        [MKNNBScanPageAdopter updateInfoCellModel:array[0] beaconData:beacon];
        [self needRefreshList];
        return;
    }
    //不存在，则加入到dataList里面去
    MKNNBScanInfoCellModel *deviceModel = [MKNNBScanPageAdopter parseBaseBeaconToInfoModel:beacon];
    [self.dataList addObject:deviceModel];
    [self needRefreshList];
}

#pragma mark -
- (void)startRefresh {
    self.searchButton.dataModel = self.buttonModel;
    [self runloopObserver];
    [MKNNBCentralManager shared].delegate = self;
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:.5f];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.view setBackgroundColor:RGBCOLOR(237, 243, 250)];
    [self.rightButton setImage:LOADICON(@"MKNanoBeacon", @"MKNNBScanViewController", @"nnb_scanRightAboutIcon.png") forState:UIControlStateNormal];
    self.titleLabel.text = @"DEVICE(0)";
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGBCOLOR(237, 243, 250);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(searchButtonHeight + 2 * 15.f);
    }];
    [self.refreshButton addSubview:self.refreshIcon];
    [topView addSubview:self.refreshButton];
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.refreshButton.mas_centerX);
        make.centerY.mas_equalTo(self.refreshButton.mas_centerY);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(40.f);
    }];
    [topView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.refreshButton.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-5.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)refreshIcon {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.image = LOADICON(@"MKNanoBeacon", @"MKNNBScanViewController", @"nnb_scan_refreshIcon.png");
    }
    return _refreshIcon;
}

- (MKNNBScanSearchButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[MKNNBScanSearchButton alloc] init];
        _searchButton.delegate = self;
    }
    return _searchButton;
}

- (MKNNBScanSearchButtonModel *)buttonModel {
    if (!_buttonModel) {
        _buttonModel = [[MKNNBScanSearchButtonModel alloc] init];
        _buttonModel.placeholder = @"Edit Filter";
        _buttonModel.minSearchRssi = -100;
        _buttonModel.searchRssi = -100;
    }
    return _buttonModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton addTarget:self
                           action:@selector(refreshButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

@end
