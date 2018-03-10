//
//  ShopDetailViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ShopDetailViewController.h"
#import <MJRefresh.h>
#import "UIImageView+AFNetworking.h"
#import "ShopPayDetailViewController.h"

@interface ShopDetailViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSDictionary *detailDic;
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"商城详情";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    [self createtableView];
    [self getDetailRequestData];
}

- (void)getDetailRequestData{
    [self showProgressHUD];
    [NetDataRequest GetMallListDetailWithProductId:_product_id Success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            NSArray *detailArray = resobject[@"data"];
            _detailDic = detailArray.firstObject;
            [_xltableView reloadData];
            [self setTableViewHeadView];
            [self setFootView];
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
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)setTableViewHeadView{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,300)];
    backView.backgroundColor = WHITE_COLOR;
    self.xltableView.tableHeaderView = backView;
    
    UIImageView *headImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20,230)];
    [headImgeView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API, _detailDic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"pictureImage"]];
    [backView addSubview:headImgeView];
    
    UILabel *titleLabel = [UILabel labelWithTitle:_detailDic[@"title"] fontSize:16 color:BLACK_COLOR alignment:NSTextAlignmentLeft];
    titleLabel.left = headImgeView.left;
    titleLabel.top = headImgeView.bottom + 10;
    [titleLabel sizeToFit];
    [backView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"剩余:%@", _detailDic[@"sales"]] fontSize:14 color:DARKGRAY_COLOR alignment:NSTextAlignmentLeft];
    subTitleLabel.left = titleLabel.left;
    subTitleLabel.top = titleLabel.bottom + 5;
    [subTitleLabel sizeToFit];
    [backView addSubview:subTitleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backView.height - 10, SCREEN_WIDTH,10)];
    lineView.backgroundColor = GRAY_BACKGROUND_COLOR;
   [backView addSubview:lineView];
}

- (void)setFootView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH,50)];
    footView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:footView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即购买" forState:UIControlStateNormal];
    button.left = footView.width - 100;
    button.height = footView.height;
    button.width = 100;
    [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [button setBackgroundColor:NavBarColor];
    [button addTarget:self action:@selector(LiJiSell:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    
    UILabel *titleLabel = [UILabel labelWithTitle:[NSString stringWithFormat:@"%@元", _detailDic[@"price"]] fontSize:18 color:BLACK_COLOR alignment:NSTextAlignmentLeft];
    titleLabel.left = footView.left + 10;
    titleLabel.top = 15;
    [titleLabel sizeToFit];
    [footView addSubview:titleLabel];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LiJiSell:(UIButton *)button{
    ShopPayDetailViewController *payVC = [[ShopPayDetailViewController alloc] init];
    payVC.payDic = _detailDic;
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (![cell viewWithTag:1003]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = GRAY_COLOR;
        label.numberOfLines = 0;
        label.tag = 1003;
        [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1003];
    label.text = _detailDic[@"intro"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [_detailDic[@"intro"]  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    return height + 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [UILabel labelWithTitle:@"商品详情" fontSize:16 color:BLACK_COLOR alignment:NSTextAlignmentCenter];
    label.backgroundColor = WHITE_COLOR;
     return label;
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
