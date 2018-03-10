//
//  RealNameView.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/28.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectUploadPhotoDelegate <NSObject>

- (void)selectUploadPhoto:(NSInteger)tapIndex;

@end

@interface RealNameView : UIView
@property(nonatomic, weak) UIImageView *imageView;
@property(nonatomic, weak) UIImageView *photoImageView;
@property(nonatomic, weak) UIImageView *backImageView;
@property(nonatomic, assign) NSInteger selectIndex;

@property(nonatomic, assign) id<selectUploadPhotoDelegate>delegate;

@end
