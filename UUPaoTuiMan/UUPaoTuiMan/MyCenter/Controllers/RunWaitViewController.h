//
//  RunWaitViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/10.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "PNBaseViewController.h"
#import "OrderListModel.h"
@interface RunWaitViewController : PNBaseViewController
@property(nonatomic, strong) OrderListModel *listModel;
@property(nonatomic, assign) BOOL isWait;
@end
