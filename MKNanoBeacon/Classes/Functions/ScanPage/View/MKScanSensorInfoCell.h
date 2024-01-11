//
//  MKScanSensorInfoCell.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/1/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKScanSensorInfoCellModel : NSObject

@property (nonatomic, copy)NSString *temperature;

@end

@interface MKScanSensorInfoCell : MKBaseCell

@property (nonatomic, strong)MKScanSensorInfoCellModel *dataModel;

+ (MKScanSensorInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
