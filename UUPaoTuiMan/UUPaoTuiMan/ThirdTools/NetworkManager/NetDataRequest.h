//
//  NetDataRequest.h
//  SimulateForSaltedfish
//
//  Created by 张博 on 17/6/6.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYNetworkManager.h"
@interface NetDataRequest : NSObject

#pragma mark --- 登录
+ (void)userLoginWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark --- 注册
+ (void)userRegisterWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark --- 找回密码
+ (void)userForgetPasswordWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
#pragma mark ------- 发送验证码
+ (void)userSendCodeWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
#pragma mark ------- 实名认证
+ (void)UserRealNameWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 我的资料
+ (void)CenterMessageForMeWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark --- 关于
+ (void)AboutWithDic:(NSDictionary *)dic success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark --- 修改密码
+ (void)updatePasswordWithOld_password:(NSString *)old_password
                          new_password:(NSString *)new_password
                                 Phone:(NSString *)phone
                             PhoneCode:(NSString *)phoneCode
                               success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 银行卡列表
+ (void)BankWithOrderLisSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 绑定银行卡
+ (void)BindingBankWithCardHolder:(NSString *)cardHolder
                       CardNumber:(NSString *)cardNumber
                        Card_type:(NSString *)card_type
                          success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 申请解约
+ (void)ApplyForendWithLoginPassword:(NSString *)password success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
#pragma mark ------- 修改个人资料
+ (void)UpdateUserNameWithGender:(NSString *)gender icon:(NSString *)icon success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 消息中心
+ (void)MessageCenterWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 完成订单列表
+ (void)OrderAchieveListWithStatus:(NSString *)status Page:(NSString *)page Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 账户余额
+ (void)AccountMoneyWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark --- 余额提现
+ (void)UserMoneyTiXianWithMoney:(NSString *)money BankCard:(NSString *)bankCard success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 听单列表
+ (void)UserListenOrderWithLng:(NSString *)lng Lat:(NSString *)lat success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 抢单
+ (void)UserGrabOrderWithOrderid:(NSString *)orderId PaonanId:(NSString *)paotuiId success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 订单列表
+ (void)PaoNanOrderListWithOrderStatus:(NSString *)order_status	PayStatus:(NSString *)pay_status Page:(NSString *)page PortName:(NSString *)port success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 完成跑腿订单
+ (void)AchievePaoNanOrderWithOrderId:(NSString *)orderId CodeNum:(NSString *)codeNum success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 获得收益列表
+ (void)ProfitsListWithStatus:(NSString *)status Page:(NSString *)page Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 验证是否实名认证
+ (void)GetRealNameSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 交纳押金成功
+ (void)PayDepositWithMoney:(NSString *)money OrderNum:(NSString *)orderNum Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 支付宝退款请求
+ (void)GetAliPayTraderRefundWith:(NSString *)payStr Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 获取押金订单号
+ (void)GetDepositOrderWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 获取押金额度
+ (void)GetDepositMoneyWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 退款
+ (void)SetDepositRefundWithSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 商城列表
+ (void)GetMallListWithCateId:(NSString *)cate_id Page:(NSString *)page Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
#pragma mark ------- 商城详情
+ (void)GetMallListDetailWithProductId:(NSString *)productId Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 商城购买记录
+ (void)MallRecordWithProduct_id:(NSString *)product_id Num:(NSString *)num Price:(NSString *)price Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
#pragma mark ------- 商城购买记录列表
+ (void)GetMallListDetailWithUserIdSuccess:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 抢单流程
+ (void)OrderFlowWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 排队流程
+ (void)OrderWaitFlowWithStatus:(NSDictionary *)statusDic RequestStr:(NSString *)url Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
#pragma mark ------- 帮帮流程
+ (void)OrderHelpFlowWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 订单详情
+ (void)OrderDetailWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark ------- 消息详情
+ (void)MessageDetailWithStatus:(NSDictionary *)statusDic Success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;

#pragma mark --- 意见反馈
+ (void)SuggestionsForUserWithmobile:(NSString *)mobile
                             content:(NSString *)content
                             success:(void(^)(id resobject))success errors:(void(^)(id errors))errors;
@end

