//
//  MKNNBAdopter.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKNNBAdopter.h"

#import <CommonCrypto/CommonCryptor.h>

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

@implementation MKNNBAdopter

+ (BOOL)isPassword:(NSString *)password{
    if (!MKValidStr(password) || password.length > 16) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkUrl:(NSString *)url{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

+ (BOOL)isNameSpace:(NSString *)nameSpace{
    NSString *regex = @"^[a-fA-F0-9]{20}$$";
    NSPredicate *nameSpacePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [nameSpacePre evaluateWithObject:nameSpace];
}

+ (BOOL)isInstanceID:(NSString *)instanceID{
    NSString *regex = @"^[a-fA-F0-9]{12}$$";
    NSPredicate *instanceIDPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [instanceIDPre evaluateWithObject:instanceID];
}

+ (BOOL)checkUrlContent:(NSString *)urlContent{
    if (!MKValidStr(urlContent)) {
        return NO;
    }
    NSArray *contentList = @[@".com/",@".org/",@".edu/",@".net/",@".info/",@".biz/",@".gov/",@".com",@".org",@".edu",@".net",@".info",@".biz",@".gov"];
    return ![contentList containsObject:urlContent];
}

+ (NSString *)getUrlscheme:(char)hexChar{
    switch (hexChar) {
        case 0x00:
            return @"http://www.";
        case 0x01:
            return @"https://www.";
        case 0x02:
            return @"http://";
        case 0x03:
            return @"https://";
        default:
            return @"";
    }
}

+ (NSString *)getEncodedString:(char)hexChar{
    switch (hexChar) {
        case 0x00:
            return @".com/";
        case 0x01:
            return @".org/";
        case 0x02:
            return @".edu/";
        case 0x03:
            return @".net/";
        case 0x04:
            return @".info/";
        case 0x05:
            return @".biz/";
        case 0x06:
            return @".gov/";
        case 0x07:
            return @".com";
        case 0x08:
            return @".org";
        case 0x09:
            return @".edu";
        case 0x0a:
            return @".net";
        case 0x0b:
            return @".info";
        case 0x0c:
            return @".biz";
        case 0x0d:
            return @".gov";
        default:
            return [NSString stringWithFormat:@"%c", hexChar];
    }
}

@end
