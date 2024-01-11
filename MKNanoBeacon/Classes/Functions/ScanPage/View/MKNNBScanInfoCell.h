//
//  MKNNBScanInfoCell.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKNNBScanInfoCellModel;

@interface MKNNBScanInfoCell : MKBaseCell

@property (nonatomic, strong)MKNNBScanInfoCellModel *dataModel;

+ (MKNNBScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
