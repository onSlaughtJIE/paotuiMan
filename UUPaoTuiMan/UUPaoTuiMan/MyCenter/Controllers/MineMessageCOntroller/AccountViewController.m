//
//  AccountViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/1.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "AccountViewController.h"
#import "TiXianViewController.h"

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *AccountLabel;
@property (weak, nonatomic) IBOutlet UILabel *TiXianLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
    
@end

@implementation AccountViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"账户余额";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAccountRequestData];
}

- (void)getAccountRequestData{
    [self showProgressHUD];
    [NetDataRequest AccountMoneyWithSuccess:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self setAccountHeadViewWithDic:resobject[@"data"]];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:1];
        [self hidenProgressHUD];
    }];
}

- (void)setAccountHeadViewWithDic:(NSDictionary *)dic{
    _AccountLabel.text = [NSString stringWithFormat:@"%@", dic[@"money"]];
    _TiXianLabel.text = [NSString stringWithFormat:@"%@", dic[@"tixian"]];
    _totalMoneyLabel.text = [NSString stringWithFormat:@"%@", dic[@"totalMoney"]];
    _todayMoneyLabel.text = [NSString stringWithFormat:@"%@", dic[@"todayMoney"]];
}
    
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)WithDrawAction:(id)sender {
    TiXianViewController *tixianVC = [[TiXianViewController alloc] init];
    tixianVC.tixianMoney = _TiXianLabel.text;
    [self.navigationController pushViewController:tixianVC animated:YES];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
