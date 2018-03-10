//
//  MessageCenterViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CenterMessageModel.h"
#import "MessageDetailViewController.h"

@interface MessageCenterViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger pageCount;
}
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self createtableView];
    [self getRefreshData];
    self.xltableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.xltableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
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
    [NetDataRequest MessageCenterWithSuccess:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            for (NSDictionary *dic in resobject[@"data"]) {
                MessageCenterModel *model = [MessageCenterModel CenterMessageWithDic:dic];
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
    [_xltableView registerNib:[UINib nibWithNibName:@"MessageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCenterTableViewCell"];
    _xltableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
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
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCenterTableViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.titleArray.count) {
        cell.model = self.titleArray[indexPath.row];
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
    MessageCenterModel *model = self.titleArray[indexPath.row];
    return [MessageCenterTableViewCell getCellHeightWithContent:model.content];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterModel *model = self.titleArray[indexPath.row];
    MessageDetailViewController *detailVC = [[MessageDetailViewController alloc] init];
    detailVC.messageId = model.msg_id;
    detailVC.staff_id = model.staff_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)setNaviUI {
    self.controllTitleLabel.text = @"消息中心";
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
