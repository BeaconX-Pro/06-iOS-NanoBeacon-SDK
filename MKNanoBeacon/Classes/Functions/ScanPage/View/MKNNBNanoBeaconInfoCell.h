//
//  MKNNBNanoBeaconInfoCell.h
//  MKNanoBeacon_Example
//
//  Created by aa on 2024/9/11.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNNBNanoBeaconInfoCellModel : NSObject

@property (nonatomic, copy)NSString *temperature;

@property (nonatomic, assign)NSInteger lastCutoffStatus;

@property (nonatomic, assign)NSInteger lastBtnStatus;

@property (nonatomic, assign)BOOL cutOffTrigger;

@property (nonatomic, assign)BOOL buttonTrigger;

@property (nonatomic, copy)NSString *runningTime;

@end

@interface MKNNBNanoBeaconInfoCell : MKBaseCell

@property (nonatomic, strong)MKNNBNanoBeaconInfoCellModel *dataModel;

+ (MKNNBNanoBeaconInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
