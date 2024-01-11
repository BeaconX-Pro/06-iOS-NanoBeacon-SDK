//
//  Target_nnb_Module.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2021/3/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "Target_nnb_Module.h"

#import "MKNNBScanViewController.h"

@implementation Target_nnb_Module

- (UIViewController *)Action_nnb_Module_ScanController:(NSDictionary *)params {
    return [[MKNNBScanViewController alloc] init];
}

@end
