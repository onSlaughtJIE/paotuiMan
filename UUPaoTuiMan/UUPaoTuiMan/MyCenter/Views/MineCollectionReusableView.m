//
//  MineCollectionReusableView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/31.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MineCollectionReusableView.h"
#import "UIImageView+AFNetworking.h"
@interface MineCollectionReusableView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinLabel;

@end

@implementation MineCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage)];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addGestureRecognizer:tap];
}

- (void)changeHeadImage{
    if (_ChangeHeadImageBlock) {
        _ChangeHeadImageBlock();
    }
}

- (void)setMessageModel:(CenterMessageModel *)messageModel{
    [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API,messageModel.face]] placeholderImage:[UIImage imageNamed:@"MineHead"]];
    _numLabel.text = [NSString stringWithFormat:@"编号:%@", messageModel.id_number];
    _ScoreLabel.text = [NSString stringWithFormat:@"信用分:%@", messageModel.credit_score];
    _joinLabel.text = [NSString stringWithFormat:@"[我的邀请码]:%@", messageModel.invitation_code];
}

@end
