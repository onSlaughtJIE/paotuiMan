//
//  OrderMapView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/10.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "OrderMapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface OrderMapView ()<MAMapViewDelegate, AMapNaviRideManagerDelegate, AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDistanceLabel;
@property(nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapNaviRideManager *rideManager;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;
@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;

@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@end

@implementation OrderMapView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(10, 130, self.width - 20, 130)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = NO;
    [self.mapView setZoomLevel:15];
//    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    [self addSubview:self.mapView];
    if (self.rideManager == nil)
    {
        self.rideManager = [[AMapNaviRideManager alloc] init];
        [self.rideManager setDelegate:self];
    }
}

- (void)setListModel:(OrderListModel *)listModel{
    _listModel = listModel;
    if ([listModel.type isEqualToString:@"help"]) {
        _titleLabel.text = @"代帮帮";
        self.startPoint = [AMapNaviPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];

    }else if ([listModel.type isEqualToString:@"paotui"]){
        _titleLabel.text = @"帮我取";
        self.startPoint = [AMapNaviPoint locationWithLatitude:[listModel.lat floatValue] longitude:[listModel.lng floatValue]];

    }else if ([listModel.type isEqualToString:@"buy"]){
        _titleLabel.text = @"帮我买";
        self.startPoint = [AMapNaviPoint locationWithLatitude:[listModel.lat floatValue] longitude:[listModel.lng floatValue]];

    }else if ([listModel.type isEqualToString:@"queue"]){
        _titleLabel.text = @"代排队";
        self.startPoint = [AMapNaviPoint locationWithLatitude:[listModel.lat floatValue] longitude:[listModel.lng floatValue]];

    }else if ([listModel.type isEqualToString:@"song"]) {
        _titleLabel.text = @"帮我送";
        self.startPoint = [AMapNaviPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];

    }
    double orderDistance = [self distanceBetweenOrderBy:[listModel.lat doubleValue] :[listModel.o_lat doubleValue] :[listModel.lng doubleValue] :[listModel.o_lng doubleValue]];
    _orderDistanceLabel.text = [NSString stringWithFormat:@"订单距离:%.2f公里", orderDistance];
    double Distance = [self distanceBetweenOrderBy:self.currentLocation.coordinate.latitude :[listModel.o_lat doubleValue] :self.currentLocation.coordinate.longitude :[listModel.o_lng doubleValue]];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里", Distance];
    
//    self.startPoint = [AMapNaviPoint locationWithLatitude:[listModel.lat floatValue] longitude:[listModel.lng floatValue]];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:[listModel.o_lat floatValue] longitude:[listModel.o_lng floatValue]];
    self.routeIndicatorInfoArray = [NSMutableArray array];
    [self initAnnotations];
    [self.rideManager calculateRideRouteWithStartPoint:self.startPoint
                                              endPoint:self.endPoint];
    
}

- (void)initAnnotations
{
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;
    
    [self.mapView addAnnotation:beginAnnotation];
    
    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;
    
    [self.mapView addAnnotation:endAnnotation];
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)rideManager:(AMapNaviRideManager *)rideManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)rideManagerOnCalculateRouteSuccess:(AMapNaviRideManager *)rideManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后显示路径
    [self showNaviRoutes];
}

#pragma mark - Handle Navi Routes

- (void)showNaviRoutes
{
    if (self.rideManager.naviRoute == nil)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    //将路径显示到地图上
    AMapNaviRoute *aRoute = self.rideManager.naviRoute;
    int count = (int)[[aRoute routeCoordinates] count];
    
    //添加路径Polyline
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
    {
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        coords[i].latitude = [coordinate latitude];
        coords[i].longitude = [coordinate longitude];
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    
    SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
    
    [self.mapView addOverlay:selectablePolyline];
    free(coords);
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
}

#pragma mark - MAMapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NaviPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"NaviPointAnnotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil){
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        NaviPointAnnotation *navAnnotation = (NaviPointAnnotation *)annotation;
        if (navAnnotation.navPointType == NaviPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }
        else if (navAnnotation.navPointType == NaviPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        return pointAnnotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        return polylineRenderer;
    }
    
    return nil;
}

-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double  distance  = [curLocation distanceFromLocation:otherLocation] / 1000;
    return  distance;
}

- (IBAction)CancelAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CancelOrderMapPopView)]) {
        [_delegate CancelOrderMapPopView];
    }
}

@end


@implementation OrderPopFootView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [BLACK_COLOR colorWithAlphaComponent:0.5];
}

- (void)setIsList:(BOOL)isList{
    if (isList) {
        timerCode = 7;
        orderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getOrderListen) userInfo:nil repeats:YES];
    }else{
        [_GrabButton setTitle:@"完成跑腿" forState:UIControlStateNormal];
    }
}

- (void)getOrderListen{
    timerCode--;
    if (timerCode == 0) {
        [_GrabButton setTitle:@"抢单" forState:UIControlStateNormal];
        _GrabButton.userInteractionEnabled = YES;
        [orderTimer invalidate];
        orderTimer = nil;
    }else {
        [_GrabButton setTitle:[NSString stringWithFormat:@"%lds", (long)timerCode] forState:UIControlStateNormal];
    }
}

- (IBAction)OrderDetailAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CheckAchieveOrderMapDetailView:)]) {
        [_delegate CheckAchieveOrderMapDetailView:_indexPatch];
        UIButton *button = sender;
        button.selected = YES;
        UIButton *unButton = (UIButton *)[self viewWithTag:15];
        unButton.selected = NO;
    }
}
- (IBAction)OrderMapAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CheckAchieveMapViewAction:)]) {
        [_delegate CheckAchieveMapViewAction:_indexPatch];
        UIButton *button = sender;
        button.selected = YES;
        UIButton *unButton = (UIButton *)[self viewWithTag:16];
        unButton.selected = NO;
    }
}
- (IBAction)AchieveOrderButton:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(AchievePaoTuiOrderAction:)]) {
        [_delegate AchievePaoTuiOrderAction:_indexPatch];
    }
}

@end
