//
//  RunFlowTableViewCell.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RunFlowSelectButtonDelegate <NSObject>

- (void)RunFlowSelectWith:(NSInteger)indexPatch;

@end
@interface RunFlowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *downLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property(nonatomic, assign) NSInteger indexPatch;
- (void)setSelectIndexWithSelect:(BOOL)isSelect;

@property(nonatomic, assign) id<RunFlowSelectButtonDelegate>delegate;
@end

@interface RunFlowHeadView : UIView

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *firstLineView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *secondLineView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@interface RunWaitHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@end
