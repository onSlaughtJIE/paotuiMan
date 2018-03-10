//
//  XLUserMessage.m
//  LotteryAPP
//
//  Created by qianyuan on 17/5/9.
//  Copyright © 2017年 昔洛. All rights reserved.
//

#import "XLUserMessage.h"

#define UserName @"username"
#define UserPassword @"password"
#define UserID @"userid"
#define UserMoney @"amount"
#define UserCook @"UserCook"
#define UserLogin @"isLogin"
#define UserIcon @"usericon"
#define Userphone @"Userphone"
#define UserRealName @"UserRealName"
#define UserDeposit @"UserDeposit"

@implementation XLUserMessage

+ (void)setUserCook:(NSString *)cook {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:cook forKey:UserCook];
    [userdefaults synchronize];

}
+ (NSString *)getUserCook {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserCook];
}
/***  用户名  ***/
+ (void)setUserName:(NSString *)name {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:name forKey:UserName];
    [userdefaults synchronize];
}
+ (NSString *)getUserName {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserName];
}
/***  用户ID  ***/
+ (void)setUserID:(NSString *)userid {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userid forKey:UserID];
    [userdefaults synchronize];
}
+ (NSString *)getUserID {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserID];
}
/***  用户密码  ***/
+ (void)setUserPassword:(NSString *)Password {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:Password forKey:UserPassword];
    [userdefaults synchronize];

}
+ (NSString *)getUserPassword {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserName];
}
/***  用户余额  ***/
+ (void)setUserMoney:(NSString *)Money {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:Money forKey:UserMoney];
    [userdefaults synchronize];
}
+ (NSString *)getUserMoney {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserMoney];
}

/***  用户手机  ***/
+ (void)setUserPhone:(NSString *)userphone {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:userphone forKey:Userphone];
    [userdefaults synchronize];
}
+ (NSString *)getuserphone {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:Userphone];
}
/*   保存登录状态   */
+ (void)setUserLogin:(BOOL)login {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:login forKey:UserLogin];
    [userdefaults synchronize];

}
+ (BOOL)getUserLogin {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserLogin];
}

/*   是否已经获取所有地址信息   */
+ (void)setIsOkAllProvince:(BOOL)isOk {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:isOk forKey:@"isOkOfAllProvince"];
    [userdefaults synchronize];
}
+ (BOOL)getIsOkAllProvince {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"isOkOfAllProvince"];
}

/***  用户icon  ***/
+ (void)setUserIcon:(NSString *)usericon {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:usericon forKey:UserIcon];
    [userdefaults synchronize];
}
+ (NSString *)getUserIcon {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:UserIcon];
}
/***  用户收货地址  ***/
+ (void)setUserAddress:(NSDictionary *)address {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:address forKey:@"allprocity"];
    [userdefaults synchronize];
}
+ (NSDictionary *)getUserAddress {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"allprocity"];
}

/*** 存储所有地址区域数组 ***/
+ (void)setAllProvinceArr:(NSArray *)addressarr {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:addressarr forKey:@"allAddress"];
    [userdefaults synchronize];
}
+ (NSArray *)getAllProvinceArr {
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"allAddress"];
}
+ (void)loginOut {
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults  removeObjectForKey:UserName];
    [userdefaults removeObjectForKey:UserMoney];
    [userdefaults removeObjectForKey:UserLogin];
    [userdefaults removeObjectForKey:UserCook];
    [userdefaults removeObjectForKey:UserID];
    [userdefaults removeObjectForKey:UserIcon];
    [userdefaults removeObjectForKey:@"isRealName"];
    [userdefaults removeObjectForKey:@"isDeposit"];
}

/***  推广跑男二维码  ***/
+ (void)setPaoNanIcon:(NSString *)icon{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:icon forKey:@"paonanIcon"];
    [userdefaults synchronize];

}
+ (NSString *)getsePaoNanIcon{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"paonanIcon"];
}

/***  是否实名认证  ***/
+ (void)setPaoNanRealName:(BOOL)realName{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:realName forKey:UserRealName];
    [userdefaults synchronize];
}
+ (BOOL)getPaoNanRealName{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults boolForKey:UserRealName];
}
/***  是否交纳押金  ***/
+ (void)setPaoNanDeposit:(BOOL)deposit{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setBool:deposit forKey:UserDeposit];
    [userdefaults synchronize];
}
+ (BOOL)getPaoNanDeposit{
    return [[NSUserDefaults standardUserDefaults] boolForKey:UserDeposit];
}

/***  保存押金订单号  ***/
+ (void)setDepositOrderNum:(NSString *)OrderNum{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:OrderNum forKey:@"OrderNum"];
    [userdefaults synchronize];
}
+ (NSString *)getPaoNanOrderNum{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"OrderNum"];
}

//当前经纬度
+ (void)setAddressLocationLat:(NSString *)AddressLocationLat{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:AddressLocationLat forKey:@"AddressLocationLat"];
    [userdefaults synchronize];
}
+ (NSString *)getAddressLocationLat{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"AddressLocationLat"];
}
+ (void)setAddressLocationLng:(NSString *)AddressLocationLng{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    [userdefaults setObject:AddressLocationLng forKey:@"AddressLocationLng"];
    [userdefaults synchronize];
}
+ (NSString *)getAddressLocationLng{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    return [userdefaults objectForKey:@"AddressLocationLng"];
}

@end
