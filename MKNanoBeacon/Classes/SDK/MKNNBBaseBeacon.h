//
//  MKNNBBaseBeacon.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Advertising data frame type
 
 - MKNNBUIDFrameType: UID
 - MKNNBURLFrameType: URL
 - MKNNBTLMFrameType: TLM
 - MKNNBSensorInfoFrameType: Sersor Info
 - MKNNBUnkonwFrameType: Unknown
 */
typedef NS_ENUM(NSInteger, MKNNBDataFrameType) {
    MKNNBUIDFrameType,
    MKNNBURLFrameType,
    MKNNBTLMFrameType,
    MKNNBSensorInfoFrameType,
    MKNNBUnknownFrameType,
};

@class CBPeripheral;
@interface MKNNBBaseBeacon : NSObject

/**
 Frame type
 */
@property (nonatomic, assign)MKNNBDataFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;
/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
 */
@property (nonatomic, strong)NSData *advertiseData;

+ (NSArray <MKNNBBaseBeacon *>*)parseAdvData:(NSDictionary *)advData;

+ (MKNNBDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData;

@end

@interface MKNNBUIDBeacon : MKNNBBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
@property (nonatomic, copy) NSString *namespaceId;
@property (nonatomic, copy) NSString *instanceId;

- (MKNNBUIDBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKNNBURLBeacon : MKNNBBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
//URL Content
@property (nonatomic, copy) NSString *shortUrl;

- (MKNNBURLBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKNNBTLMBeacon : MKNNBBaseBeacon

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSNumber *mvPerbit;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *advertiseCount;
@property (nonatomic, strong) NSNumber *deciSecondsSinceBoot;

- (MKNNBTLMBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKNNBSensorInfoBeacon : MKNNBBaseBeacon

//Temperature
@property (nonatomic, copy) NSString *temperature;

//Battery Voltage.
@property (nonatomic, copy) NSString *battery;
//Tag ID.
@property (nonatomic, copy) NSString *tagID;

- (MKNNBSensorInfoBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

NS_ASSUME_NONNULL_END
