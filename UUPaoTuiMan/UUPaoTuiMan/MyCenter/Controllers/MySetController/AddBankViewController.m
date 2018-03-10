//
//  AddBankViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "AddBankViewController.h"

@interface AddBankViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *xltableView;

@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self createtableView];
    [self setTableViewHead];
}

- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_xltableView];
    [_xltableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.offset(64);
    }];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView setLayoutMargins:UIEdgeInsetsZero];
    _xltableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _xltableView.tableFooterView = footerView;
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:loginOutBtn];
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footerView);
        make.height.offset(34);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    [loginOutBtn setTitle:@"确定绑定" forState:UIControlStateNormal];
    [loginOutBtn setBackgroundColor:RED_COLOR];
    loginOutBtn.layer.cornerRadius = 4;
    [loginOutBtn addTarget:self action:@selector(sureBindAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = GRAY_BACKGROUND_COLOR;
    [footerView addSubview:lineView];
}
- (void)setTableViewHead{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor = backViewColor;
    _xltableView.tableHeaderView = headView;
    
    UILabel *titleLabel = [UILabel labelWithTitle:@"请绑定本人银行卡,确保你的用卡安全" fontSize:16 color:RED_COLOR alignment:0];
    titleLabel.left = 15;
    [titleLabel sizeToFit];
    titleLabel.centerY = headView.centerY;
    [headView addSubview:titleLabel];
}
- (void)sureBindAction:(UIButton *)sender {
    UITextField *nameFiled = (UITextField *)[self.view viewWithTag:1840];
    UITextField *banknameFiled = (UITextField *)[self.view viewWithTag:1841];
    UITextField *bankFiled = (UITextField *)[self.view viewWithTag:1842];
    if ([XLConvertTools isEmptyString:nameFiled.text]) {
        [self showOnleText:nameFiled.placeholder delay:1];
        return;
    }
    if ([XLConvertTools isEmptyString:banknameFiled.text]) {
        [self showOnleText:banknameFiled.placeholder delay:1];
        return;
    }
    if (![XLConvertTools isValidateIdentityCard:bankFiled.text]) {
        [self showOnleText:@"请输入正确的银行卡号" delay:1];
        return;
    }
    [self showProgressHUD];
    [NetDataRequest BindingBankWithCardHolder:nameFiled.text CardNumber:bankFiled.text Card_type:banknameFiled.text success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"绑定成功" delay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
    }];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (![cell viewWithTag:1839]) {
        UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 70, 20)];
        clearLabel.tag = 1839;
        [cell addSubview:clearLabel];
        
        UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(clearLabel.right + 5, 5, cell.width - 110, 30)];
        textFiled.centerY = clearLabel.centerY;
        textFiled.tag = 1840;
        [cell addSubview:textFiled];
    }
    NSArray *nameArray = @[@"持卡人", @"银行名", @"银行卡"];
    NSArray *titleArray = @[@"请输入您的真实姓名", @"请输入银行名称", @"请输入银行卡号"];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1839];
    UITextField *textFiled = (UITextField *)[cell viewWithTag:1840];
    textFiled.tag = 1840 + indexPath.row;
    nameLabel.text = nameArray[indexPath.row];
    textFiled.placeholder = titleArray[indexPath.row];
    if (indexPath.row == 1) {
        textFiled.text = @"工商银行";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setNaviUI {
    self.controllTitleLabel.text = @"添加账户";
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
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
