//
//  MKNNBScanInfoCellModel.m
//  MKNanoBeacon_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNNBScanInfoCellModel.h"

@implementation MKNNBScanInfoCellModel

- (NSMutableArray *)advertiseList {
    if (!_advertiseList) {
        _advertiseList = [NSMutableArray array];
    }
    return _advertiseList;
}

@end
