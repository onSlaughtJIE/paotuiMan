//
//  RecommendViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"推荐有奖";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    
    NSArray *array = @[@"邀请用户：",@"1：注册获得1元奖励",@"2：用户下单获得2元奖励",@"3：成功完成两单获得5元奖励",@"4：成功完成十单获得12元奖励", @"邀请跑客：",@"1：注册获得1元",@"2：接单获得2元",@"3：接5单每单奖1元，共5元",@"4：完成10单得14元", @"(客户使用优惠券，本单不计入奖励内)"];

    CGFloat bottom = 80;
    for (int i = 0; i < array.count; i++) {
        UILabel *titleLabel = [UILabel labelWithTitle:array[i] fontSize:14 color:GRAY_COLOR alignment:NSTextAlignmentLeft];
        CGFloat height = [array[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height;
        if (i == 0 || i == 6) {
            titleLabel.font = [UIFont systemFontOfSize:16];
        }
        titleLabel.frame = CGRectMake(10, bottom, SCREEN_WIDTH - 20, height);
        titleLabel.numberOfLines = 0;
        bottom = titleLabel.bottom;
        [self.view addSubview:titleLabel];
    }
}
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
