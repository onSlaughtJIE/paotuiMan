//
//  MessageCenterTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@interface MessageCenterTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *jiaoView;

@end

@implementation MessageCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MessageCenterModel *)model{
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    _timeLabel.text = [XLConvertTools timeSp:model.dateline];
    _jiaoView.hidden = [model.is_read boolValue];
}

+(CGFloat)getCellHeightWithContent:(NSString *)content{
    return [[self alloc] messageCellHeightWithTitle:content];
}

- (CGFloat)messageCellHeightWithTitle:(NSString *)content{
    CGFloat height = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    return height + 75;
}

@end
