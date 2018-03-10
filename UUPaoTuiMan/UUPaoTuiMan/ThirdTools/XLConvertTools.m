//
//  XLConvertTools.m
//  SimulateForSaltedfish
//
//  Created by qianyuan on 17/3/3.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import "XLConvertTools.h"
#import <CommonCrypto/CommonCrypto.h>
#import <MBProgressHUD.h>

@implementation XLConvertTools
static MBProgressHUD *hud = nil;
static BOOL isAddHud;
//单例方法
+ (MBProgressHUD *)sharedManager
{
    //线程同步块
    @synchronized(hud)
    {
        //如果没有对象创建，有的话直接返回
        if(!hud)
        {
            hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
            [hud showAnimated:YES];
            isAddHud = NO;
        }
    }
    
    return hud;
}



+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
+(void)addHudToWindow {
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
}
+(void)hideHudFromWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

+ (void)showNOHud:(NSString *)text delay:(NSTimeInterval)dalay {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
        //  过秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(dalay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];
}

//把 1970年时间转换成 字符串形式
+(NSString*)from1970ToStringDate:(NSString*)dateStr {
    NSDate * timenow = [NSDate dateWithTimeIntervalSince1970:[dateStr intValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * time = [formatter stringFromDate:timenow];
    return time;
}
+ (NSString *)timeSp:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSString* currentDateStr = [dateFormatter stringFromDate:currentDate];
    return currentDateStr;
}
+(NSString *)getcurrentTime {
    // 1. 获取当前系统的准确事件(+8小时)
    
    //    NSDate *date = [NSDate date]; // 获得时间对象
    //
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    //
    //    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    //
    //    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    
    
    
    //    2. 获取当前系统事件并设置格式
    
    NSDate *date = [NSDate date]; // 获得时间对象
    
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    
    [forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr = [forMatter stringFromDate:date];
    return dateStr  ;
}

+(NSString *)chineseToUTF8:(NSString *)str
{
    NSString *str1=[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    return str1;
}


//MD5加密
+ (NSString *)MD5Str:(NSString *)ocStr {
    
    const char *cStr = [ocStr UTF8String];
    unsigned long cStrLength = strlen(cStr);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)cStrLength, result);
    //声明一个字符串接收
    NSMutableString *secretStr = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [secretStr appendFormat:@"%02X",result[i]];
    }
    return secretStr;
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

//判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string{
    return (!string || string.length <1  || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"0"] || [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1 ||(NSNull *)self == [NSNull null] || [string isEqualToString:@""]);
}

#pragma mark 身份证号
+(BOOL) isValidateIdentityCard:(NSString *)string
{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])+$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:string];
}
//时间转换 HH:ss:dd
+ (NSString *)timeWithHour:(NSString *)time{
    NSString *hour;
//    
//    int seconds = totalSeconds % 60;
//        int minutes = (totalSeconds / 60) % 60;
//         int hours = totalSeconds / 3600;
    
    
    return hour;
}

@end
