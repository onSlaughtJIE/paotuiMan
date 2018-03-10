//
//  CenterMessageModel.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/29.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterMessageModel : NSObject

@property(nonatomic, copy) NSString *staff_id;
@property(nonatomic, copy) NSString *city_id;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *passwd;
@property(nonatomic, copy) NSString *face;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *total_money;
@property(nonatomic, copy) NSString *orders;
@property(nonatomic, copy) NSString *lastlogin;
@property(nonatomic, copy) NSString *loginip;
@property(nonatomic, copy) NSString *lat;
@property(nonatomic, copy) NSString *lng;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *id_number;
@property(nonatomic, copy) NSString *id_photo;
@property(nonatomic, copy) NSString *account_type;
@property(nonatomic, copy) NSString *account_name;
@property(nonatomic, copy) NSString *verify_name;
@property(nonatomic, copy) NSString *account_number;
@property(nonatomic, copy) NSString *closed;
@property(nonatomic, copy) NSString *audit;
@property(nonatomic, copy) NSString *clientip;
@property(nonatomic, copy) NSString *dateline;
@property(nonatomic, copy) NSString *tixian_percent;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *credit_score;
@property(nonatomic, copy) NSString *referee_mobile;
@property(nonatomic, copy) NSString *invitation_code;
@property(nonatomic, copy) NSString *qrcode_img;
@property(nonatomic, copy) NSString *todayOrderCount;
@property(nonatomic, copy) NSString *todayMileage;
@property(nonatomic, copy) NSString *todayMoney;
@property(nonatomic, copy) NSString *totalOrderCount;
@property(nonatomic, copy) NSString *totalMileage;
@property(nonatomic, copy) NSString *totalMoney;
@property(nonatomic, copy) NSString *is_deposit;
@property(nonatomic, copy) NSString *qrcode_img_referuser;
@property(nonatomic, copy) NSString *unreadyCount;

- (instancetype)initWithPersonMessageWithDic:(NSDictionary *)dictionary;
+(instancetype)PersonMessageWithDic:(NSDictionary *)dictionary;

@end

@interface MessageCenterModel:NSObject
@property(nonatomic, copy) NSString *msg_id;
@property(nonatomic, copy) NSString *staff_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *is_read;
@property(nonatomic, copy) NSString *clientip;
@property(nonatomic, copy) NSString *dateline;

- (instancetype)initWithMessageCenterWithDic:(NSDictionary *)dictionary;
+(instancetype)CenterMessageWithDic:(NSDictionary *)dictionary;
@end
