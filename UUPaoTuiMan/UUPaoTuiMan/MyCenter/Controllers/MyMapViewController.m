//
//  MyMapViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MyMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NaviPointAnnotation.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface MyMapViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>
@property(nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@end

@implementation MyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNavView];
    [self configLocationManager];
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
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

- (void)setNavView{
    [self.view addSubview:self.mapView];
    self.controllTitleLabel.text = @"我的位置";
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [_locationManager stopUpdatingLocation];
}

- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
        _mapView.top = 64;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        _mapView.delegate = self;
        _mapView.showsCompass= NO;
        [_mapView setZoomLevel:15.1 animated:NO];
        
        //返回当前位置按钮
        UIButton *locationBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapView addSubview:locationBtn];
        [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-8);
            make.top.offset(10);
            make.height.width.offset(30);
        }];
        [locationBtn setBackgroundColor:WHITE_COLOR];
        locationBtn.layer.cornerRadius = 6;
        [locationBtn setImage:[UIImage imageNamed:@"location_address"] forState:UIControlStateNormal];
        [locationBtn addTarget:self action:@selector(backLoaction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _mapView;
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
        annotationView.canShowCallout   = NO;
        annotationView.animatesDrop     = NO;
        annotationView.draggable        = NO;
        annotationView.image            = [UIImage imageNamed:@"Address"];
        
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
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    [self.mapView setCenterCoordinate:location.coordinate];
}

- (void)backLoaction:(UIButton *)sender {
    
    //设置地图中心位置为用户当前位置
    [_mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
