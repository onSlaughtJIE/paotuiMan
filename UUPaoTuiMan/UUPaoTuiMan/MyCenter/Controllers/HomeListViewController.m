//
//  HomeListViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/8.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "HomeListViewController.h"
#import "OrderPopView.h"
#import "AchieveListTableViewCell.h"
#import <MJRefresh.h>
#import "OrderListModel.h"
#import "OrderMapView.h"
#import "VerifyRealNameView.h"
#import "RealNameViewController.h"
#import "DepositView.h"
#import "MyDepositViewController.h"
#import "RunFlowViewController.h"
#import "RunWaitViewController.h"


@interface HomeListViewController ()<UITableViewDelegate, UITableViewDataSource,OrderPopViewDelegate, CLLocationManagerDelegate, OrderMapViewDelegate>
{
    NSInteger pageCount;
    NSString *_codeNum;
    CLLocation *_currentLocation;
}
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *sourceArray;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic, weak) OrderPopFootView *footView;

@end

@implementation HomeListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setRealNameViewWith:[XLUserMessage getPaoNanRealName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviView.height = 0;
    self.popButton.height = 0;
    [self.view addSubview:self.xltableView];
//    [self StartLocationManager];
    _currentLocation = [[CLLocation alloc] initWithLatitude:[[XLUserMessage getAddressLocationLat] doubleValue] longitude:[[XLUserMessage getAddressLocationLng] doubleValue]];
    [self getRefreshData];
    self.xltableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.xltableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
}

- (void)getRealNameRequestData{
    [NetDataRequest GetRealNameSuccess:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", resobject[@"msgcode"]] isEqualToString:@"0"]){
            [self setRealNameViewWith:YES];
            [XLUserMessage setPaoNanRealName:YES];
        }else{
            [self setRealNameViewWith:NO];
            [XLUserMessage setPaoNanRealName:NO];
        }
    } errors:^(id errors) {
        NSLog(@"实名认证%@", errors);
    }];
}
- (void)setRealNameViewWith:(BOOL)isRealName{
    if (!isRealName) {
        if (![self.view viewWithTag:1611]) {
            VerifyRealNameView *backView = [[VerifyRealNameView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 105, SCREEN_WIDTH, 40)];
            backView.VerfyRealNameBlock = ^{
                RealNameViewController *nameVC = [[RealNameViewController alloc] init];
                [self.navigationController pushViewController:nameVC animated:YES];
            };
            backView.tag = 1611;
            [self.view addSubview:backView];
        }
    }else{
        [[self.view viewWithTag:1611] removeFromSuperview];
    }
    if (![XLUserMessage getPaoNanDeposit]) {
        if (![self.view viewWithTag:1610]) {
            DepositView *depoistView = [[DepositView alloc] initWithFrame:CGRectMake(0, self.naviView.height, SCREEN_WIDTH, 40)];
            depoistView.DepositBlock = ^{
                MyDepositViewController *depositVC = loadViewControllerFromStoryboard(@"MyDepositViewController", @"DepositVC");
                [self.navigationController pushViewController:depositVC animated:YES];
            };
            depoistView.tag = 1610;
            [self.view addSubview:depoistView];
        }
    }else{
        [[self.view viewWithTag:1610] removeFromSuperview];
    }
}

- (void)getMoreData{
    pageCount++;
    [self getRequestData];
}

- (void)getRefreshData{
    pageCount = 1;
    [_sourceArray removeAllObjects];
    [self getRequestData];
    [self getRealNameRequestData];
}

- (void)getRequestData{
    [self showProgressHUD];
    NSString *port;
    if ([self.orderStatus isEqualToString:@"2"]) {
        port = @"PnBusiness.OrderLists";
    }else{
        port = @"PnBusiness.ToBeDoneList";
    }
    [NetDataRequest PaoNanOrderListWithOrderStatus:self.orderStatus PayStatus:@"1" Page:[NSString stringWithFormat:@"%@", @(pageCount)] PortName:port success:^(id resobject) {
        [self hidenProgressHUD];
        [_xltableView.mj_header endRefreshing];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            for (NSDictionary *dic in resobject[@"data"]) {
                OrderListModel *model = [OrderListModel OrderWithDictionary:dic];
                [self.sourceArray addObject:model];
            }
            if (_sourceArray.count % 10) {
                [_xltableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [self showOnleText:@"暂无订单" delay:1];
        }
        [_xltableView reloadData];
    } errors:^(id errors) {
        NSLog(@"%@", errors);
        [self showOnleText:@"网络或数据异常" delay:1];
        [self hidenProgressHUD];
        [_xltableView.mj_header endRefreshing];
    }];
}

#pragma mark ------------- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AchieveListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"AchieveListTableViewCell" forIndexPath:indexPath];
    listCell.currentLocation = _currentLocation;
    if (indexPath.row < _sourceArray.count) {
        listCell.listModel = self.sourceArray[indexPath.section];
    }
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    listCell.checkOrderDetailBlock = ^{
        [self addPopFootViewWithIndex:indexPath.section];
    };
    return listCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sourceArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = backViewColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0 : 6;
}

- (void)addPopViewWithIndexPath:(NSInteger)indexPath{
    [[self.view.window viewWithTag:1031] removeFromSuperview];
    if (![self.view.window viewWithTag:1030]) {
        OrderPopView *orderView = loadViewFromXibWithName(@"OrderPopView", nil);
        orderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 310);
        orderView.tag = 1030;
        orderView.delegate = self;
        orderView.indexPatch = indexPath;
        orderView.currentLocation = _currentLocation;
        orderView.listModel = self.sourceArray[indexPath];
        orderView.isList = [self.orderStatus isEqualToString:@"2"] ? YES : NO;
        [_footView.OrderBackView addSubview:orderView];
    }
}

- (void)addMapViewWithIndex:(NSInteger)index{
    [[self.view.window viewWithTag:1030] removeFromSuperview];
    if (![self.view.window viewWithTag:1031]) {
        OrderMapView *mapView = loadViewFromXibWithName(@"OrderMapView", nil);
        mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 310);
        mapView.tag = 1031;
        mapView.delegate = self;
        mapView.indexPatch = index;
        mapView.currentLocation = _currentLocation;
        mapView.listModel = self.sourceArray[index];
        [_footView.OrderBackView addSubview:mapView];
    }
}

//弹出框底部试图
- (void)addPopFootViewWithIndex:(NSInteger)index{
    if ([self.orderStatus isEqualToString:@"2"]) {
            if (![self.view.window viewWithTag:1032]) {
                OrderPopFootView *footView = loadViewFromXibWithName(@"OrderPopFootView", nil);
                footView.frame = self.view.window.frame;
                footView.isList = [self.orderStatus isEqualToString:@"2"] ? YES : NO;
                footView.indexPatch = index;
                footView.delegate = self;
                footView.tag = 1032;
                [self.view.window addSubview:footView];
                _footView = footView;
                [self addPopViewWithIndexPath:index];
            }
    }else{
        //完成订单
        [self AchiecePaoTuiOrder:index];
    }
}
#pragma mark ------------- OrderPopViewDelegate
- (void)CancelOrderPopView{
    [[self.view.window viewWithTag:1030] removeFromSuperview];
    [[self.view.window viewWithTag:1031] removeFromSuperview];
    [[self.view.window viewWithTag:1032] removeFromSuperview];
}

#pragma mark ------------ OrderMapViewDelegate
- (void)CancelOrderMapPopView{
    [self CancelOrderPopView];
}
- (void)CheckAchieveOrderMapDetailView:(NSInteger)index{
    [self addPopViewWithIndexPath:index];
}

- (void)CheckAchieveMapViewAction:(NSInteger)index{
    [self addMapViewWithIndex:index];
}

- (void)SendCodeNum:(NSString *)code{
    _codeNum = code;
}

- (void)AchievePaoTuiOrderAction:(NSInteger)index{

    if ([self.orderStatus isEqualToString:@"2"]) {
        [self StartGrabOrderAction:index];
    }
//else{
//        //完成订单
//        [self AchiecePaoTuiOrder:index];
//    }
}
- (void)StartGrabOrderAction:(NSInteger)index{
    OrderListModel *model = _sourceArray[index];
    [NetDataRequest UserGrabOrderWithOrderid:model.paotui_id PaonanId:[XLUserMessage getUserID] success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showAlertView:@"抢单成功"];
            [self CancelOrderPopView];
            [self getRefreshData];
        }else{
            [self CancelOrderPopView];
            [self showAlertView:resobject[@"msg"]];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:1];
    }];
}
- (void)AchiecePaoTuiOrder:(NSInteger)index{

    [self CancelOrderPopView];
    OrderListModel *model = _sourceArray[index];
    if ([model.type isEqualToString:@"song"] || [model.type isEqualToString:@"paotui"] || [model.type isEqualToString:@"buy"]) {
        RunFlowViewController *flowVC = [[RunFlowViewController alloc] init];
        flowVC.listModel = model;
        flowVC.contentTitle = @"接单任务";
        flowVC.RunFlowAchieveBlock = ^(BOOL isYes) {
            [self getRefreshData];
        };
        [self.navigationController pushViewController:flowVC animated:YES];
    }else if ([model.type isEqualToString:@"queue"]){
        RunWaitViewController *waitVC = [[RunWaitViewController alloc] init];
        waitVC.listModel = model;
        waitVC.isWait = YES;
        [self.navigationController pushViewController:waitVC animated:YES];
    }else{
        //帮帮
        RunWaitViewController *waitVC = [[RunWaitViewController alloc] init];
        waitVC.listModel = model;
        waitVC.isWait = NO;
        [self.navigationController pushViewController:waitVC animated:YES];
    }
}

- (void)showAlertView:(NSString *)text{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:text message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)xltableView{
    if (!_xltableView) {
        _xltableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _xltableView.delegate = self;
        _xltableView.dataSource = self;
        _xltableView.height = self.view.frame.size.height - 64;
        [_xltableView registerNib:[UINib nibWithNibName:@"AchieveListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AchieveListTableViewCell"];
        _xltableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _xltableView;
}

- (NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray new];
    }
    return _sourceArray;
}
@end
