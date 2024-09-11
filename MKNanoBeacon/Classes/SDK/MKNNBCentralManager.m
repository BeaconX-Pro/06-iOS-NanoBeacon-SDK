//
//  MKNNBCentralManager.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKNNBCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKNNBAdopter.h"
#import "MKNNBBaseBeacon.h"

NSString *const mk_nnb_centralManagerStateChangedNotification = @"mk_nnb_centralManagerStateChangedNotification";

static MKNNBCentralManager *manager = nil;
static dispatch_once_t onceToken;

//@interface NSObject (MKNNBCentralManager)
//
//@end
//
//@implementation NSObject (MKNNBCentralManager)
//
//+ (void)load{
//    [MKNNBCentralManager shared];
//}
//
//@end

@interface MKNNBCentralManager ()

@end

@implementation MKNNBCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKNNBCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKNNBCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
//    NSLog(@"%@",advertisementData);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *beaconList = [MKNNBBaseBeacon parseAdvData:advertisementData];
        if (!MKValidArray(beaconList)) {
            return;
        }
        for (NSInteger i = 0; i < beaconList.count; i ++) {
            MKNNBBaseBeacon *beaconModel = beaconList[i];
            beaconModel.identifier = peripheral.identifier.UUIDString;
            beaconModel.rssi = RSSI;
            beaconModel.peripheral = peripheral;
            beaconModel.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
        }
        if ([self.delegate respondsToSelector:@selector(mk_nnb_receiveBeacon:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate mk_nnb_receiveBeacon:beaconList];
            });
        }
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_nnb_startScan)]) {
        [self.delegate mk_nnb_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_nnb_stopScan)]) {
        [self.delegate mk_nnb_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_nnb_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_nnb_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_nnb_centralManagerStatusEnable
    : mk_nnb_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[]
                                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

@end
