//
//  PNBaseViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "PNBaseViewController.h"
#import <Masonry.h>

@interface PNBaseViewController ()

@end

@implementation PNBaseViewController
//懒加载
- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        _progressHUD.bezelView.color = [UIColor blackColor];
        _progressHUD.contentColor = [UIColor whiteColor];
    }
    return _progressHUD;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self supviewCusNavi];
}
    
- (void)supviewCusNavi {
    _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.view addSubview:_naviView];
    _naviView.backgroundColor = NavBarColor;
    _controllTitleLabel = [UILabel labelWithTitle:@"" fontSize:17 color:WHITE_COLOR alignment:1];
    [_naviView addSubview:_controllTitleLabel];
    [_controllTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_naviView);
        make.bottom.mas_equalTo(_naviView.mas_bottom);
        make.height.offset(44);
    }];
    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_naviView);
        make.left.right.mas_equalTo(_naviView);
        make.height.offset(1);
    }];
    lineView.backgroundColor = XLColorFromHex(0xdcdcdc);
    
    self.popButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 30, 30)];
    self.popButton.bottom = _naviView.bottom - 5;
    [self.popButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self.popButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateSelected];
    [_naviView addSubview:self.popButton];
}
    
//显示loading
- (void)showProgressHUD {
    [self showProgressHUDWithStr:nil];
}
//带文字的loading
- (void)showProgressHUDWithStr:(NSString *)str {
    if (str.length == 0) {
        self.progressHUD.label.text = nil;
    } else {
        self.progressHUD.label.text = str;
    }
    //显示loading方法
    [self.progressHUD showAnimated:YES];
}
//隐藏loading
- (void)hidenProgressHUD {
    if (self.progressHUD != nil) {
        [self.progressHUD hideAnimated:YES];
        [self.progressHUD removeFromSuperViewOnHide];
        self.progressHUD = nil;
    }
}
- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    // Move to bottm center.
    hud.center = self.view.center;
    //    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    
    [hud hideAnimated:YES afterDelay:delay];
}

//  封装显示弹出框的方法,过1秒自动消失
- (void)showAlertControlerWithMessage:(NSString *)message delay:(NSTimeInterval)delay {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{
        //  过1秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];
}
//显示位置
- (void)showOnlyText:(NSString *)text delay:(NSTimeInterval)delay position:(PositionStype)position {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    // Move to bottm center.
    hud.center = self.view.center;
    if (position == PositionCenter){
        
    } else {
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        
    }
    [hud hideAnimated:YES afterDelay:delay];
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
