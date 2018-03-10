//
//  ShopRecordViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ShopRecordViewController.h"
#import "ShopRecordTableViewCell.h"
#import <MJRefresh.h>
#import "OrderListModel.h"
@interface ShopRecordViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger pageCount;
}
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation ShopRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"消费记录";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    [self createtableView];
    [self getRecordRequestData];
    _xltableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    _xltableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
}
- (void)getMoreData{
    pageCount++;
    [self getRecordRequestData];
}

- (void)getRefreshData{
    pageCount = 1;
    [self.titleArray removeAllObjects];
    [self getRecordRequestData];
}

- (void)getRecordRequestData{
    [self showProgressHUD];
    [NetDataRequest GetMallListDetailWithUserIdSuccess:^(id resobject) {
        [self hidenProgressHUD];
        [_xltableView.mj_header endRefreshing];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            for (NSDictionary *dic in resobject[@"data"]) {
                MallSellRecordList *model = [MallSellRecordList MallRecordListWithDictionary:dic];
                [self.titleArray addObject:model];
            }
            [_xltableView reloadData];
            if (_titleArray.count % 10 == 0) {
                [_xltableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } errors:^(id errors) {
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
    [_xltableView registerNib:[UINib nibWithNibName:@"ShopRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopRecordTableViewCell"];
}
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopRecordTableViewCell" forIndexPath:indexPath];
    if (indexPath.row < _titleArray.count) {
        cell.listModel = _titleArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
