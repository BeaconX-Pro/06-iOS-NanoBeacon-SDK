//
//  MKNNBAdopter.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNNBAdopter : NSObject

+ (BOOL)isPassword:(NSString *)password;
+ (BOOL)isNameSpace:(NSString *)nameSpace;
+ (BOOL)isInstanceID:(NSString *)instanceID;
+ (BOOL)checkUrlContent:(NSString *)urlContent;

+ (NSString *)getUrlscheme:(char)hexChar;
+ (NSString *)getEncodedString:(char)hexChar;


@end

NS_ASSUME_NONNULL_END
