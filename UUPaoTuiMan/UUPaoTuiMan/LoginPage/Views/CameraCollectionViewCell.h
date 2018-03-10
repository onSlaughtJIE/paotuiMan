//
//  CameraCollectionViewCell.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/28.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
