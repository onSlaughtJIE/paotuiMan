//
//  HomeListViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/8.
//  Copyright © 2017年 qianyuan. All rights reserved.
//
#import "PNBaseViewController.h"
@interface HomeListViewController : PNBaseViewController
@property(nonatomic, copy) NSString *orderStatus;

- (void)getRefreshData;
@end
