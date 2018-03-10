//
//  RunFlowTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RunFlowTableViewCell.h"

@implementation RunFlowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)selectButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(RunFlowSelectWith:)]) {
        [_delegate RunFlowSelectWith:_indexPatch];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setSelectIndexWithSelect:selected];
    // Configure the view for the selected state
}

- (void)setSelectIndexWithSelect:(BOOL)isSelect{
    UIColor *viewColor = isSelect ? WHITE_COLOR : LIGHTGRAY_COLOR;
    _topLineView.backgroundColor =viewColor;
    _downLineView.backgroundColor = viewColor;
    _headImageView.backgroundColor = viewColor;
    
    _titleLabel.textColor = viewColor;
    _messageLabel.textColor = viewColor;
    _subTitleLabel.textColor = viewColor;
    [_selectBtn setTitleColor:isSelect ? WHITE_COLOR : LIGHTGRAY_COLOR forState:UIControlStateNormal];
    _selectBtn.layer.borderColor = isSelect ? WHITE_COLOR.CGColor : LIGHTGRAY_COLOR.CGColor;
    self.backgroundColor = isSelect ? RED_COLOR : WHITE_COLOR;
}

@end

@implementation RunFlowHeadView

@end

@implementation RunWaitHeadView

@end
