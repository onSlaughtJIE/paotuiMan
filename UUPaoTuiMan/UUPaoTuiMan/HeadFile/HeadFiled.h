//
//  HeadFiled.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#ifndef HeadFiled_h
#define HeadFiled_h
#define DOMAIN_API @"http://192.168.1.105"
//#define DOMAIN_API @"http://pt.zqyht.com"

#define kCall @"037160907258"

/*
 屏幕尺寸
 */

#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define DefaultFont(__scale) [UIFont systemFontOfSize:14*__scale];


//16进制RGB的颜色转换
#define XLColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define backViewColor [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]

//R G B A颜色
#define XLColorFromRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//导航栏颜色
#define NavBarColor [UIColor colorWithRed:206/255.0 green:0/255.0 blue:33/255.0 alpha:1.0]
/**  */
#define BLACK_COLOR [UIColor blackColor]
/**  */
#define DARKGRAY_COLOR [UIColor darkGrayColor]
/**  */
#define LIGHTGRAY_COLOR [UIColor lightGrayColor]
/**  */
#define WHITE_COLOR [UIColor whiteColor]
/**  */
#define GRAY_COLOR [UIColor grayColor]
/**  */
#define RED_COLOR  NavBarColor
/**  */
#define ORANGE_COLOR [UIColor orangeColor]
/**  */
#define CLEAR_COLOR [UIColor clearColor]

#define RANDOM_COLOR [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

//灰色背景色
#define GRAY_BACKGROUND_COLOR XLColorFromRGB(240, 240, 240, 1)

#endif /* HeadFiled_h */
