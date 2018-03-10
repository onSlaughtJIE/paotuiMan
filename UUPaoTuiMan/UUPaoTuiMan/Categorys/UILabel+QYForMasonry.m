//
//  UILabel+QYForMasonry.m
//  SimulateForSaltedfish
//
//  Created by qianyuan on 17/3/3.
//  Copyright © 2017年 飘风七叶. All rights reserved.
//

#import "UILabel+QYForMasonry.h"

@implementation UILabel (QYForMasonry)
+(UILabel *)labelWithTitle:(NSString *)title fontSize:(CGFloat)fontSize color:(UIColor *)color alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%@", title];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = alignment;
    return label;
}
@end
