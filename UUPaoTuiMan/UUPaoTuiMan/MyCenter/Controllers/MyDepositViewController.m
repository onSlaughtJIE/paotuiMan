//
//  MyDepositViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/31.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MyDepositViewController.h"
#import "AlipayHelper.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TradeRefund.h"

#define AliPayAppleID           @"2017072507885652"

@interface MyDepositViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *depositBtn;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property(nonatomic, copy) NSString *OrderNum;
@property(nonatomic, copy) NSString *depositMoney;
@end

@implementation MyDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNavView];
    [NetDataRequest GetDepositMoneyWithSuccess:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            _depositMoney = resobject[@"data"][@"deposit_money"];
            _depositLabel.text = [NSString stringWithFormat:@"%@元", _depositMoney];
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
    }];
    [self setDespoitView];
}
- (void)setDespoitView{
    if ([XLUserMessage getPaoNanDeposit]) {
        _titleLabel.text = @"您的押金已交";
        [_depositBtn setTitle:@"退押金" forState:UIControlStateNormal];
        _depositBtn.tag = 1119;
    }else{
        _titleLabel.text = @"您的押金还未交纳,请先交纳押金";
        [_depositBtn setTitle:@"去交纳" forState:UIControlStateNormal];
        _depositBtn.tag = 1120;
    }
}

- (void)setNavView{
    self.controllTitleLabel.text = @"我的押金";
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)DepositBtnAvtion:(id)sender {
    UIButton *button = sender;
    if (button.tag == 1119) {
        [self showProgressHUD];
        [NetDataRequest GetDepositOrderWithSuccess:^(id resobject) {
            [self hidenProgressHUD];
            if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
                [self setRefundDepositWithAliPayWithTrade:resobject[@"data"][@"out_trade_no"]];
            }
        } errors:^(id errors) {
            [self hidenProgressHUD];
            NSLog(@"%@", errors);
        }];
    }else{
        [self setPayDepositWithAliPay];
    }
}

- (void)setRefundDepositWithAliPayWithTrade:(NSString *)depositNum{
    NSDate *newDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * newDateStr = [df stringFromDate:newDate];
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *contentStr = [NSString stringWithFormat:@"\"refund_amount\":\"%@\",\"out_trade_no\":\"%@\"",_depositMoney,depositNum];
    TradeRefund *refund = [[TradeRefund alloc] init];
    refund.timestamp = newDateStr;
    refund.version = app_Version;
    refund.charset = @"UTF-8";
    refund.app_id = AliPayAppleID;
    refund.method = @"alipay.trade.refund";
    refund.sign_type = @"RSA";
    refund.biz_content = contentStr;
    
    [[AlipayHelper shared] alipayTradeRefund:refund block:^(NSDictionary *result) {
        if ([result[@"alipay_trade_refund_response"][@"msg"] isEqualToString:@"Success"]) {
            [self showOnleText:@"退款成功" delay:1];
            [self changeDepositStatus];
        }else{
            [self showOnleText:@"退款失败" delay:1];
        }
    }];
}

- (void)changeOrderStatus:(NSString *)payWay{
    [self showProgressHUD];
    [NetDataRequest PayDepositWithMoney:_depositMoney OrderNum:[XLUserMessage getPaoNanOrderNum] Success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [XLUserMessage setPaoNanDeposit:YES];
             [self setDespoitView];
            [self showOnleText:@"支付成功" delay:1];
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
        [self showOnleText:@"数据或网络异常" delay:1];
    }];
}
- (void)changeDepositStatus{
    [NetDataRequest SetDepositRefundWithSuccess:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"押金退还成功" delay:1];
            [XLUserMessage setPaoNanDeposit:NO];
            [self setDespoitView];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:1];
    }];
}

- (void)setPayDepositWithAliPay{
    Product *product = [[Product alloc] init];
    _OrderNum = [[AlipayHelper shared] generateTradeNO];
    [XLUserMessage setDepositOrderNum:_OrderNum];
    product.orderId = _OrderNum;
    product.price = [_depositMoney floatValue];
    product.subject = @"交纳押金";
    product.body = @"交纳押金";
    
    [[AlipayHelper shared] alipay:product block:^(NSDictionary *result) {
        NSLog(@"支付宝支付结果=%@", result);
        if ([result[@"resultStatus"] isEqualToString:@"9000"]) {
            [self changeOrderStatus:@"alipay"];
        }else if ([result[@"resultStatus"] isEqualToString:@"6001"]){
            [self showOnleText:@"订单已取消" delay:1];
        }else if ([result[@"resultStatus"] isEqualToString:@"4000"]){
            [self showOnleText:@"订单支付失败" delay:1];
        }else if ([result[@"resultStatus"] isEqualToString:@"8000"]){
            [self showOnleText:@"订单正在处理中" delay:1];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
