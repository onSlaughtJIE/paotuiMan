//
//  OpinionViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/12.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "OpinionViewController.h"

@interface OpinionViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextView *opinionText;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@end

@implementation OpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    self.opinionText.delegate = self;
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setNaviUI {
    self.controllTitleLabel.text = @"意见反馈";
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.naviView addSubview:leftBtn];
    [leftBtn setImage:[UIImage imageNamed:@"icon_dan_back@2x"] forState:UIControlStateNormal];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.controllTitleLabel);
        make.left.offset(10);
        make.width.height.offset(40);
    }];
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OpinionSubmitAction:(id)sender {
    if ([XLConvertTools isEmptyString:self.opinionText.text]) {
        [self showOnleText:@"请输入你的意见" delay:1];
        return;
    }
    if (![XLConvertTools isMobileNumber:self.phoneTF.text]) {
        [self showOnleText:@"请核对您的手机号" delay:1];
        return;
    }
    [self showProgressHUD];
    [NetDataRequest SuggestionsForUserWithmobile:self.phoneTF.text content:self.opinionText.text success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"意见反馈提交成功" delay:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showOnleText:[resobject objectForKey:@"msg"] delay:1];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
        [self hidenProgressHUD];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.noticeLabel.hidden = textView.text.length > 0;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
