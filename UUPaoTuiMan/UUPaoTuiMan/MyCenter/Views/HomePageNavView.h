//
//  HomePageNavView.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/8.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterMessageModel.h"
@protocol HomePageTypeDelegate <NSObject>

- (void)HomePageSelectType:(NSInteger)PriceType;

@end
@interface HomePageNavView : UIView
@property(nonatomic, assign) id<HomePageTypeDelegate>delegate;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *titleArray;

@property(nonatomic, assign) NSInteger index;
@end

@interface RealTimeFootView : UIView
@property (weak, nonatomic) IBOutlet UILabel *todayOrderLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property(nonatomic, strong) CenterMessageModel *messageModel;
@property(nonatomic, copy) void(^ChangeHeadImageBlock)();

@end
