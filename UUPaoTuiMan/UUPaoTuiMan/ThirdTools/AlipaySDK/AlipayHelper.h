//
//  AlipayHelper.h
//  SMSX
//
//  Created by smsx on 16/2/3.
//  Copyright © 2016年 ZZDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TradeRefund.h"

typedef void(^AlipayResult)(NSDictionary *result);


//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;

@end


@interface AlipayHelper : NSObject

+ (AlipayHelper *)shared;
- (void)alipay:(Product *)product block:(AlipayResult)block;
- (void)alipayTradeRefund:(TradeRefund *)payRefund block:(AlipayResult)block;
- (NSString *)generateTradeNO;
@end
