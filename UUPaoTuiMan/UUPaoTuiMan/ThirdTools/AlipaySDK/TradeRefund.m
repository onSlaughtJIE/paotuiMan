//
//  TradeRefund.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/1.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "TradeRefund.h"

@implementation TradeRefund

- (NSString *)description
{
    NSMutableString * discription = [NSMutableString string];
    if (self.app_id)
    {
        [discription appendFormat:@"app_id=%@",self.app_id];
    }
    if (self.biz_content)
    {
        [discription appendFormat:@"&biz_content={%@}",self.biz_content];
    }
   
    if (self.charset)
    {
        [discription appendFormat:@"&charset=%@",self.charset];
    }
    if (self.method)
    {
        [discription appendFormat:@"&method=%@", self.method];
    }
  
    if (self.sign_type)
    {
        [discription appendFormat:@"&sign_type=%@", self.sign_type];
    }
    if (self.timestamp)
    {
        [discription appendFormat:@"&timestamp=%@", self.timestamp];
    }
    if (self.version)
    {
        [discription appendFormat:@"&version=%@", self.version];
    }
  
//    for (NSString * key in [self.biz_content allKeys])
//    {    
//        [discription appendFormat:@"&%@:\"%@\"", key, [self.biz_content objectForKey:key]];
//    }
    return discription;
}
@end

