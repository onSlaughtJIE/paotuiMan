//
//  TradeRefund.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/1.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeRefund : NSObject
@property(nonatomic, copy) NSString * timestamp;
@property(nonatomic, copy) NSString * method;
@property(nonatomic, copy) NSString * app_id;
@property(nonatomic, copy) NSString * sign_type;
@property(nonatomic, copy) NSString * version;
@property(nonatomic, copy) NSString * charset;
@property(nonatomic, copy) NSString * biz_content;

@end


