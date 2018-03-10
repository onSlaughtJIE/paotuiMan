//
//  FirstCenterCollectionViewCell.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/29.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterMessageModel.h"

@interface FirstCenterCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiaoLabel;

@end

@interface AchievementCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

    
@end
