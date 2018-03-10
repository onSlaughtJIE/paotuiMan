//
//  NetDataRequest.m
//  SimulateForSaltedfish
//
//  Created by 张博 on 17/6/6.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import "NetDataRequest.h"
#define URL_MIDDLE @"/PhalApi/Public/runner/?"
#define MD5_STRING @"123456"

#define URL_UID [XLUserMessage getUserID]
@implementation NetDataRequest

#pragma mark --- 登录
+ (void)userLoginWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *url = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.PaonanLogin"];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [QYNetworkManager RequestPOSTWithURLStr:url parDic:muDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark --- 注册
+ (void)userRegisterWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.PaonanRegister"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark --- 找回密码
+ (void)userForgetPasswordWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.ForgetPasswd"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark --- 发送验证码
+ (void)userSendCodeWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=user.DySmsPhoneCode"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 实名认证
+ (void)UserRealNameWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.RealNameAuthentication"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 跑男资料
+ (void)CenterMessageForMeWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.PaonanInfo"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark --- 关于
+ (void)AboutWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.AboutUs"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}
#pragma mark --- 修改密码
+ (void)updatePasswordWithOld_password:(NSString *)old_password
                          new_password:(NSString *)new_password
                                 Phone:(NSString *)phone
                             PhoneCode:(NSString *)phoneCode
                               success:(void(^)(id resobject))success errors:(void(^)(id errors))errors {
    NSString *url = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.ChangePwd"];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setValue:URL_UID forKey:@"nid"];
    [muDic setValue:old_password forKey:@"password"];
    [muDic setValue:new_password forKey:@"newPassword"];
    [muDic setValue:phone forKey:@"mobile"];
    [muDic setValue:phoneCode forKey:@"phoneCode"];
    [QYNetworkManager RequestPOSTWithURLStr:url parDic:muDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}


#pragma mark ------- 银行卡列表
+ (void)BankWithOrderLisSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.BankCardLists"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 绑定银行卡
+ (void)BindingBankWithCardHolder:(NSString *)cardHolder
                       CardNumber:(NSString *)cardNumber
                        Card_type:(NSString *)card_type
                          success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.BindBankCard"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:cardHolder forKey:@"cardHolder"];
    [dic setValue:cardNumber forKey:@"cardNumber"];
    [dic setValue:card_type forKey:@"card_type"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 申请解约
+ (void)ApplyForendWithLoginPassword:(NSString *)password success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.ApplyForSurrender"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:password forKey:@"password"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}
#pragma mark ------- 修改个人资料
+ (void)UpdateUserNameWithGender:(NSString *)gender icon:(NSString *)icon success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.SavePaonanInfo"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:gender forKey:@"sex"];
    [dic setValue:icon forKey:@"avator"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 消息中心
+ (void)MessageCenterWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.NotificationMessage"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 完成订单列表
+ (void)OrderAchieveListWithStatus:(NSString *)status Page:(NSString *)page Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.FinishOrderList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:page forKey:@"page"];
    [dic setValue:status forKey:@"status"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 账户余额
+ (void)AccountMoneyWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.AccountBalance"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark --- 余额提现
+ (void)UserMoneyTiXianWithMoney:(NSString *)money BankCard:(NSString *)bankCard success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.WithDraw"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:money forKey:@"money"];
    [dic setValue:bankCard forKey:@"bankCardId"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 听单列表
+ (void)UserListenOrderWithLng:(NSString *)lng Lat:(NSString *)lat success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.ListenOrder"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:lng forKey:@"pn_lng"];
    [dic setValue:lat forKey:@"pn_lat"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}
#pragma mark ------- 抢单
+ (void)UserGrabOrderWithOrderid:(NSString *)orderId PaonanId:(NSString *)paotuiId success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.GrapOrder"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:paotuiId forKey:@"paotuiId"];
    [dic setValue:orderId forKey:@"orderId"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}
#pragma mark ------- 订单列表/未完成列表
+ (void)PaoNanOrderListWithOrderStatus:(NSString *)order_status	PayStatus:(NSString *)pay_status Page:(NSString *)page  PortName:(NSString *)port success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@service=%@", DOMAIN_API, URL_MIDDLE, port];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:order_status forKey:@"order_status"];
    [dic setValue:pay_status forKey:@"pay_status"];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:page forKey:@"page"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 完成跑腿订单
+ (void)AchievePaoNanOrderWithOrderId:(NSString *)orderId CodeNum:(NSString *)codeNum success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.FinishOrder"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:orderId forKey:@"orderId"];
    [dic setValue:codeNum forKey:@"codeNum"];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 获得收益列表
+ (void)ProfitsListWithStatus:(NSString *)status Page:(NSString *)page Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.GainRecording"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:page forKey:@"page"];
    [dic setValue:status forKey:@"type"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 验证是否实名认证
+ (void)GetRealNameSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.AuditState"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 交纳押金成功
+ (void)PayDepositWithMoney:(NSString *)money OrderNum:(NSString *)orderNum Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.PayDeposit"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:money forKey:@"deposit_money"];
    [dic setValue:orderNum forKey:@"out_trade_no"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(errors);
    }];
}

#pragma mark ------- 支付宝退款请求
+ (void)GetAliPayTraderRefundWith:(NSString *)payStr Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    [QYNetworkManager RequestGETWithURLStr:payStr parDic:nil Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 获取押金订单号
+ (void)GetDepositOrderWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.OutTradeNo"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestGETWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 获取押金额度
+ (void)GetDepositMoneyWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.DepositMoney"];
    [QYNetworkManager RequestGETWithURLStr:registerStr parDic:nil Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 退款
+ (void)SetDepositRefundWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.ReturnDeposit"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
     [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 商城列表
+ (void)GetMallListWithCateId:(NSString *)cate_id Page:(NSString *)page Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Shop.ShopGoodsList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:cate_id forKey:@"cate_id"];
    [dic setValue:page forKey:@"page"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}
#pragma mark ------- 商城详情
+ (void)GetMallListDetailWithProductId:(NSString *)productId Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Shop.GoodsDetail"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:productId forKey:@"product_id"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 商城购买记录
+ (void)MallRecordWithProduct_id:(NSString *)product_id Num:(NSString *)num Price:(NSString *)price Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Shop.PurchaseHistory"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:product_id forKey:@"product_id"];
    [dic setValue:num forKey:@"num"];
    [dic setValue:price forKey:@"price"];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}
#pragma mark ------- 商城购买记录列表
+ (void)GetMallListDetailWithUserIdSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Shop.RecordList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:dic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 抢单流程
+ (void)OrderFlowWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.PnOrderProcess"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:statusDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 排队流程
+ (void)OrderWaitFlowWithStatus:(NSDictionary *)statusDic RequestStr:(NSString *)url Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
//    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.PnQueueProcess"];
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, url];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:statusDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}
#pragma mark ------- 帮帮流程
+ (void)OrderHelpFlowWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=PnBusiness.PnHelpProcess"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:statusDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 订单详情
+ (void)OrderDetailWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Order.OrderDetail"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:statusDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark ------- 消息详情
+ (void)MessageDetailWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors{
    NSString *registerStr = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.MessageDetail"];
    [QYNetworkManager RequestPOSTWithURLStr:registerStr parDic:statusDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

#pragma mark --- 意见反馈
+ (void)SuggestionsForUserWithmobile:(NSString *)mobile
                             content:(NSString *)content
                             success:(void(^)(id resobject))success errors:(void(^)(id errors))errors {
    NSString *url = [NSString stringWithFormat:@"%@%@%@", DOMAIN_API, URL_MIDDLE, @"service=Paonan.Suggestions"];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setValue:URL_UID forKey:@"nid"];
    [muDic setValue:mobile forKey:@"mobile"];
    [muDic setValue:content forKey:@"content"];
    [QYNetworkManager RequestPOSTWithURLStr:url parDic:muDic Finish:^(id resobject) {
        success(resobject);
    } conError:^(NSError *error) {
        errors(error);
    }];
}

@end
