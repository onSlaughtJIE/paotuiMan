//
//  XLUpdatePhoneViewController.m
//  UUPaoTui
//
//  Created by 张博 on 17/7/21.
//  Copyright © 2017年 昔洛. All rights reserved.
//

#import "XLUpdatePhoneViewController.h"
#import <Masonry.h>

@interface XLUpdatePhoneViewController ()

/****    修改密码界面     ****/
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (nonatomic, strong) NSTimer *codeTimer;
@property (nonatomic, assign) NSInteger codeNum;
@end

@implementation XLUpdatePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
     _codeNum = 30;
}
- (void)updateUserMsg {
    [NetDataRequest CenterMessageForMeWithDic:@{@"nid":[XLUserMessage getUserID]} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            NSDictionary *dataDic = [resobject objectForKey:@"data"];
            [XLUserMessage setUserID:[dataDic objectForKey:@"staff_id"]];
            [XLUserMessage setUserIcon:[dataDic objectForKey:@"face"]];
            [XLUserMessage setUserName:[dataDic objectForKey:@"name"]];
            [XLUserMessage setUserMoney:[dataDic objectForKey:@"money"]];
            [XLUserMessage setUserPhone:[dataDic objectForKey:@"mobile"]];
            [XLUserMessage setUserLogin:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
        
    } errors:^(id errors) {
        
    }];
}

#pragma mark ---- 修改密码界面

- (IBAction)getcodeAction:(UIButton *)sender {
    if (![XLConvertTools isMobileNumber:_phoneTf.text]) {
        [self showOnlyText:@"请输入正确的手机号" delay:2 position:PositionCenter];
        return;
    }
    [NetDataRequest userSendCodeWithDic:@{@"mobile":_phoneTf.text, @"tplType":@"paonanUpdatePwd"} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"验证码已发送至手机" delay:1];
        }
        _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceNewPasswordAction) userInfo:nil repeats:YES];
    } errors:^(id errors) {
        NSLog(@"%@", errors);
    }];
}
- (void)reduceNewPasswordAction{
    _getCodeBtn.userInteractionEnabled = NO;
    [self reduceNumWithButton:_getCodeBtn];
}

- (void)reduceNumWithButton:(UIButton *)button{
    button.userInteractionEnabled = NO;
    _codeNum--;
    if (_codeNum == 0) {
        [button setTitle:@"重新获取" forState:UIControlStateNormal];
        button.userInteractionEnabled = YES;
        [button setBackgroundColor:RED_COLOR];
        [_codeTimer invalidate];
        _codeTimer = nil;
        _codeNum = 30;
    }else {
        [button setTitle:[NSString stringWithFormat:@"%lds重新获取", _codeNum] forState:UIControlStateNormal];
        [button setBackgroundColor:LIGHTGRAY_COLOR];
    }
}

- (IBAction)surePasswordAction:(UIButton *)sender {
    if (![XLConvertTools isMobileNumber:_phoneTf.text]) {
        [self showOnleText:@"请输入手机号" delay:1];
        return;
    }
    if ([XLConvertTools isEmptyString:_codeTf.text] || [XLConvertTools isEmptyString:_oldPassword.text] || [XLConvertTools isEmptyString:_newpassword.text]) {
        [self showOnleText:@"不能为空" delay:1];
        return;
    }
    [self showProgressHUD];
    [NetDataRequest updatePasswordWithOld_password:_oldPassword.text new_password:_newpassword.text  Phone:_phoneTf.text  PhoneCode:_codeTf.text success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"修改成功" delay:1];
            [self updateUserMsg];//更改个人信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
    }];
}

- (void)setNaviUI {
    self.controllTitleLabel.text = _titleStr;
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
