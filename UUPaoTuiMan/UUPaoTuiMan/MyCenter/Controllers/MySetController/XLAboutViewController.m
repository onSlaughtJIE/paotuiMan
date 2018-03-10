//
//  XLAboutViewController.m
//  UUPaoTui
//
//  Created by qianyuan on 2017/7/20.
//  Copyright © 2017年 昔洛. All rights reserved.
//

#import "XLAboutViewController.h"
#import <Masonry.h>

@interface XLAboutViewController ()
    @property (weak, nonatomic) IBOutlet UILabel *noticLabel;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation XLAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self setAboutMessage];
    self.noticLabel.text = @"Copyright © 2018万能帮信息科技有限公司";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"v %@", app_Version];
}

- (void)setAboutMessage{
    [self showProgressHUD];
    [NetDataRequest AboutWithDic:nil success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            self.titleLabel.text = resobject[@"data"][@"desc"];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
        [self hidenProgressHUD];
    }];
}
    
- (void)setNaviUI {
    self.controllTitleLabel.text = @"关于";
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
