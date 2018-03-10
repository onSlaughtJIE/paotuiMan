//
//  DepositView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/31.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "DepositView.h"

@implementation DepositView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.5];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"你尚未交纳押金,暂无法接单";
        [titleLabel sizeToFit];
        titleLabel.left = titleLabel.top = 10;
        titleLabel.textColor = WHITE_COLOR;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"交纳押金" forState:UIControlStateNormal];
        [button setBackgroundColor:RED_COLOR];
        button.layer.cornerRadius = 3;
        button.clipsToBounds = YES;
        [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        button.size = CGSizeMake(80, 30);
        button.right = self.width - 15;
        button.centerY = titleLabel.centerY;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(DepositAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

- (void)DepositAction{
    if (_DepositBlock) {
        _DepositBlock();
    }
}


@end
