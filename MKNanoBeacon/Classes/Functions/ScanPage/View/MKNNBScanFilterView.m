//
//  MKNNBScanFilterView.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKNNBScanFilterView.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKSlider.h"
#import "MKTextField.h"

static CGFloat const offset_X = 10.f;
static CGFloat const backViewHeight = 400.f;
static CGFloat const signalIconWidth = 17.f;
static CGFloat const signalIconHeight = 15.f;

static NSString *const noteMsg1 = @"* RSSI filtering is the highest priority filtering condition. BLE Name and MAC Address filtering must first meet the RSSI filtering condition.";

@interface MKNNBScanFilterView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *minRssiLabel;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UIImageView *signalIcon;

@property (nonatomic, strong)UIImageView *graySignalIcon;

@property (nonatomic, strong)UILabel *minLabel;

@property (nonatomic, strong)UILabel *maxLabel;

@property (nonatomic, strong)MKSlider *slider;

@property (nonatomic, strong)UILabel *noteLabel1;

@property (nonatomic, strong)UIButton *doneButton;

@property (nonatomic, copy)void (^searchBlock)(NSString *searchCondition, NSInteger searchRssi);

@end

@implementation MKNNBScanFilterView

- (void)dealloc{
    NSLog(@"MKNNBScanFilterView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBACOLOR(0, 0, 0, 0.1f)];
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.minRssiLabel];
        [self.backView addSubview:self.rssiValueLabel];
        [self.backView addSubview:self.signalIcon];
        [self.backView addSubview:self.graySignalIcon];
        [self.backView addSubview:self.slider];
        [self.backView addSubview:self.minLabel];
        [self.backView addSubview:self.maxLabel];
        [self.backView addSubview:self.noteLabel1];
        [self.backView addSubview:self.doneButton];
        
        [self addTapAction];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self) {
        return NO;
    }
    return YES;
}

#pragma mark - Private method

- (void)rssiValueChanged{
    [self.rssiValueLabel setText:[NSString stringWithFormat:@"%.fdBm",(-100 - self.slider.value)]];
}

- (void)dismiss{
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, -backViewHeight);
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)doneButtonPressed{
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, -backViewHeight);
    } completion:^(BOOL finished) {
        NSString *value = [NSString stringWithFormat:@"%.f",self.slider.value];
        if (self.searchBlock) {
            self.searchBlock(SafeStr(self.textField.text), (-100 - [value integerValue]));
        }
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)addTapAction{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(dismiss)];
    [singleTap setNumberOfTouchesRequired:1];   //触摸点个数
    [singleTap setNumberOfTapsRequired:1];      //点击次数
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}

#pragma mark - public method
+ (void)showSearchCondition:(NSString *)condition
                       rssi:(NSInteger)rssi
                searchBlock:(void (^)(NSString *searchCondition, NSInteger searchRssi))searchBlock {
    MKNNBScanFilterView *view = [[MKNNBScanFilterView alloc] init];
    [view showSearchCondition:condition rssi:rssi searchBlock:searchBlock];
}


#pragma mark - private method
- (void)showSearchCondition:(NSString *)condition
                       rssi:(NSInteger)rssi
                searchBlock:(void (^)(NSString *searchCondition, NSInteger searchRssi))searchBlock {
    [kAppWindow addSubview:self];
    self.searchBlock = searchBlock;
    self.textField.text = SafeStr(condition);
    [self.slider setValue:(-100 - rssi)];
    [self.rssiValueLabel setText:[NSString stringWithFormat:@"%lddBm",(long)rssi]];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, backViewHeight + kTopBarHeight);
    } completion:^(BOOL finished) {
        [self.textField becomeFirstResponder];
    }];
}

#pragma mark - getter
#define backViewWidth (kViewWidth - 2 * offset_X)
#define textFieldPostion_X (offset_X)
#define textFieldWidth (backViewWidth - 2 * textFieldPostion_X)
#define textFieldPostion_Y (10.f)
#define textSpaceY (30.f + 10.f)
#define singalIconPostion_Y (textFieldPostion_Y + 2 * textSpaceY + 25.f + 30.f)

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(offset_X,
                                                             -backViewHeight,
                                                             backViewWidth,
                                                             backViewHeight)];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _backView;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _textField.frame  = CGRectMake(textFieldPostion_X,
                                           textFieldPostion_Y,
                                           textFieldWidth,
                                           30.f);
        _textField.maxLength = 20;
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = MKFont(13.f);
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.placeholder = @"Mac address or Tag ID";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.cornerRadius = 4.f;
    }
    return _textField;
}

- (UILabel *)minRssiLabel {
    if (!_minRssiLabel) {
        _minRssiLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X, textFieldPostion_Y + 2 * textSpaceY, 100.f, 25.f)];
        _minRssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _minRssiLabel.textAlignment = NSTextAlignmentLeft;
        _minRssiLabel.font = MKFont(14.f);
        _minRssiLabel.text = @"Min. RSSI";
    }
    return _minRssiLabel;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X + 100.f + 10.f,
                                                                    textFieldPostion_Y + 2 * textSpaceY,
                                                                    textFieldWidth,
                                                                    25.f)];
        _rssiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiValueLabel.textAlignment = NSTextAlignmentLeft;
        _rssiValueLabel.font = MKFont(14.f);
        _rssiValueLabel.text = @"-100dBm";
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5f, textFieldWidth, 0.5f)];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_rssiValueLabel addSubview:lineView];
    }
    return _rssiValueLabel;
}

- (UIImageView *)signalIcon{
    if (!_signalIcon) {
        _signalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(offset_X,
                                                                    singalIconPostion_Y,
                                                                    signalIconWidth,
                                                                    signalIconHeight)];
        _signalIcon.image = LOADICON(@"MKNanoBeacon", @"MKNNBScanFilterView", @"nnb_wifiSignalIcon.png");
    }
    return _signalIcon;
}

- (MKSlider *)slider{
    if (!_slider) {
        CGFloat postion_X = (offset_X + signalIconWidth + 10.f);
        _slider = [[MKSlider alloc] init];
        _slider.frame = CGRectMake(postion_X,
                                   singalIconPostion_Y,
                                   backViewWidth - 2 * postion_X ,
                                   signalIconHeight);
        [_slider setMaximumValue:0];
        [_slider setMinimumValue:-100];
        [_slider setValue:-100];
        [_slider addTarget:self
                    action:@selector(rssiValueChanged)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UIImageView *)graySignalIcon {
    if (!_graySignalIcon) {
        _graySignalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(backViewWidth - offset_X - signalIconWidth,
                                                                        singalIconPostion_Y,
                                                                    signalIconWidth,
                                                                    signalIconHeight)];
        _graySignalIcon.image = LOADICON(@"MKNanoBeacon", @"MKNNBScanFilterView", @"nnb_wifiGraySignalIcon.png");
    }
    return _graySignalIcon;
}

- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X, singalIconPostion_Y + signalIconHeight + 2.f, 50.f, MKFont(11.f).lineHeight)];
        _maxLabel.textColor = RGBCOLOR(15, 131, 255);
        _maxLabel.textAlignment = NSTextAlignmentLeft;
        _maxLabel.font = MKFont(11);
        _maxLabel.text = @"0dBm";
    }
    return _maxLabel;
}

- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(backViewWidth - offset_X - 50.f, singalIconPostion_Y + signalIconHeight + 2.f, 50.f, MKFont(11.f).lineHeight)];
        _minLabel.textColor = [UIColor grayColor];
        _minLabel.textAlignment = NSTextAlignmentLeft;
        _minLabel.font = MKFont(11);
        _minLabel.text = @"-100dBm";
    }
    return _minLabel;
}

- (UILabel *)noteLabel1 {
    if (!_noteLabel1) {
        _noteLabel1 = [[UILabel alloc] init];
        _noteLabel1.textColor = [UIColor orangeColor];
        _noteLabel1.font = MKFont(11.f);
        _noteLabel1.numberOfLines = 0;
        _noteLabel1.textAlignment = NSTextAlignmentLeft;
        _noteLabel1.text = noteMsg1;
        CGSize size = [NSString sizeWithText:noteMsg1
                                     andFont:MKFont(11.f)
                                  andMaxSize:CGSizeMake(backViewWidth - 2 * offset_X, MAXFLOAT)];
        _noteLabel1.frame = CGRectMake(offset_X, singalIconPostion_Y + signalIconHeight + offset_X + 20.f, backViewWidth - 2 * offset_X, size.height);
    }
    return _noteLabel1;
}

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [MKCustomUIAdopter customButtonWithTitle:@"Apply"
                                                    titleColor:COLOR_WHITE_MACROS
                                               backgroundColor:NAVBAR_COLOR_MACROS
                                                        target:self action:@selector(doneButtonPressed)];
        _doneButton.frame = CGRectMake(offset_X, backViewHeight - 40.f - 45.f, backViewWidth - 2 * offset_X, 45.f);
    }
    return _doneButton;
}

@end
