//
//  ViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "MyCenterViewController.h"

@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *phoneText;
    @property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.controllTitleLabel.text = @"用户登录";
    self.popButton.hidden = YES;
    self.passwordText.secureTextEntry = YES;
}
- (IBAction)userLoginAction:(id)sender {
    UIButton *button = sender;
    button.userInteractionEnabled = NO;
    if (_phoneText.text.length < 1 || _passwordText.text.length < 1) {
        [self showOnleText:@"登录内容不能为空,请核对后再试" delay:2];
        return;
    }
    [NetDataRequest userLoginWithDic:@{@"password":_passwordText.text, @"mobile":_phoneText.text} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnlyText:@"登录成功" delay:1 position:PositionCenter];
            button.userInteractionEnabled = YES;
            [XLUserMessage setUserLogin:YES];
            NSDictionary *dataDic = [resobject objectForKey:@"data"];
            [XLUserMessage setUserID:[dataDic objectForKey:@"staff_id"]];
            [XLUserMessage setUserIcon:[dataDic objectForKey:@"face"]];
            [XLUserMessage setUserName:[dataDic objectForKey:@"name"]];
            [XLUserMessage setUserMoney:[dataDic objectForKey:@"money"]];
            [XLUserMessage setUserPhone:[dataDic objectForKey:@"mobile"]];
//            [XLUserMessage setPaoNanIcon:[dataDic objectForKey:@"qrcode_img"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MyCenterViewController *centerVC = [[MyCenterViewController alloc] init];
                [self.navigationController pushViewController:centerVC animated:YES];
            });
        }else{
            button.userInteractionEnabled = YES;
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        button.userInteractionEnabled = YES;
        [self showOnleText:@"网络异常,请稍后再试" delay:1];
        NSLog(@"登录错误%@", errors);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
