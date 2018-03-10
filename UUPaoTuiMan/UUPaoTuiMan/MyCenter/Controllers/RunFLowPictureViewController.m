//
//  RunFLowPictureViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/21.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RunFLowPictureViewController.h"
#import "UIImageView+AFNetworking.h"

@interface RunFLowPictureViewController ()

@end

@implementation RunFLowPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self supviewCusNavi];
    [self setNavView];
}
- (void)setNavView{
    self.controllTitleLabel.text = @"查看图片";
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.size = CGSizeMake(SCREEN_WIDTH - 40, SCREEN_WIDTH - 40);
    imageView.center = self.view.center;
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API, _imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
    [self.view addSubview:imageView];
}


- (void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
