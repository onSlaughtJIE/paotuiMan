//
//  OrderMapView.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/10.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
#import <CoreLocation/CoreLocation.h>

@protocol OrderMapViewDelegate<NSObject>

- (void)CancelOrderMapPopView;
- (void)CheckAchieveOrderMapDetailView:(NSInteger)index;
- (void)AchievePaoTuiOrderAction:(NSInteger)index;
- (void)CheckAchieveMapViewAction:(NSInteger)index;

@end

@interface OrderMapView : UIView

@property(nonatomic, strong) OrderListModel *listModel;
@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, assign) NSInteger indexPatch;
@property(nonatomic, assign) id<OrderMapViewDelegate>delegate;

@end

@interface OrderPopFootView : UIView
{
    NSTimer *orderTimer;
    NSInteger timerCode;
}
@property (weak, nonatomic) IBOutlet UIButton *GrabButton;
@property(nonatomic, assign) BOOL isList;
@property(nonatomic, assign) NSInteger indexPatch;

@property(nonatomic, assign) id<OrderMapViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *OrderBackView;

@end
