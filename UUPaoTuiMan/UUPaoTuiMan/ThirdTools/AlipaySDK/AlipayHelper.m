//
//  AlipayHelper.m
//  SMSX
//
//  Created by smsx on 16/2/3.
//  Copyright © 2016年 ZZDK. All rights reserved.
//
//////////////////////////支付宝//////////////////////////////
#define AlipayPARTNER           @"2088721525396293"  //飕飕跑腿
#define AlipaySELLER            @"1285299969@qq.com"
#define AlipayRSA_PRIVATE       @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJez3E0HCZKwEJSSBxDpV5F20VBuhTTyDHNRN/9D4tEIbn4beTsRYvi7M/FLXMc7nnZfVHTNhcnqMSmr6WUVm8CEORiroiR8u6ChlUkRzR7OJBVXfcYYhdse3a3cc/7F2GXT8CKLUX9RemNx8U7b2+FUzsfnDvL6VHM1DJPeuuMtAgMBAAECgYBul6eV2/iFoKcluGNAV+wH1sf3S+r+UyrycpZRGItk+jGa66pwfldZnxfZ46fqcrMt9odac24CaiGXEIWgtKULDlRcX14ZJ7RKTH0rlJQfNfDFsZNaFcgiPGr5AuZVYxMqqGMgeGKaFUpq+5zOjLeJhcMuU1nWz3iNoaLu6t+xAQJBANnKgJVsyZrWlkrYVuf/HzZ/uKouohVIcezXtFcX+vZ7s4DJxKYBTOPiLjOeYAKcaLo0pXf61ksk9EOv90c3kW0CQQCyUSx1Hxw2sQyru6z5TxhlLwePSAmYi7MrClr83hLWb/X5jP5glDIbcIYDYRVNQ4gHVTNQmEAbG+Z5NLNdh0DBAkBfv1NAXg9T7zsrtGigndyPDR+WUeIYET1kroAuOfCvJDsKR6oYgUHYfbtqHhp/i1vPYQ3N7Y0AhEKO73F68ccRAkAMZ4cvMpXU3CYkgC69PRpWV5owBnPcb8Nr+BFyS8SFtE4pKPy9HTILJJ29+G/x6wO4dt3V+nFjMWKsBdWAaRtBAkEAkqRcfwldDZUJbf3u108HCVItH1SmAb6LnvNfOTj3NeWGzG6WMvSZsxnMwQjlQj6K9LR2940Mx8VcoXWUeHek1g=="
#define AlipayRSA_ALIPAY_PUBLIC @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCXs9xNBwmSsBCUkgcQ6VeRdtFQboU08gxzUTf/Q+LRCG5+G3k7EWL4uzPxS1zHO552X1R0zYXJ6jEpq+llFZvAhDkYq6IkfLugoZVJEc0eziQVV33GGIXbHt2t3HP+xdhl0/Aii1F/UXpjcfFO29vhVM7H5w7y+lRzNQyT3rrjLQIDAQAB"
//获取服务器端支付数据地址（商户自定义）
#define AlipayBackURL           @"https:www.baidu.com"

#import "AlipayHelper.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation Product


@end

@implementation AlipayHelper

+ (AlipayHelper *)shared
{
    static AlipayHelper *_alipay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alipay = [[AlipayHelper alloc]init];
    });
    return _alipay;
}


- (void)alipay:(Product *)product block:(AlipayResult)block
{
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = AlipayPARTNER;
    NSString *seller = AlipaySELLER;
    NSString *privateKey = AlipayRSA_PRIVATE;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = product.orderId; //订单ID（由商家自行制定）
    order.productName =  product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.notifyURL =  AlipayBackURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipayPayPaotuiMan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
     
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
         {
             NSLog(@"reslut = %@",resultDic);
             block(resultDic);
         }];
    }

}

- (void)alipayTradeRefund:(TradeRefund *)payRefund  block:(AlipayResult)block{
    NSString *privateKey = AlipayRSA_PRIVATE;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [payRefund description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"",
                       orderSpec, signedString];
        NSString *registerStr = [NSString stringWithFormat:@"https://openapi.alipay.com/gateway.do?%@",orderSpec];
        NSString *newStr = [registerStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:@"%@&sign=%@", newStr,signedString];
        [NetDataRequest GetAliPayTraderRefundWith:str Success:^(id resobject) {
            block(resobject);
        } errors:^(id errors) {
            NSLog(@"退款失败--%@", errors);
        }];
    }
}

+ (NSArray *)getAStringOfChineseCharacters:(NSString *)string
{
    if (string == nil || [string isEqual:@""])
    {
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i=0; i<string.length; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [string substringWithRange:range];
        const char *c = [subStr UTF8String];
        if (strlen(c)==3)
        {
            [arr addObject:subStr];
        }
    }
    return arr;
}


#pragma mark - 产生随机订单号


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
