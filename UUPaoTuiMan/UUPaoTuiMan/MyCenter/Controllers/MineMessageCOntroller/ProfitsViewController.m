//
//  ProfitsViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/11.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ProfitsViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "MessageCenterTableViewCell.h"
#import "OrderListModel.h"
#import "ProfitsTableViewCell.h"

@interface ProfitsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger pageCount;
}
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ProfitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self createtableView];
    [self getRefreshData];
    _xltableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
   _xltableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
}
- (void)getMoreData{
    pageCount++;
    [self getRequestData];
}

- (void)getRefreshData{
    pageCount = 1;
    [self.titleArray removeAllObjects];
    [self getRequestData];
}

- (void)getRequestData{
    [self showProgressHUD];
    [NetDataRequest ProfitsListWithStatus:self.type Page:[NSString stringWithFormat:@"%@", @(pageCount)] Success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            for (NSDictionary *dic in resobject[@"data"]) {
                ProfiftsModel *model = [ProfiftsModel ProfitsWithDictionary:dic];
                [self.titleArray addObject:model];
            }
            [_xltableView.mj_header endRefreshing];
            if (self.titleArray.count % 10) {
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

- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_xltableView];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView registerNib:[UINib nibWithNibName:@"ProfitsTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProfitsTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfitsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfitsTableViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.titleArray.count) {
        cell.profitsModel = self.titleArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)setNaviUI {
    self.controllTitleLabel.text = @"获得收益";
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

@end
