//
//  MineMessageGenderView.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineMessageGenderView : UIView<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, copy) void(^changeGenderBlock)(NSString *);
@property(nonatomic, copy) void(^RemoveGenderBlock)();
@end
