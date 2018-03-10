//
//  ShopStoreViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ShopStoreViewController.h"
#import "ShopStoreCollectionViewCell.h"
#import "ShopDetailViewController.h"
#import "ShopRecordViewController.h"
#import <MJRefresh.h>
#import "OrderListModel.h"
#import "ShopPayDetailViewController.h"

@interface ShopStoreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger pageCount;
}
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *secondArray;

@end

@implementation ShopStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavView];
    [self getRefreshData];
//    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    _collectionView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
}
//- (void)getMoreData{
//    pageCount++;
//    [self getRequestData];
//}

- (void)getRefreshData{
    pageCount = 1;
    [self.secondArray removeAllObjects];
    [self getRequestData];
}
- (void)getRequestData{
    [self showProgressHUD];
    [NetDataRequest GetMallListWithCateId:@"5" Page:[NSString stringWithFormat:@"%ld", (long)pageCount] Success:^(id resobject) {
        [self hidenProgressHUD];
        [_collectionView.mj_header endRefreshing];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            for (NSDictionary *dic in resobject[@"data"]) {
                MallListModel *model = [MallListModel MallListWithDictionary:dic];
                [self.secondArray addObject:model];
            }
            [_collectionView reloadData];
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
        NSLog(@"%@", errors);
    }];
}
- (void)setNavView{
    [self.view addSubview:self.collectionView];
    self.controllTitleLabel.text = @"跑客商城";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"消费记录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.frame = CGRectMake(SCREEN_WIDTH - 80, self.popButton.top, 80, 30);
    [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [button addTarget:self action:@selector(SellRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:button];
}
- (void)SellRecordAction:(UIButton *)button{
    ShopRecordViewController *recordVC = [[ShopRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark ----------------- UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopStoreCollectionViewCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
    if (indexPath.row < _secondArray.count) {
        cameraCell.listModel = _secondArray[indexPath.row];
    }
    cameraCell.ShopStoreListSellBlock = ^{
        ShopPayDetailViewController *payVC = [[ShopPayDetailViewController alloc] init];
        payVC.payModel = _secondArray[indexPath.row];
        [self.navigationController pushViewController:payVC animated:YES];
    };
    return cameraCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _secondArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShopDetailViewController *detailVC = [[ShopDetailViewController alloc] init];
    MallListModel *model = _secondArray[indexPath.row];
    detailVC.product_id = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, 270);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.top = 64;
        _collectionView.height = SCREEN_HEIGHT - 64;
        _collectionView.backgroundColor = CLEAR_COLOR;
        [_collectionView registerNib:[UINib nibWithNibName:@"ShopStoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"firstCell"];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)secondArray{
    if (!_secondArray) {
        _secondArray = [NSMutableArray new];
    }
    return _secondArray;
}

@end
