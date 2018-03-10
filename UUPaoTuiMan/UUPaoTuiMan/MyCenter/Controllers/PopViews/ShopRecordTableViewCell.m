//
//  ShopRecordTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/9/4.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ShopRecordTableViewCell.h"

@implementation ShopRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(MallSellRecordList *)listModel{
    _titleLabel.text = listModel.title;
    _timeLabel.text = [XLConvertTools timeSp:listModel.create_time];
    _priceLabel.text = [NSString stringWithFormat:@"消费金额:%@元", listModel.count_price];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
