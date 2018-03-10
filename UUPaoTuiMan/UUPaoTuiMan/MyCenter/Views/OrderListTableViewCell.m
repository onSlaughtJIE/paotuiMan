//
//  OrderListTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "OrderListTableViewCell.h"

@interface OrderListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(OrderListModel *)listModel{
    _startAddressLabel.text = [NSString stringWithFormat:@"发:%@", listModel.addr];
    _endAddressLabel.text = [NSString stringWithFormat:@"收:%@", listModel.o_addr];
    if ([listModel.type isEqualToString:@"help"]) {
        _titleLabel.text = @"代帮帮";
        _endAddressLabel.text = @"";
        _startAddressLabel.text = [NSString stringWithFormat:@"帮帮地址:%@", listModel.o_addr];
    }else if ([listModel.type isEqualToString:@"paotui"]){
        _titleLabel.text = @"帮我取";
    }else if ([listModel.type isEqualToString:@"buy"]){
        _titleLabel.text = @"帮我买";
    }else if ([listModel.type isEqualToString:@"queue"]){
        _titleLabel.text = @"代排队";
        _endAddressLabel.text = @"";
        _startAddressLabel.text = [NSString stringWithFormat:@"排队地址:%@", listModel.o_addr];
    }else if ([listModel.type isEqualToString:@"song"]) {
    _titleLabel.text = @"帮我送";
    }
    _noticeLabel.text = [NSString stringWithFormat:@"备:%@", listModel.intro];
    _moneyLabel.text = [NSString stringWithFormat:@"本单收入:%@元", listModel.paotui_amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation HomeTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
