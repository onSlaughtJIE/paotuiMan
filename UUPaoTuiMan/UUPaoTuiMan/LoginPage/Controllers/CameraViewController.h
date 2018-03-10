//
//  CameraViewController.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/28.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "PNBaseViewController.h"

@interface CameraViewController : PNBaseViewController

@property(nonatomic, copy) void(^selectPhotoImage)(UIImage *);

@end
