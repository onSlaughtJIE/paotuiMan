//
//  ShopStoreCollectionViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ShopStoreCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ShopStoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(MallListModel *)listModel{
    [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API, listModel.photo]] placeholderImage:[UIImage imageNamed:@"pictureImage"]];
    _titleLabel.text = listModel.title;
    _subTitleLabel.text = [NSString stringWithFormat:@"剩余:%@", listModel.sales];
    _priceLabel.text = listModel.price;
}

- (IBAction)shopMallAction:(id)sender {
    if (_ShopStoreListSellBlock) {
        _ShopStoreListSellBlock();
    }
}

@end
