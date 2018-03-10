//
//  BankAccountViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "BankAccountViewController.h"
#import "AddBankViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface BankAccountViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger pageCount;
}
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation BankAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self createtableView];
    self.xltableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.xltableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getRefreshData];
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
    _xltableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)getMoreData{
    pageCount++;
    [self getRequestData];
}

- (void)getRefreshData{
    pageCount = 1;
    [self.sourceArray removeAllObjects];
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
            [_xltableView.mj_header endRefreshing];
            if (self.sourceArray.count % 10) {
                [_xltableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_xltableView reloadData];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
        [self hidenProgressHUD];
        [_xltableView.mj_header endRefreshing];
    }];
}
- (void)setNaviUI {
    self.controllTitleLabel.text = @"我的银行卡";
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH - 40, self.popButton.top, 30, 30);
    [sureButton setImage:[UIImage imageNamed:@"Add@2x"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(AddBankMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:sureButton];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (![cell viewWithTag:1839]) {
        UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 70, 20)];
        clearLabel.tag = 1839;
        clearLabel.textColor =  DARKGRAY_COLOR;
        [cell addSubview:clearLabel];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(clearLabel.left, clearLabel.bottom + 10, 70, 20)];
        subLabel.tag = 1840;
        subLabel.textColor =  DARKGRAY_COLOR;
        [cell addSubview:subLabel];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.size = CGSizeMake(25, 25);
        imageView.right = SCREEN_WIDTH - 30;
        imageView.centerY = 30;
        imageView.tag = 1841;
        imageView.hidden = self.cardNumber.length < 1;
        [cell addSubview:imageView];
    }
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1839];
    UILabel *subLabel = (UILabel *)[cell viewWithTag:1840];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1841];
    if (indexPath.row < self.sourceArray.count) {
        NSDictionary *dic = self.sourceArray[indexPath.row];
        nameLabel.text = dic[@"card_type"];
        subLabel.text = dic[@"card_number"];
        [subLabel sizeToFit];
        [nameLabel sizeToFit];
        if ([self.cardNumber isEqualToString:dic[@"card_number"]]) {
            imageView.image = [UIImage imageNamed:@"genderSelect"];
        }else{
            imageView.image = [UIImage imageNamed:@"UnSelect"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isTiXian) {
        NSDictionary *dic = self.sourceArray[indexPath.row];
        if (_selectBankBlock) {
            _selectBankBlock(dic[@"card_number"], dic[@"id"]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)AddBankMessage{
    AddBankViewController *addBankVC = [[AddBankViewController alloc] init];
    [self.navigationController pushViewController:addBankVC animated:YES];
}

- (NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray new];
    }
    return _sourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
