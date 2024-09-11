//
//  MKNNBNanoBeaconInfoCell.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/9/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKNNBNanoBeaconInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;
static CGFloat const msgLabelWidth = 120.f;

#define msgFont MKFont(12.f)

@implementation MKNNBNanoBeaconInfoCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.lastCutoffStatus = 0;
        self.lastBtnStatus = 1;
    }
    return self;
}

@end

@interface MKNNBNanoBeaconInfoCell ()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 类型,T&H
 */
@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *tempLabel;

@property (nonatomic, strong)UILabel *tempValueLabel;

@property (nonatomic, strong)UILabel *cutOffLabel;

@property (nonatomic, strong)UILabel *cutOffValueLabel;

@property (nonatomic, strong)UILabel *buttonLabel;

@property (nonatomic, strong)UILabel *buttonValueLabel;

@property (nonatomic, strong)UILabel *runLabel;

@property (nonatomic, strong)UILabel *runValueLabel;

@end

@implementation MKNNBNanoBeaconInfoCell

+ (MKNNBNanoBeaconInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKNNBNanoBeaconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNNBNanoBeaconInfoCellIdenty"];
    if (!cell) {
        cell = [[MKNNBNanoBeaconInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNNBNanoBeaconInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.tempLabel];
        [self.contentView addSubview:self.tempValueLabel];
        [self.contentView addSubview:self.cutOffLabel];
        [self.contentView addSubview:self.cutOffValueLabel];
        [self.contentView addSubview:self.buttonLabel];
        [self.contentView addSubview:self.buttonValueLabel];
        [self.contentView addSubview:self.runLabel];
        [self.contentView addSubview:self.runValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.tempValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tempLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.tempLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.cutOffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.tempLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.cutOffValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tempLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.cutOffLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.cutOffLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.buttonValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tempLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.buttonLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.runLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.buttonLabel.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.runValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tempLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.runLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKNNBNanoBeaconInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNNBNanoBeaconInfoCellModel.class]) {
        return;
    }
    self.tempValueLabel.text = [_dataModel.temperature stringByAppendingString:@"℃"];
    self.cutOffValueLabel.text = (_dataModel.cutOffTrigger ? @"Triggered" : @"Normal");
    self.cutOffValueLabel.textColor = (_dataModel.cutOffTrigger ? [UIColor redColor] : RGBCOLOR(184, 184, 184));
    self.buttonValueLabel.text = (_dataModel.buttonTrigger ? @"Triggered" : @"Normal");
    self.buttonValueLabel.textColor = (_dataModel.buttonTrigger ? [UIColor redColor] : RGBCOLOR(184, 184, 184));
    self.runValueLabel.text = [self getTimeWithSec:[_dataModel.runningTime floatValue]];
}

#pragma mark - private method
- (NSString *)getTimeWithSec:(float)second{
    NSInteger minutes = floor(second / 60);
    float sec = (second - minutes * 60);
    NSInteger hours1 = floor(second / (60 * 60));
    minutes = minutes - hours1 * 60;
    NSInteger day = floor(hours1 / 24);
    hours1 = hours1 - 24 * day;
    NSString *time = [NSString stringWithFormat:@"%@d%@h%@m%@s",[NSString stringWithFormat:@"%ld",(long)day],[NSString stringWithFormat:@"%ld",(long)hours1],[NSString stringWithFormat:@"%ld",(long)minutes],[NSString stringWithFormat:@"%.1f",sec]];
    return time;
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKNanoBeacon", @"MKNNBNanoBeaconInfoCell", @"nnb_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.text = @"NanoBeacon info";
    }
    return _typeLabel;
}

- (UILabel *)tempLabel {
    if (!_tempLabel) {
        _tempLabel = [self createLabelWithFont:msgFont];
        _tempLabel.text = @"Temperature";
    }
    return _tempLabel;
}

- (UILabel *)tempValueLabel {
    if (!_tempValueLabel) {
        _tempValueLabel = [self createLabelWithFont:msgFont];
    }
    return _tempValueLabel;
}

- (UILabel *)cutOffLabel {
    if (!_cutOffLabel) {
        _cutOffLabel = [self createLabelWithFont:msgFont];
        _cutOffLabel.text = @"Cut-off status";
    }
    return _cutOffLabel;
}

- (UILabel *)cutOffValueLabel {
    if (!_cutOffValueLabel) {
        _cutOffValueLabel = [self createLabelWithFont:msgFont];
    }
    return _cutOffValueLabel;
}

- (UILabel *)buttonLabel {
    if (!_buttonLabel) {
        _buttonLabel = [self createLabelWithFont:msgFont];
        _buttonLabel.text = @"Button alarm";
    }
    return _buttonLabel;
}

- (UILabel *)buttonValueLabel {
    if (!_buttonValueLabel) {
        _buttonValueLabel = [self createLabelWithFont:msgFont];
    }
    return _buttonValueLabel;
}

- (UILabel *)runLabel {
    if (!_runLabel) {
        _runLabel = [self createLabelWithFont:msgFont];
        _runLabel.text = @"Running time";
    }
    return _runLabel;
}

- (UILabel *)runValueLabel {
    if (!_runValueLabel) {
        _runValueLabel = [self createLabelWithFont:msgFont];
    }
    return _runValueLabel;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
