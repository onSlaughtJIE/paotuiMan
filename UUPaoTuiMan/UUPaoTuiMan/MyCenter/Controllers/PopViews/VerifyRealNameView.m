//
//  RealNameView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/11.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "VerifyRealNameView.h"

@implementation VerifyRealNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.5];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"请进行身份验证";
        [titleLabel sizeToFit];
        titleLabel.left = titleLabel.top = 10;
        titleLabel.textColor = WHITE_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"身份验证" forState:UIControlStateNormal];
        [button setBackgroundColor:RED_COLOR];
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        button.size = CGSizeMake(80, 30);
        button.right = self.width - 15;
        button.centerY = titleLabel.centerY;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(RealNameAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

- (void)RealNameAction{
    if (_VerfyRealNameBlock) {
        _VerfyRealNameBlock();
    }
}

@end
