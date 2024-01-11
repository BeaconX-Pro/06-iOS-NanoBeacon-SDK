//
//  MKNNBScanFilterView.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNNBScanFilterView : UIView

/// 加载扫描过滤页面
/// @param condition 过滤的condition
/// @param rssi 过滤的rssi
/// @param searchBlock 回调
+ (void)showSearchCondition:(NSString *)condition
                       rssi:(NSInteger)rssi
                searchBlock:(void (^)(NSString *searchCondition, NSInteger searchRssi))searchBlock;

@end

NS_ASSUME_NONNULL_END
