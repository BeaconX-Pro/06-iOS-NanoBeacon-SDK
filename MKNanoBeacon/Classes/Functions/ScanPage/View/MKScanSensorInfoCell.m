//
//  MKScanSensorInfoCell.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKScanSensorInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;
static CGFloat const msgLabelWidth = 120.f;

#define msgFont MKFont(12.f)

@implementation MKScanSensorInfoCellModel
@end

@interface MKScanSensorInfoCell ()

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

@end

@implementation MKScanSensorInfoCell

+ (MKScanSensorInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKScanSensorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKScanSensorInfoCellIdenty"];
    if (!cell) {
        cell = [[MKScanSensorInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKScanSensorInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.tempLabel];
        [self.contentView addSubview:self.tempValueLabel];
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
}

#pragma mark - setter
- (void)setDataModel:(MKScanSensorInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKScanSensorInfoCellModel.class]) {
        return;
    }
    self.tempValueLabel.text = [_dataModel.temperature stringByAppendingString:@"℃"];
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKNanoBeacon", @"MKScanSensorInfoCell", @"nnb_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.text = @"Sensor info";
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

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
