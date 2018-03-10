//
//  XLConvertTools.h
//  SimulateForSaltedfish
//
//  Created by qianyuan on 17/3/3.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLConvertTools : NSObject
//字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
//把 1970年时间转换成 字符串形式
+(NSString*)from1970ToStringDate:(NSString*)dateStr;
+(NSString *)getcurrentTime;
+(NSString *)chineseToUTF8:(NSString *)str;
+ (NSString *)timeSp:(NSString *)time;
//MD5加密
+ (NSString *)MD5Str:(NSString *)ocStr;
//在window上添加转圈效果
+(void)addHudToWindow;
+(void)hideHudFromWindow;

//自定义文字展示
+ (void)showNOHud:(NSString *)text delay:(NSTimeInterval)dalay;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string;
//时间转换 HH:ss:dd
+ (NSString *)timeWithHour:(NSString *)time;

#pragma mark 身份证号
+(BOOL) isValidateIdentityCard:(NSString *)string;

@end
