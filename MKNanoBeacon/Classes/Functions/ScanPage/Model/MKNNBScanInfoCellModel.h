//
//  MKNNBScanInfoCellModel.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXScanInfoCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKNNBScanInfoCellModel : NSObject<MKBXScanInfoCellProtocol>

/// 强业务相关，设备信息帧的广播数组，TLM、UID、URL、iBeacon、温湿度、三轴这些广播帧会被添加到对应的设备信息帧的广播数组里面来
@property (nonatomic, strong)NSMutableArray *advertiseList;

/**
 peripheral 标识符，用来筛选当前设备列表是否已经存在某一个设备
 */
@property (nonatomic, copy)NSString *identifier;

/**
 上一次扫描到的时间
 */
@property (nonatomic, assign)NSTimeInterval lastScanDate;


#pragma mark - **************************MKBXScanInfoCellProtocol*********************

@property (nonatomic, strong)CBPeripheral *peripheral;

/**
 信号值强度,会动态变化，TLM、iBeacon、UID、URL、info都会改变这个值
 */
@property (nonatomic, copy)NSString *rssi;

/// 用于记录本次扫到该设备距离上次扫到该设备的时间差，单位ms.
@property (nonatomic, copy)NSString *displayTime;
@property (nonatomic, copy) NSString *tagID;
//Battery Voltage
@property (nonatomic, copy) NSString *battery;

@property (nonatomic, copy)NSString *macAddress;

@property (nonatomic, copy)NSString *deviceName;

@end

NS_ASSUME_NONNULL_END
