//
//  XLUserMessage.h
//  LotteryAPP
//
//  Created by qianyuan on 17/5/9.
//  Copyright © 2017年 昔洛. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XLUserMessage : NSObject
/**      **/
+ (void)setUserCook:(NSString *)cook;
+ (NSString *)getUserCook;
/***  用户名  ***/
+ (void)setUserName:(NSString *)name;
+ (NSString *)getUserName;

/***  用户ID  ***/
+ (void)setUserID:(NSString *)userid;
+ (NSString *)getUserID;
/***  用户密码  ***/
+ (void)setUserPassword:(NSString *)Password;
+ (NSString *)getUserPassword;
/***  用户余额  ***/
+ (void)setUserMoney:(NSString *)Money;
+ (NSString *)getUserMoney;

/***  用户icon  ***/
+ (void)setUserIcon:(NSString *)usericon;
+ (NSString *)getUserIcon;

/***  用户手机  ***/
+ (void)setUserPhone:(NSString *)userphone;
+ (NSString *)getuserphone;

/*   保存登录状态   */
+ (void)setUserLogin:(BOOL)login;
+ (BOOL)getUserLogin;

/***  用户收货地址  ***/
+ (void)setUserAddress:(NSDictionary *)address;
+ (NSDictionary *)getUserAddress;
/*** 存储所有地址区域数组 ***/
+ (void)setAllProvinceArr:(NSArray *)addressarr;
+ (NSArray *)getAllProvinceArr;
/*   是否已经获取所有地址信息   */
+ (void)setIsOkAllProvince:(BOOL)isOk;
+ (BOOL)getIsOkAllProvince;

/***  推广跑男二维码  ***/
+ (void)setPaoNanIcon:(NSString *)icon;
+ (NSString *)getsePaoNanIcon;

+ (void)loginOut;

/***  是否实名认证  ***/
+ (void)setPaoNanRealName:(BOOL)realName;
+ (BOOL)getPaoNanRealName;

/***  是否交纳押金  ***/
+ (void)setPaoNanDeposit:(BOOL)deposit;
+ (BOOL)getPaoNanDeposit;

/***  保存押金订单号  ***/
+ (void)setDepositOrderNum:(NSString *)OrderNum;
+ (NSString *)getPaoNanOrderNum;


/***  当前地理位置经纬度  ***/
+ (void)setAddressLocationLat:(NSString *)AddressLocationLat;
+ (NSString *)getAddressLocationLat;
+ (void)setAddressLocationLng:(NSString *)AddressLocationLng;
+ (NSString *)getAddressLocationLng;

@end
