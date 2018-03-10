//
//  ShopStoreCollectionViewCell.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@interface ShopStoreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property(nonatomic, strong) MallListModel *listModel;

@property(nonatomic, copy) void(^ShopStoreListSellBlock)(void);
@end
