//
//  TiXianViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "TiXianViewController.h"
#import "BankAccountViewController.h"

@interface TiXianViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_bankCardId;
    NSString *_bankMoney;
}

@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *sourceArray;
@property(nonatomic, weak)     UITextField *BankTextFiled;

@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self createtableView];
    [self getRequestData];
}

- (void)getRequestData{
    [self showProgressHUD];
    [NetDataRequest BankWithOrderLisSuccess:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            for (NSDictionary *dic in resobject[@"data"]) {
                [self.sourceArray addObject:dic];
            }
            [_xltableView reloadData];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
        [self hidenProgressHUD];
    }];
}
- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_xltableView];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _xltableView.tableFooterView = footview;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [footview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footview);
        make.height.offset(34);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    button.layer.cornerRadius = 4;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button setBackgroundColor:RED_COLOR];
    [button addTarget:self action:@selector(TiXianAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArray = @[@"可提余额", @"银行卡", @"提现金额", @"提现时间"];
    NSArray *placeArray = @[@"0元", @"请选择银行卡", @"请输入提现金额(50的倍数)", @"周三至周五 到账时间1-2天"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    if (![cell viewWithTag:904]) {
        UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH - 120, 30)];
        textFiled.tag = 904;
        [cell addSubview:textFiled];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    UITextField *textFiled = (UITextField *)[cell viewWithTag:904];
    textFiled.placeholder = placeArray[indexPath.row];
    if (indexPath.row == 0) {
       [textFiled setValue:RED_COLOR forKeyPath:@"_placeholderLabel.textColor"];
        textFiled.placeholder = [NSString stringWithFormat:@"%@元", self.tixianMoney];
        textFiled.userInteractionEnabled = NO;
    }else if (indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        textFiled.userInteractionEnabled = NO;
        if (_sourceArray.count) {
            NSDictionary *dic = self.sourceArray[0];
            textFiled.text = dic[@"card_number"];
            _bankCardId = dic[@"id"];
        }
        _BankTextFiled = textFiled;
    }else if(indexPath.row == 2){
        textFiled.userInteractionEnabled = YES;
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
        [textFiled addTarget:self action:@selector(valueMoney:) forControlEvents:UIControlEventEditingChanged];
    }else{
        textFiled.userInteractionEnabled = NO;
        textFiled.text = placeArray[indexPath.row];
    }
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
//        UITextField *textFiled = (UITextField *)[tableView viewWithTag:904];
        BankAccountViewController *bankVC = [[BankAccountViewController alloc] init];
        bankVC.cardNumber = _BankTextFiled.text;
        bankVC.isTiXian = YES;
        [self.navigationController pushViewController:bankVC animated:YES];
        bankVC.selectBankBlock = ^(NSString *bank, NSString *cardId) {
            _BankTextFiled.text = bank;
            _bankCardId = cardId;
        };
    }
}

- (void)valueMoney:(UITextField *)textFiled{
    _bankMoney = textFiled.text;
}

- (void)TiXianAction:(UIButton *)button{
    if ([XLConvertTools isEmptyString:_bankMoney]) {
        [self showOnleText:@"请输入提现金额" delay:1];
        return;
    }
    long money = [[NSString stringWithFormat:@"50"] longLongValue];
    if ([_bankMoney longLongValue] % money) {
        [self showOnleText:@"提现金额不是50的倍数" delay:1];
        return;
    }
    if (![XLConvertTools isValidateIdentityCard:_bankCardId]) {
        [self showOnleText:@"请选择正确的银行卡号" delay:1];
        return;
    }
    [self showProgressHUD];
    [NetDataRequest UserMoneyTiXianWithMoney:_bankMoney BankCard:_bankCardId success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"提现成功" delay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNaviUI {
    self.controllTitleLabel.text = @"提现";
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray new];
    }
    return _sourceArray;
}

@end
