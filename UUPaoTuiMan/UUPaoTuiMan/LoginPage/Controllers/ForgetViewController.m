//
//  ForgetViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *phoneText;
    @property (weak, nonatomic) IBOutlet UITextField *codeText;
    @property (weak, nonatomic) IBOutlet UITextField *passwordText;
    @property (weak, nonatomic) IBOutlet UIButton *codeBtn;
    @property (nonatomic, strong) NSTimer *codeTimer;
    @property (nonatomic, assign) NSInteger codeNum;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"忘记密码";
    _codeNum = 30;
    self.passwordText.secureTextEntry = YES;
    [self.popButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
}
    
- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendCodeText:(id)sender {
    if (![XLConvertTools isMobileNumber:_phoneText.text]) {
        [self showOnlyText:@"请输入正确的手机号" delay:2 position:PositionCenter];
        return;
    }
    [NetDataRequest userSendCodeWithDic:@{@"mobile":_phoneText.text, @"tplType":@"paonanForgetPwd"} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"验证码已发送至手机" delay:1];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
    }];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceNumAction) userInfo:nil repeats:YES];
}
- (IBAction)saveNewPasswordAction:(id)sender {
    if (_phoneText.text.length < 1 || _codeText.text.length < 1 || _passwordText.text.length < 1) {
        [self showOnleText:@"提交内容不能为空,请核对后再试" delay:2];
        return;
    }
    [NetDataRequest userForgetPasswordWithDic:@{@"phoneCode":_codeText.text, @"mobile":_phoneText.text, @"password":_passwordText.text} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"status"]] isEqualToString:@"0"]) {
            [self showOnleText:@"找回密码成功" delay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
    }];

}

- (void)reduceNumAction {
    _codeBtn.userInteractionEnabled = NO;
    _codeNum--;
    if (_codeNum == 0) {
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
        [_codeBtn setBackgroundColor:ORANGE_COLOR];
        [_codeTimer invalidate];
        _codeTimer = nil;
        _codeNum = 30;
    }else {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%lds重新获取", _codeNum] forState:UIControlStateNormal];
        [_codeBtn setBackgroundColor:LIGHTGRAY_COLOR];
    }
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_codeTimer) {
        [_codeTimer invalidate];
        _codeTimer = nil;
    }
}
    
- (void)dealloc {
    [_codeTimer invalidate];
    _codeTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
