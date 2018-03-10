//
//  UILabel+QYForMasonry.h
//  SimulateForSaltedfish
//
//  Created by qianyuan on 17/3/3.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (QYForMasonry)
/*创建label, 标题, 大小, 颜色, 位置*/
+(UILabel *)labelWithTitle:(NSString *)title fontSize:(CGFloat)fontSize color:(UIColor *)color alignment:(NSTextAlignment)alignment;
@end
