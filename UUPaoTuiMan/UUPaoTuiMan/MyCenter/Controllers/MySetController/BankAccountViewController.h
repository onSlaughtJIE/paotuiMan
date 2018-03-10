//
//  BankAccountViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "PNBaseViewController.h"

@interface BankAccountViewController : PNBaseViewController
@property(nonatomic, copy) NSString *cardNumber;
@property(nonatomic, assign) BOOL isTiXian;
@property(nonatomic, copy) void(^selectBankBlock)(NSString *, NSString *);
@end
