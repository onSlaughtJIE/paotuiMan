//
//  ShopPayDetailViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/5.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ShopPayDetailViewController.h"
#import "AlipayHelper.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ShopPayDetailTableViewCell.h"
#import "ShopPayWayTableViewCell.h"

@interface ShopPayDetailViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) UITableView *xltableView;

@end

@implementation ShopPayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"装备支付";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    [self createtableView];
}
- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 104) style:UITableViewStyleGrouped];
    [self.view addSubview:_xltableView];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView registerNib:[UINib nibWithNibName:@"ShopPayDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopPayDetailTableViewCell"];
    [_xltableView registerNib:[UINib nibWithNibName:@"ShopPayWayTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopPayWayTableViewCell"];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [payBtn setBackgroundColor:RED_COLOR];
    [payBtn setFrame:CGRectMake(0, _xltableView.bottom, SCREEN_WIDTH, 40)];
    [payBtn addTarget:self action:@selector(paySellAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        ShopPayWayTableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"ShopPayWayTableViewCell" forIndexPath:indexPath];
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return payCell;
    }else{
        ShopPayDetailTableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:@"ShopPayDetailTableViewCell" forIndexPath:indexPath];
        if (_payDic.count) {
            payCell.titleLabel.text = _payDic[@"title"];
            payCell.priceLabel.text = [NSString stringWithFormat:@"%@元",_payDic[@"price"]];
        }else{
            payCell.titleLabel.text = _payModel.title;
            payCell.priceLabel.text = [NSString stringWithFormat:@"%@元", _payModel.price];
        }
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return payCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
        return 6;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [UILabel labelWithTitle:@"购买详情" fontSize:16 color:BLACK_COLOR alignment:NSTextAlignmentLeft];
    label.backgroundColor = WHITE_COLOR;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = DARKGRAY_COLOR;
    if (section) {
        label.text = @"  支付方式";
    }else{
        label.text = @"  购买详情";
    }
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = backViewColor;
    return view;
}

- (void)paySellAction:(UIButton *)button{
    NSString *orderNum = [[AlipayHelper shared] generateTradeNO];
    if ([XLConvertTools isEmptyString:_payModel.price]) {
        [self AliPayWithMoney:_payDic[@"price"] title:_payDic[@"title"] OrderNum:orderNum];
    }else{
        [self AliPayWithMoney:_payModel.price title:_payModel.title OrderNum:orderNum];
    }
}

- (void)AliPayWithMoney:(NSString *)money title:(NSString *)title OrderNum:(NSString *)orderNum{
    Product *product = [[Product alloc] init];
    product.orderId = orderNum;
    product.price = [money floatValue];
    product.subject = title;
    product.body = title;
    [[AlipayHelper shared] alipay:product block:^(NSDictionary *result) {
        NSLog(@"支付宝支付结果=%@", result);
        if ([result[@"resultStatus"] isEqualToString:@"9000"]) {
            [self showOnleText:@"支付成功" delay:1];
            [self changeOrderStatus];
        }else if ([result[@"resultStatus"] isEqualToString:@"6001"]){
            [self showOnleText:@"订单已取消" delay:1];
        }else if ([result[@"resultStatus"] isEqualToString:@"4000"]){
            [self showOnleText:@"订单支付失败" delay:1];
        }else if ([result[@"resultStatus"] isEqualToString:@"8000"]){
            [self showOnleText:@"订单正在处理中" delay:1];
        }
    }];
}

- (void)changeOrderStatus{
    NSString *sellId = [XLConvertTools isEmptyString:_payModel.product_id] ? _payDic[@"product_id"] : _payModel.product_id;
    NSString *price = [XLConvertTools isEmptyString:_payModel.price] ? _payDic[@"price"] : _payModel.price;
    [NetDataRequest MallRecordWithProduct_id:sellId Num:@"1" Price:price Success:^(id resobject) {
    
    } errors:^(id errors) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
