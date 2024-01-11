//
//  MKNNBScanInfoCell.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKNNBScanInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKNNBScanInfoCellModel.h"

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const batteryIconWidth = 25.f;
static CGFloat const batteryIconHeight = 25.f;

@interface MKNNBScanInfoCell ()

/**
 信号icon
 */
@property (nonatomic, strong)UIImageView *rssiIcon;

/**
 信号强度
 */
@property (nonatomic, strong)UILabel *rssiLabel;


/**
 电池图标
 */
@property (nonatomic, strong)UIImageView *batteryIcon;

@property (nonatomic, strong)UILabel *batteryLabel;

/**
 mac地址
 */
@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *tagIDLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *topBackView;

@property (nonatomic, strong)UIView *centerBackView;

@property (nonatomic, strong)UIView *bottomBackView;

@end

@implementation MKNNBScanInfoCell

+ (MKNNBScanInfoCell *)initCellWithTableView:(UITableView *)tableView{
    MKNNBScanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNNBScanInfoCellIdenty"];
    if (!cell) {
        cell = [[MKNNBScanInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNNBScanInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topBackView];
        [self.contentView addSubview:self.centerBackView];
        [self.contentView addSubview:self.bottomBackView];
        
        [self.topBackView addSubview:self.rssiIcon];
        [self.topBackView addSubview:self.rssiLabel];
        [self.topBackView addSubview:self.macLabel];
        
        [self.centerBackView addSubview:self.batteryIcon];
        [self.centerBackView addSubview:self.tagIDLabel];
        
        [self.bottomBackView addSubview:self.batteryLabel];
        [self.bottomBackView addSubview:self.timeLabel];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.f];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40.f);
    }];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(10.f);
        make.width.mas_equalTo(rssiIconWidth);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(20.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.centerBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topBackView.mas_bottom);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.batteryIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(batteryIconWidth);
        make.centerY.mas_equalTo(self.centerBackView.mas_centerY);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.tagIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.macLabel.mas_left);
        make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.centerBackView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    
    [self.bottomBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.centerBackView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.batteryIcon.mas_centerX);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(3.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.batteryLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKNNBScanInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNNBScanInfoCellModel.class]) {
        return;
    }
    
    self.timeLabel.text = _dataModel.displayTime;
    self.rssiLabel.text = [SafeStr(_dataModel.rssi) stringByAppendingString:@"dBm"];
    self.macLabel.text = @"N/A";
    self.batteryLabel.text = (ValidStr(_dataModel.battery) ? [_dataModel.battery stringByAppendingString:@"mV"] : @"N/A");
    NSString *tagID = (ValidStr(_dataModel.tagID) ? _dataModel.tagID : @"N/A");
    self.tagIDLabel.text = [NSString stringWithFormat:@"Tag ID:%@",tagID];
    [self setNeedsLayout];
}

#pragma mark - getter
- (UIImageView *)rssiIcon{
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADICON(@"MKNanoBeacon", @"MKNNBScanInfoCell", @"nnb_signalIcon.png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:MKFont(10)];
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rssiLabel;
}

- (UIImageView *)batteryIcon{
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADICON(@"MKNanoBeacon", @"MKNNBScanInfoCell", @"nnb_batteryHighest.png");
    }
    return _batteryIcon;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [self createLabelWithFont:MKFont(10.f)];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryLabel;
}

- (UILabel *)macLabel{
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:MKFont(15)];
    }
    return _macLabel;
}

- (UILabel *)tagIDLabel {
    if (!_tagIDLabel) {
        _tagIDLabel = [self createLabelWithFont:MKFont(13.f)];
    }
    return _tagIDLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithFont:MKFont(10.f)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
    }
    return _topBackView;
}

- (UIView *)centerBackView {
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc] init];
    }
    return _centerBackView;
}

- (UIView *)bottomBackView {
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] init];
    }
    return _bottomBackView;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
