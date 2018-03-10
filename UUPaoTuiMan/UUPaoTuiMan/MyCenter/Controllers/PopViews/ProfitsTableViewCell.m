//
//  ProfitsTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/11.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ProfitsTableViewCell.h"

@interface ProfitsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *profitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ProfitsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProfitsModel:(ProfiftsModel *)profitsModel{
    _moneyLabel.text = [NSString stringWithFormat:@"本单收益:%@元", profitsModel.money];
    _profitsLabel.text = profitsModel.intro;
    _timeLabel.text = [XLConvertTools timeSp:profitsModel.dateline];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
