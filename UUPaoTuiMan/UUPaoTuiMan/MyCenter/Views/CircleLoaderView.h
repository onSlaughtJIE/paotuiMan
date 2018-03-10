//
//  CircleLoaderView.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/8.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLoaderView : UIButton

//进度颜色
@property(nonatomic, retain) UIColor* progressTintColor ;


//轨道颜色
@property(nonatomic, retain) UIColor* trackTintColor ;

//轨道宽度
@property (nonatomic,assign) float lineWidth;

//中间图片
@property (nonatomic,strong) UIImage *centerImage;

//进度
@property (nonatomic,assign) float progressValue;
//开启动画
@property (nonatomic,assign) BOOL animationing;

//隐藏消失
- (void)hide;
- (void)start;

@end
