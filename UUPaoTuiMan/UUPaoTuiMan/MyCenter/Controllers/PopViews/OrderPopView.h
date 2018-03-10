//
//  OrderPopViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
#import <CoreLocation/CoreLocation.h>

@protocol OrderPopViewDelegate<NSObject>

- (void)CancelOrderPopView;
- (void)SendCodeNum:(NSString *)code;

@end

@interface OrderPopView : UIView
@property(nonatomic, strong) OrderListModel *listModel;
@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, assign) NSInteger indexPatch;
@property(nonatomic, assign) BOOL isList;
@property(nonatomic, assign) id<OrderPopViewDelegate>delegate;
@end
