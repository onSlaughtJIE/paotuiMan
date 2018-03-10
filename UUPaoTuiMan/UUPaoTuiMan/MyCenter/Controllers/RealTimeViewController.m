//
//  RealTimeViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/8.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RealTimeViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "OrderListTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <ContactsUI/CNContactPickerViewController.h>
#import "CenterMessageModel.h"
#import "HomePageNavView.h"
#import "MineMessageViewController.h"
#import <UIImageView+AFNetworking.h>
#import "CircleLoaderView.h"
#import "OrderListModel.h"
#import "OrderPopView.h"
#import <AVFoundation/AVFoundation.h>
#import "MyMapViewController.h"
#import "OrderMapView.h"
#import "OrderPopView.h"
#import "VerifyRealNameView.h"
#import "RealNameViewController.h"
#import "DepositView.h"
#import "MyDepositViewController.h"
#import "RunFlowViewController.h"
#import "RunWaitViewController.h"

@interface RealTimeViewController ()<UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, OrderPopViewDelegate, OrderMapViewDelegate>
{
    UIView *orderFootView;
    CLLocation *currentLocation;
}
@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(nonatomic, strong) CenterMessageModel *messageModel;
@property(nonatomic, weak) CircleLoaderView *circleView;
@property(nonatomic, strong) OrderListModel *orderModel;
@property(nonatomic, weak) OrderPopFootView *footView;
@property(nonatomic, strong)     NSTimer *orderTimer;

@end

@implementation RealTimeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setRealNameViewWith:[XLUserMessage getPaoNanRealName]];
    [self setIsDepositViewWith:[XLUserMessage getPaoNanDeposit]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createtableView];
    [self StartLocationManager];
    [self getRefreshData];
//    [self getRealNameRequestData];
    self.xltableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshData)];
}
- (void)getRefreshData{
    [self showProgressHUD];
    [NetDataRequest CenterMessageForMeWithDic:@{@"nid":[XLUserMessage getUserID]} success:^(id resobject) {
        [self hidenProgressHUD];
        [_xltableView.mj_header endRefreshing];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            self.messageModel = [CenterMessageModel PersonMessageWithDic:resobject[@"data"]];
            [self setIsDepositViewWith:[_messageModel.is_deposit isEqualToString:@"1"]];
            [XLUserMessage setPaoNanDeposit:[_messageModel.is_deposit isEqualToString:@"1"]];
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
        [_xltableView reloadData];
        [self StartLocationManager];
        [self getRealNameRequestData];
    } errors:^(id errors) {
        [self hidenProgressHUD];
        [self showOnleText:@"数据或网络异常" delay:1];
        [_xltableView.mj_header endRefreshing];
    }];
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
    }];
}
- (void)setRealNameViewWith:(BOOL)isRealName{
    if (!isRealName) {
        if (![self.view viewWithTag:1509]) {
            VerifyRealNameView *backView = [[VerifyRealNameView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40 - 64, SCREEN_WIDTH, 40)];
            backView.VerfyRealNameBlock = ^{
                RealNameViewController *nameVC = [[RealNameViewController alloc] init];
                [self.navigationController pushViewController:nameVC animated:YES];
            };
            backView.tag = 1509;
            [self.view addSubview:backView];
        }
    }else{
        [[self.view viewWithTag:1509] removeFromSuperview];
    }
}
- (void)setIsDepositViewWith:(BOOL)isDeposit{
    if (!isDeposit) {
        if (![self.view viewWithTag:1508]) {
            DepositView *depoistView = [[DepositView alloc] initWithFrame:CGRectMake(0, self.naviView.height, SCREEN_WIDTH, 40)];
            depoistView.DepositBlock = ^{
                MyDepositViewController *depositVC = loadViewControllerFromStoryboard(@"MyDepositViewController", @"DepositVC");
                [self.navigationController pushViewController:depositVC animated:YES];
            };
            depoistView.tag = 1508;
            [self.view addSubview:depoistView];
        }
    }else{
        [[self.view viewWithTag:1508] removeFromSuperview];
    }
}
- (void)createtableView {
    self.naviView.height = 0;
    self.popButton.height = 0;
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_xltableView];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView registerNib:[UINib nibWithNibName:@"HomeTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTimeTableViewCell"];
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _xltableView.backgroundColor = WHITE_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTimeTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *imageArray = @[@"Date", @"Address"];
        cell.headImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
        if (indexPath.row == 0) {
            NSDate *newDate = [NSDate date];
            NSCalendar*calendar = [NSCalendar currentCalendar];
            NSDateComponents *comps =[calendar components:(NSCalendarUnitMonth |NSCalendarUnitDay)fromDate:newDate];
            NSInteger month = [comps month];
            NSInteger day = [comps day];
            NSDateComponents *compWeek =[calendar components:(NSCalendarUnitWeekday) fromDate:newDate];
            NSInteger week = [compWeek weekday];
            NSArray *weekArray = @[@"一", @"二", @"三",@"四", @"五", @"六", @"日"];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@月%@日 星期%@", @(month), @(day), weekArray[week-2]];
        }else{
            cell.titleLabel.tag = 10;
            cell.titleLabel.text = @"我的位置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }else{
        UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        if (!tableCell) {
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }
        if (![tableCell viewWithTag:1628]) {
            for (int i = 0; i < 2; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (SCREEN_WIDTH / 2 - 10)* i , 10, SCREEN_WIDTH / 2 - 50, SCREEN_WIDTH / 2 - 50)];
                imageView.tag = 1628 + i;
                [tableCell addSubview:imageView];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom + 5, imageView.width, 20)];
                label.tag = 1640 + i;
                label.textAlignment = NSTextAlignmentCenter;
                [tableCell addSubview:label];
            }
        }
        UIImageView *imageView = (UIImageView *)[tableCell viewWithTag:1628];
        UIImageView *userImageView = (UIImageView *)[tableCell viewWithTag:1629];
        UILabel *label = (UILabel *)[tableCell viewWithTag:1640];
        UILabel *labelUser = (UILabel *)[tableCell viewWithTag:1641];
        label.text = @"推荐跑客";
        labelUser.text =@"推荐用户";
        [imageView  setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API, _messageModel.qrcode_img]] placeholderImage:[UIImage imageNamed:@"UnPicture"]];
         [userImageView  setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,DOMAIN_API, _messageModel.qrcode_img_referuser]] placeholderImage:[UIImage imageNamed:@"UnPicture"]];
        tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return tableCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return section == 0 ? 1: 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 100 : 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = backViewColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 44;
                break;
            case 1:
                return 60;
                break;
        }
    }
    return SCREEN_WIDTH / 2 - 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        RealTimeFootView *timeView = loadViewFromXibWithName(@"RealTimeFootView", nil);
        if (_messageModel.money) {
            timeView.messageModel = self.messageModel;
        }
        timeView.ChangeHeadImageBlock = ^{
            MineMessageViewController *mineVC = [[MineMessageViewController alloc] init];
            [self.navigationController pushViewController:mineVC animated:YES];
        };
        return timeView;
    }else{
        orderFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
        orderFootView.backgroundColor = WHITE_COLOR;
        
        //设置视图大小
        CircleLoaderView *circleView=[[CircleLoaderView alloc]initWithFrame:CGRectMake(0, 65, 80, 70)];
        circleView.bottom = orderFootView.bottom - 15;
        circleView.centerX  = orderFootView.centerX;
        circleView.userInteractionEnabled = YES;
        //设置轨道颜色
        circleView.trackTintColor = [RED_COLOR colorWithAlphaComponent:0.4];
        //设置进度条颜色
        circleView.progressTintColor=RED_COLOR;
        circleView.lineWidth=2.0;
        circleView.progressValue=0;
        [circleView setTitle:@"开始接单" forState:UIControlStateNormal];
        [circleView addTarget:self action:@selector(StartAchieveOrder) forControlEvents:UIControlEventTouchUpInside];
        [orderFootView addSubview:circleView];
        _circleView = circleView;
        
        return orderFootView;
    }
}

- (void)StartAchieveOrder{
    if (![XLUserMessage getPaoNanRealName]) {
        [self showOnleText:@"您还未通过身份认证" delay:1];
        return;
    }
    if (![XLUserMessage getPaoNanDeposit]) {
        [self showOnleText:@"您还没有交纳押金" delay:1];
        return;
    }
    [self getTimer];
}

- (void)getTimer{
    _orderTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getOrderListenRequestData) userInfo:nil repeats:YES];
    [self getOrderListenRequestData];
}

- (void)getOrderListenRequestData{
    _circleView.userInteractionEnabled = NO;
    NSString *pn_lng = [NSString stringWithFormat:@"%@", @(currentLocation.coordinate.longitude)];
    NSString *pn_lat = [NSString stringWithFormat:@"%@", @(currentLocation.coordinate.latitude)];
    [NetDataRequest UserListenOrderWithLng:pn_lng Lat:pn_lat success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [_circleView start];
            [self setEndButton];
            _circleView.progressValue=0.8;
            _circleView.animationing=YES;
            [_circleView start];
            _circleView.userInteractionEnabled = NO;
            for (NSDictionary *dic in resobject[@"data"]) {
                self.orderModel = [OrderListModel OrderWithDictionary:dic];
            }
            [self startVoiceSpeechWithContent];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addPopFootViewWithIndex];
            });
        }else{
            [self showOnleText:@"您的附近暂无订单,请稍后再试" delay:1];
            [_orderTimer invalidate];
            _orderTimer = nil;
            _circleView.userInteractionEnabled = YES;
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:2];
    }];
}

- (void)startVoiceSpeechWithContent{
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc]init];
    NSString *content = [NSString stringWithFormat:@"实时订单从%@出发到%@,%@公里,费用共%@元", self.orderModel.addr, self.orderModel.o_addr, self.orderModel.mile_count, self.orderModel.jiesuan_amount];
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:content];
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    utterance.rate = 0.5;
    [av speakUtterance:utterance];
}

- (void)endCircleAction:(UIButton *)button{
    UIAlertController *AlertC = [UIAlertController alertControllerWithTitle:nil message:@"确定停止听单?" preferredStyle:UIAlertControllerStyleAlert];
    [AlertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [AlertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _circleView.userInteractionEnabled = YES;
        [self stopListenOrder];
        [_orderTimer invalidate];
        _orderTimer = nil;
        [[self.view viewWithTag:1129] removeFromSuperview];
        [self CancelOrderPopView];
    }]];
    
    [self presentViewController:AlertC animated:YES completion:nil];
}

- (void)addPopViewWithIndexPath{
    [[self.view.window viewWithTag:1031] removeFromSuperview];
    if (![self.view.window viewWithTag:1030]) {
        OrderPopView *orderView = loadViewFromXibWithName(@"OrderPopView", nil);
        orderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 310);
        orderView.tag = 1030;
        orderView.delegate = self;
        orderView.currentLocation = currentLocation;
        orderView.listModel = self.orderModel;
        orderView.isList = YES;
        [_footView.OrderBackView addSubview:orderView];
    }
}

- (void)addMapViewWithIndex{
    [[self.view.window viewWithTag:1030] removeFromSuperview];
    if (![self.view.window viewWithTag:1031]) {
        OrderMapView *mapView = loadViewFromXibWithName(@"OrderMapView", nil);
        mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 310);
        mapView.tag = 1031;
        mapView.delegate = self;
        mapView.currentLocation = currentLocation;
        mapView.listModel = self.orderModel;
        [_footView.OrderBackView addSubview:mapView];
    }
}

//弹出框底部试图
- (void)addPopFootViewWithIndex{
    if (![self.view.window viewWithTag:1032]) {
        OrderPopFootView *footView = loadViewFromXibWithName(@"OrderPopFootView", nil);
        footView.frame = self.view.window.frame;
        footView.isList = YES;
        footView.delegate = self;
        footView.tag = 1032;
        [self.view.window addSubview:footView];
        _footView = footView;
        [self addPopViewWithIndexPath];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self CancelOrderPopView];
    });
}

- (void)setEndButton{
    if (![self.view viewWithTag:1129]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.left = orderFootView.width - 90;
        button.centerY = orderFootView.height - 80;
        button.size = CGSizeMake(30, 30);
        button.layer.cornerRadius = 15;
        button.clipsToBounds = YES;
        button.hidden = NO;
        button.tag = 1129;
        [button addTarget:self action:@selector(endCircleAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"收工" forState:UIControlStateNormal];
        [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [button setBackgroundColor:[RED_COLOR colorWithAlphaComponent:0.8]];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [orderFootView addSubview:button];
    }
}

- (void)getFlowView{
    if ([_orderModel.type isEqualToString:@"song"] || [_orderModel.type isEqualToString:@"paotui"] || [_orderModel.type isEqualToString:@"buy"]) {
        RunFlowViewController *flowVC = [[RunFlowViewController alloc] init];
        flowVC.listModel = _orderModel;
        flowVC.contentTitle = @"接单任务";
        [self.navigationController pushViewController:flowVC animated:YES];
    }else if ([_orderModel.type isEqualToString:@"queue"]){
        RunWaitViewController *waitVC = [[RunWaitViewController alloc] init];
        waitVC.listModel = _orderModel;
        waitVC.isWait = YES;
        [self.navigationController pushViewController:waitVC animated:YES];
    }else{
        //帮帮
        RunWaitViewController *waitVC = [[RunWaitViewController alloc] init];
        waitVC.listModel = _orderModel;
        waitVC.isWait = NO;
        [self.navigationController pushViewController:waitVC animated:YES];
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
    [self addPopViewWithIndexPath];
}

- (void)CheckAchieveMapViewAction:(NSInteger)index{
    [self addMapViewWithIndex];
}

- (void)SendCodeNum:(NSString *)code{
    //不需要实现
}

- (void)AchievePaoTuiOrderAction:(NSInteger)index{
    [NetDataRequest UserGrabOrderWithOrderid:self.orderModel.paotui_id PaonanId:[XLUserMessage getUserID] success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"抢单成功" delay:1];
            [self CancelOrderPopView];
            [self getFlowView];
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:1];
    }];
}

- (void)stopListenOrder{
    _circleView.progressValue=0;
    _circleView.animationing=NO;
    [_circleView start];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //地图
        MyMapViewController *mapVC = [[MyMapViewController alloc] init];
        mapVC.listModel = self.orderModel;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

//开始定位
-(void)StartLocationManager{
    if([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }else {
        NSLog(@"请开启定位功能！");
    }
}
#pragma mark - CoreLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];
    currentLocation = [locations firstObject];
    [XLUserMessage setAddressLocationLat:[NSString stringWithFormat:@"%@", @(currentLocation.coordinate.latitude)]];
    [XLUserMessage setAddressLocationLng:[NSString stringWithFormat:@"%@", @(currentLocation.coordinate.longitude)]];
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
            UILabel *addressLabel = (UILabel *)[self.view viewWithTag: 10];
            for (CLPlacemark * place in placemarks) {
                NSDictionary * location = [place addressDictionary];
                addressLabel.text = location[@"FormattedAddressLines"][0];
            }
            
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
}

- (void)dealloc {
    [_orderTimer invalidate];
    _orderTimer = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_orderTimer) {
        [_orderTimer invalidate];
        _orderTimer = nil;
        _circleView.userInteractionEnabled = YES;
        [self stopListenOrder];
        [[self.view viewWithTag:1129] removeFromSuperview];
        [self CancelOrderPopView];
    }
}

@end
