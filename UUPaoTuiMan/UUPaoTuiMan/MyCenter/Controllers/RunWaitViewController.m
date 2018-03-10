//
//  RunWaitViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/10.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RunWaitViewController.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import "RunFlowTableViewCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface RunWaitViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>
{
    UIButton *flowBtn;
    NSTimer *timer;
    NSInteger timeCount;
}
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property(nonatomic, strong) MAMapView *mapView;
@property(nonatomic, strong) NSDictionary *stepDic;
@property(nonatomic, strong) NSDictionary *typeDic;
@property(nonatomic, copy) NSString *nowTime;

@end

@implementation RunWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isWait) {
        _typeDic = @{@"NowStartToQueue":@"1",@"ArriveQueuePlace":@"2",@"StartToTiming":@"3",@"EndQueue":@"4", @"Code":@"5"};
        _stepDic = @{@"现在出发":@"1",@"我已经到达排队地点":@"2",@"开始计时":@"3",@"结束排队":@"4", @"输入验证码,完成订单":@"5"};
    }else{
        _typeDic = @{@"NowStartToHelp":@"1",@"ArriveHelpPlace":@"2",@"EndHelp":@"3", @"Code":@"4"};
        _stepDic = @{@"现在出发":@"1",@"我已经到达帮助地点 ":@"2",@"结束帮助":@"3", @"输入验证码,完成订单":@"4"};
    }

    [self supviewCusNavi];
    [self setHeadView];
    [self setNavView];
    [self configLocationManager];
}

- (void)setNavView{
    self.controllTitleLabel.text = @"接单流程";
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40)];
    backView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:backView];
    
    UIButton *daoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    daoBtn.size = CGSizeMake(100, 40);
    daoBtn.right = backView.width;
    daoBtn.top = 0;
    [daoBtn setBackgroundColor:RED_COLOR];
    [daoBtn setTitle:@"查看导航" forState:UIControlStateNormal];
    [daoBtn addTarget:self action:@selector(daoHangAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:daoBtn];
    
    flowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flowBtn.size = CGSizeMake(SCREEN_WIDTH - 101, 40);
    flowBtn.left = 0;
    flowBtn.centerY = daoBtn.centerY;
    [flowBtn setBackgroundColor:RED_COLOR];
    flowBtn.tag = [_listModel.process_step integerValue] + 1;
    [_stepDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:[NSString stringWithFormat:@"%@", @(flowBtn.tag)]]) {
            [flowBtn setTitle:key  forState:UIControlStateNormal];
            if ([key isEqualToString:@"结束排队"]) {
                [self getTImerTimeView];
            }
        }
    }];
    [flowBtn addTarget:self action:@selector(startWaitAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:flowBtn];
    
}
- (void)backAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    [_locationManager stopUpdatingLocation];
}

- (void)daoHangAction:(UIButton *)button{
    //导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        //地理编码器
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //设定一个终点坐标
        [geocoder geocodeAddressString:_listModel.o_addr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *placemark in placemarks){
                //坐标（经纬度)
                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"UUPaoTuiMan",@"demoURL://",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }];
    }else{
        [self showOnleText:@"您的iPhone未安装高德地图" delay:1];
    }
    
}

- (void)startWaitAction:(UIButton *)button{
    if (_isWait) {
        [_typeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:[NSString stringWithFormat:@"%@", @(button.tag)] ]) {
                if ([key isEqualToString:@"EndQueue"] || [_listModel.process_step isEqualToString:@"4"]){
                    [self achieveOrder];
                }else{
                    [self startFlowRequest:key Url:@"service=PnBusiness.PnQueueProcess"];
                }
            }
        }];
    }else{
        [_typeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:[NSString stringWithFormat:@"%@", @(button.tag)] ]) {
                if ([key isEqualToString:@"EndHelp"] || [_listModel.process_step isEqualToString:@"3"]) {
                    [self achieveOrder];
                }else{
                    [self startFlowRequest:key Url:@"service=PnBusiness.PnHelpProcess"];
                }
            }
        }];
    }
}

- (void)achieveOrder{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请输入收货人的验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *codeTextField = alertC.textFields.lastObject;
        if ([XLConvertTools isEmptyString:codeTextField.text]) {
            [self showOnleText:@"请输入下单用户的验证码" delay:1];
            return;
        }
        [NetDataRequest AchievePaoNanOrderWithOrderId:_listModel.paotui_id CodeNum:codeTextField.text success:^(id resobject) {
            if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [self showOnleText:resobject[@"msg"] delay:1];
            }
            
        } errors:^(id errors) {
            [self showOnleText:@"网络或数据异常" delay:1];
        }];
    }]];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入验证码";
    }];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)startFlowRequest:(NSString *)type Url:(NSString *)url{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:type forKey:@"stepType"];
    [dic setValue:_listModel.paotui_id forKey:@"orderId"];
    [NetDataRequest OrderWaitFlowWithStatus:dic RequestStr:url Success:^(id resobject) {
        if ([resobject[@"msgcode"] integerValue] == 0) {
            [_stepDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:[NSString stringWithFormat:@"%@", @(flowBtn.tag + 1)] ]) {
                    [flowBtn setTitle:key  forState:UIControlStateNormal];
                    flowBtn.tag = [[_typeDic objectForKey:type] integerValue];
                    if ([type isEqualToString:@"StartToTiming"]) {
                        [self getTImerTimeView];
                    }
                    if ([type isEqualToString:@"EndQueue"]) {
                        [timer invalidate];
                        timer = nil;
                    }
                }
            }];
            
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:1];
    }];
}

- (void)getTImerTimeView{
    _mapView.hidden = YES;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 164, SCREEN_WIDTH, SCREEN_HEIGHT - 205)];
    backView.tag = 1809;
    backView.backgroundColor = WHITE_COLOR;
    backView.layer.borderColor = backViewColor.CGColor;
    backView.layer.borderWidth = .5;
    [self.view addSubview:backView];
    UILabel *titleLabel = [UILabel labelWithTitle:@"距离排队结束时间" fontSize:15 color:BLACK_COLOR alignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);
    [backView addSubview:titleLabel];
    
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 190) / 2, titleLabel.bottom + 15, 190, 80)];
    [backView addSubview:timeView];
    NSArray *array = @[@"(小时)",@"(分钟)",@"(秒)"];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"timerTIme"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(65 * i, 0, 60, 60)];
        button.tag = 100 + i;
        [button setTitle:@"0" forState:UIControlStateNormal];
        [timeView addSubview:button];
        
        UILabel *label = [UILabel labelWithTitle:array[i] fontSize:15 color:DARKGRAY_COLOR alignment:NSTextAlignmentCenter];
        label.top = button.bottom + 5;
        [label sizeToFit];
        label.centerX = button.centerX;
        [timeView addSubview:label];
    }
    
    if ([_listModel.process_step integerValue] == 3) {
        [NetDataRequest OrderDetailWithStatus:@{@"order_id":_listModel.paotui_id, @"type":_listModel.order_type} Success:^(id resobject) {
            if ([resobject[@"msgcode"] integerValue] == 0) {
                NSString *nowTime = resobject[@"data"][@"now_time"];
                timeCount = [_listModel.queue_end_time integerValue] - [nowTime integerValue];
                if (timeCount < 0) {
                    timeCount = 0;
                }
                [self getTimerTime:[NSString stringWithFormat:@"%@", @(timeCount)]];
            }
        } errors:^(id errors) {
        }];
    }else{
        timeCount = [_listModel.queue_time integerValue] * 60;
        [self getTimerTime:[NSString stringWithFormat:@"%@", @(timeCount)]];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeTime) userInfo:nil repeats:YES];
}

- (void)removeTime{
    timeCount --;
    if (timeCount <= 0) {
        [timer invalidate];
        timer = nil;
        [self getTimerTime:@"0"];
    }else{
        [self getTimerTime:[NSString stringWithFormat:@"%@", @(timeCount)]];
    }
}

- (void)getTimerTime:(NSString *)Seconds{
    UIButton *firstBtn = (UIButton *)[self.view viewWithTag:100];
    UIButton *secondBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *thirdBtn = (UIButton *)[self.view viewWithTag:102];
    
    int totalSeconds = [Seconds intValue];
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    int hours = totalSeconds / 3600;
    
    [firstBtn setTitle:[NSString stringWithFormat:@"%02d", hours] forState:UIControlStateNormal];
    [secondBtn setTitle:[NSString stringWithFormat:@"%02d", minutes] forState:UIControlStateNormal];
    [thirdBtn setTitle:[NSString stringWithFormat:@"%02d", seconds] forState:UIControlStateNormal];
}

- (void)getMapView{
    _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    _mapView.top = 164;;
    _mapView.height = SCREEN_HEIGHT - 205;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    _mapView.delegate = self;
    [_mapView setZoomLevel:15.1 animated:NO];
    [self.view addSubview:_mapView];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([_listModel.o_lat floatValue], [_listModel.o_lng floatValue]);
    [_mapView addAnnotation:pointAnnotation];
}

- (void)setHeadView{
    RunWaitHeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"RunFlowHeadView" owner:nil options:nil].lastObject;
    headView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
    headView.addressLabel.text = [NSString stringWithFormat:@"地点:%@", _listModel.o_addr];
    if (_isWait) {
        headView.timeLabel.text = [NSString stringWithFormat:@"时间:排队%@分钟", _listModel.queue_time];
    }else{
        headView.timeLabel.text = @"立即前往";
    }
    headView.descLabel.text = [NSString stringWithFormat:@"备注:%@", _listModel.intro];
    [headView.phoneButton addTarget:self action:@selector(phoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    [self getMapView];
}

- (void)phoneButtonAction{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_listModel.o_mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_locationManager stopUpdatingLocation];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}
#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.draggable = YES;
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    
    return nil;
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f; reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    //获取到定位信息，更新annotation
    if (self.pointAnnotaiton == nil)
    {
        
        [self.pointAnnotaiton setCoordinate:CLLocationCoordinate2DMake([_listModel.o_lat floatValue], [_listModel.o_lng floatValue])];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    [self.pointAnnotaiton setCoordinate:CLLocationCoordinate2DMake([_listModel.o_lat floatValue], [_listModel.o_lng floatValue])];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([_listModel.o_lat floatValue], [_listModel.o_lng floatValue])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
