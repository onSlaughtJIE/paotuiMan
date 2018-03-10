//
//  RunFlowViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "PNBaseViewController.h"
#import "OrderListModel.h"
@interface RunFlowViewController : PNBaseViewController

@property(nonatomic, strong) OrderListModel *listModel;
@property(nonatomic, copy) NSString *contentTitle;

@property(nonatomic, copy) void(^RunFlowAchieveBlock)(BOOL);
@end
