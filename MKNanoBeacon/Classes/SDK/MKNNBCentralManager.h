//
//  MKNNBCentralManager.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class CBCentralManager,CBPeripheral;
@class MKNNBBaseBeacon;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_bxp_centralManagerStateChangedNotification;

typedef NS_ENUM(NSInteger, mk_nnb_centralManagerStatus) {
    mk_nnb_centralManagerStatusUnable,                           //不可用
    mk_nnb_centralManagerStatusEnable,                           //可用状态
};

@protocol mk_nnb_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param beaconList device
- (void)mk_nnb_receiveBeacon:(NSArray <MKNNBBaseBeacon *>*)beaconList;

@optional

/// Starts scanning equipment.
- (void)mk_nnb_startScan;

/// Stops scanning equipment.
- (void)mk_nnb_stopScan;

@end

@interface MKNNBCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_nnb_centralManagerScanDelegate>delegate;

+ (MKNNBCentralManager *)shared;

/// Destroy the MKNNBCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKNNBCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Current Bluetooth center status
- (mk_nnb_centralManagerStatus )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

@end

NS_ASSUME_NONNULL_END
