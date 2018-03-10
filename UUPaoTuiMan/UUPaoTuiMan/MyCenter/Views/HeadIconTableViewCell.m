//
//  HeadIconTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "HeadIconTableViewCell.h"

@implementation HeadIconTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.selectionStyle = 0;
    _titleLabel = [UILabel labelWithTitle:@"头像" fontSize:16 color:BLACK_COLOR alignment:0];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.offset(20);
    }];
    _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mine_ren"]];
    [self addSubview:_iconImage];
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.offset(-15);
        make.width.height.offset(36);
        make.top.offset(15);
        make.bottom.offset(-15);
    }];
    _iconImage.layer.cornerRadius = 18;
    _iconImage.layer.masksToBounds = YES;
}

@end
