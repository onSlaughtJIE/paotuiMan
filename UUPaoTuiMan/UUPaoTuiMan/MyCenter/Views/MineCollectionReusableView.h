//
//  MineCollectionReusableView.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/31.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterMessageModel.h"

@interface MineCollectionReusableView : UICollectionReusableView

@property(nonatomic, strong) CenterMessageModel *messageModel;
@property(nonatomic, copy) void(^ChangeHeadImageBlock)();

@end
