//
//  MKNNBBaseBeacon.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKNNBBaseBeacon.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKNNBAdopter.h"

@implementation MKNNBBaseBeacon

+ (NSArray <MKNNBBaseBeacon *>*)parseAdvData:(NSDictionary *)advData {
    if (!MKValidDict(advData)) {
        return @[];
    }
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    NSData *manufacturerData = advData[CBAdvertisementDataManufacturerDataKey];
    if ([[manufacturerData subdataWithRange:NSMakeRange(0, 2)] isEqualToData:[MKBLEBaseSDKAdopter stringToData:@"0505"]] && manufacturerData.length == 17) {
        MKNNBNanoBeaconInfoBeacon *beacon = [[MKNNBNanoBeaconInfoBeacon alloc] initWithAdvertiseData:manufacturerData];
        beacon.advertiseData = manufacturerData;
        beacon.frameType = MKNNBNanoBeaconInfoFrameType;
        return @[beacon];
    }
    NSMutableArray *beaconList = [NSMutableArray array];
    NSArray *keys = [advDic allKeys];
    for (id key in keys) {
        if ([key isEqual:[CBUUID UUIDWithString:@"FEAA"]]) {
            NSData *feaaData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            if (MKValidData(feaaData)) {
                MKNNBDataFrameType frameType = [self fetchFEAAFrameType:feaaData];
                MKNNBBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feaaData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"EA01"]]) {
            NSData *feabData = advDic[[CBUUID UUIDWithString:@"EA01"]];
            if (MKValidData(feabData)) {
                MKNNBDataFrameType frameType = [self fetchEA01FrameType:feabData];
                MKNNBBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feabData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }
    }
    return beaconList;
}

+ (MKNNBBaseBeacon *)fetchBaseBeaconWithFrameType:(MKNNBDataFrameType)frameType advData:(NSData *)advData {
    MKNNBBaseBeacon *beacon = nil;
    switch (frameType) {
        case MKNNBUIDFrameType:
            beacon = [[MKNNBUIDBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKNNBURLFrameType:
            beacon = [[MKNNBURLBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKNNBTLMFrameType:
            beacon = [[MKNNBTLMBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKNNBSensorInfoFrameType:
            beacon = [[MKNNBSensorInfoBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        default:
            return nil;
    }
    beacon.frameType = frameType;
    return beacon;
}

+ (MKNNBDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData {
    if (slotData.length == 0) {
        return MKNNBUnknownFrameType;
    }
    const unsigned char *cData = [slotData bytes];
    switch (*cData) {
        case 0x00:
            return MKNNBUIDFrameType;
        case 0x10:
            return MKNNBURLFrameType;
        case 0x20:
            return MKNNBTLMFrameType;
        case 0x82:
            return MKNNBSensorInfoFrameType;
        default:
            return MKNNBUnknownFrameType;
    }
}

+ (MKNNBDataFrameType)fetchFEAAFrameType:(NSData *)stoneData {
    if (!MKValidData(stoneData)) {
        return MKNNBUnknownFrameType;
    }
    //Eddystone信息帧
    if (stoneData.length == 0) {
        return MKNNBUnknownFrameType;
    }
    const unsigned char *cData = [stoneData bytes];
    switch (*cData) {
        case 0x00:
            return MKNNBUIDFrameType;
        case 0x10:
            return MKNNBURLFrameType;
        case 0x20:
            return MKNNBTLMFrameType;
        default:
            return MKNNBUnknownFrameType;
    }
}

+ (MKNNBDataFrameType)fetchEA01FrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKNNBUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x82:
            return MKNNBSensorInfoFrameType;
        default:
            return MKNNBUnknownFrameType;
    }
}

+ (MKNNBDataFrameType)fetchFrameTypeWithAdvData:(NSDictionary *)advDic {
    NSData *stoneData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
    if (MKValidData(stoneData)) {
        //Eddystone信息帧
        if (stoneData.length == 0) {
            return MKNNBUnknownFrameType;
        }
        const unsigned char *cData = [stoneData bytes];
        switch (*cData) {
            case 0x00:
                return MKNNBUIDFrameType;
            case 0x10:
                return MKNNBURLFrameType;
            case 0x20:
                return MKNNBTLMFrameType;
            default:
                return MKNNBUnknownFrameType;
        }
    }
    NSData *customData = advDic[[CBUUID UUIDWithString:@"EA01"]];
    if (!MKValidData(customData) || customData.length == 0) {
        return MKNNBUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x82:
            return MKNNBSensorInfoFrameType;
        default:
            return MKNNBUnknownFrameType;
    }
}

@end

@implementation MKNNBUIDBeacon

- (MKNNBUIDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advData.length < 18) {
            return nil;
        }
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        NSAssert(data, @"failed to malloc");
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        self.namespaceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",*(data+2), *(data+3), *(data+4), *(data+5), *(data+6), *(data+7), *(data+8), *(data+9), *(data+10), *(data+11)];
        self.instanceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*(data+12), *(data+13), *(data+14), *(data+15), *(data+16), *(data+17)];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKNNBURLBeacon

- (MKNNBURLBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 3), @"Invalid advertiseData:%@", advData);
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *urlScheme = [MKNNBAdopter getUrlscheme:*(data+2)];
        
        NSString *url = urlScheme;
        for (int i = 0; i < advData.length - 3; i++) {
            url = [url stringByAppendingString:[MKNNBAdopter getEncodedString:*(data + i + 3)]];
        }
        self.shortUrl = url;
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKNNBTLMBeacon

- (MKNNBTLMBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 14), @"Invalid advertiseData:%@", advData);
        
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        /* [TDOO] Set TML Beacon Properties */
        self.version = [NSNumber numberWithInt:*(data+1)];
        self.mvPerbit = [NSNumber numberWithInt:((*(data+2) << 8) + *(data+3))];
        unsigned char temperatureInt = *(data+4);
        if (temperatureInt & 0x80) {
            self.temperature = [NSNumber numberWithFloat:(float)(- 0x100 + temperatureInt) + *(data+5) / 256.0];
        }
        else {
            self.temperature = [NSNumber numberWithFloat:(float)temperatureInt + *(data+5) / 256.0];
        }
        float advertiseCount = (*(data+6) * 16777216) + (*(data+7) * 65536) + (*(data+8) * 256) + *(data+9);
        self.advertiseCount = [NSNumber numberWithLong:advertiseCount];
        float deciSecondsSinceBoot = (((int)(*(data+10) * 16777216) + (int)(*(data+11) * 65536) + (int)(*(data+12) * 256) + *(data+13)) / 10.0);
        self.deciSecondsSinceBoot = [NSNumber numberWithFloat:deciSecondsSinceBoot];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end


@implementation MKNNBSensorInfoBeacon

- (MKNNBSensorInfoBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        NSString *temperatureContent = [content substringWithRange:NSMakeRange(24, 4)];
        if (![[temperatureContent uppercaseString] isEqualToString:@"FFFF"]) {
            NSInteger intTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:temperatureContent] integerValue];
            float roundedResult = round(((intTemp >> 4) * 0.0625) * 10) / 10.0;
            self.temperature = [NSString stringWithFormat:@"%.1f", roundedResult];
        }
        
        self.battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 4)];
        self.tagID = [content substringFromIndex:36];
    }
    return self;
}

@end


@implementation MKNNBNanoBeaconInfoBeacon

- (MKNNBNanoBeaconInfoBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        NSInteger index = 4;
        self.trigger = [[content substringWithRange:NSMakeRange(index, 2)] isEqualToString:@"01"];
        index += 2;
        NSInteger tempVol = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(index, 2)];
        self.voltage = [NSString stringWithFormat:@"%ld", (long)(tempVol * 31.25)];
        index += 2;
        NSString *tempTemp1 = [content substringWithRange:NSMakeRange(index, 2)];
        index += 2;
        NSString *tempTemp2 = [content substringWithRange:NSMakeRange(index, 2)];
        index += 2;
        NSString *tempTemp = [tempTemp2 stringByAppendingString:tempTemp1];
        NSInteger intTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:tempTemp] integerValue];
        self.temperature = [NSString stringWithFormat:@"%.1f", (intTemp * 0.01)];
        
        NSString *tempSecCnt1 = [content substringWithRange:NSMakeRange(index, 2)];
        index += 2;
        NSString *tempSecCnt2 = [content substringWithRange:NSMakeRange(index, 2)];
        index += 2;
        NSString *tempSecCnt3 = [content substringWithRange:NSMakeRange(index, 2)];
        index += 2;
        NSString *tempSecCnt4 = [content substringWithRange:NSMakeRange(index, 2)];
        index += 2;
        NSString *tempSecCnt = [NSString stringWithFormat:@"%@%@%@%@",tempSecCnt4,tempSecCnt3,tempSecCnt2,tempSecCnt1];
        self.secCnt = [MKBLEBaseSDKAdopter getDecimalStringWithHex:tempSecCnt range:NSMakeRange(0, tempSecCnt.length)];
        NSString *tempStatus = [content substringWithRange:NSMakeRange(index, 2)];
        NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:tempStatus];
        self.cutoffStatus = [[binary substringWithRange:NSMakeRange(2, 1)] integerValue];
        self.btnAlarmStatus = [[binary substringWithRange:NSMakeRange(3, 1)] integerValue];
        index += 2;
        NSString *tempMac = [[content substringWithRange:NSMakeRange(index, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",
        [tempMac substringWithRange:NSMakeRange(10, 2)],
        [tempMac substringWithRange:NSMakeRange(8, 2)],
        [tempMac substringWithRange:NSMakeRange(6, 2)],
        [tempMac substringWithRange:NSMakeRange(4, 2)],
        [tempMac substringWithRange:NSMakeRange(2, 2)],
        [tempMac substringWithRange:NSMakeRange(0, 2)]];
        self.macAddress = macAddress;
    }
    return self;
}

@end
