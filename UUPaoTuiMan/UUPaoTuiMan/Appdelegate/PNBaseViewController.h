//
//  PNBaseViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

typedef NS_ENUM(NSInteger, PositionStype) {
    //    PositionTop,
    PositionCenter,
    PositionBottom,
};
@interface PNBaseViewController : UIViewController

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UILabel *controllTitleLabel;
@property(nonatomic, strong) UIButton *popButton;

//loading对象
@property (nonatomic, strong) MBProgressHUD *progressHUD;
//显示loading
- (void)showProgressHUD;
//带文字的loading
- (void)showProgressHUDWithStr:(NSString *)str;
//隐藏loading
- (void)hidenProgressHUD;
    
//只展示文字
- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay;
//  封装显示弹出框的方法,过1秒自动消失
- (void)showAlertControlerWithMessage:(NSString *)message delay:(NSTimeInterval)delay;
//显示位置
- (void)showOnlyText:(NSString *)text delay:(NSTimeInterval)delay position:(PositionStype)position;
    
- (void)supviewCusNavi;

@end
