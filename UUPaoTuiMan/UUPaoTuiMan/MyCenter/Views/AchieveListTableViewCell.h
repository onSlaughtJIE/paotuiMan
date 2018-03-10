//
//  AchieveListTableViewCell.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
#import <CoreLocation/CoreLocation.h>

@interface AchieveListTableViewCell : UITableViewCell

@property(nonatomic, strong) OrderListModel *listModel;
@property(nonatomic, copy) void(^checkOrderDetailBlock)();
@property(nonatomic, strong) CLLocation *currentLocation;
@end
