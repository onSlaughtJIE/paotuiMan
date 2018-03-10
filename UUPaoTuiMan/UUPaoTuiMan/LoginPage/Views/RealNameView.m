//
//  RealNameView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/28.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RealNameView.h"

@implementation RealNameView

- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            self.layer.borderColor = DARKGRAY_COLOR.CGColor;
            self.layer.cornerRadius = 3;
            self.clipsToBounds = YES;
            UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [self addSubview:backImageView];
            _backImageView = backImageView;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width / 2, self.height)];
            [self addSubview:imageView];
            _imageView = imageView;
            
            UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.right, 0, imageView.width, imageView.height)];
            photoImageView.image = [UIImage imageNamed:@""];
            [self addSubview:photoImageView];
            photoImageView.userInteractionEnabled = YES;
            _photoImageView = photoImageView;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoSelectImage)];
            [photoImageView addGestureRecognizer:tap];
        }
        return self;
}
- (void)photoSelectImage{
    if (_delegate && [_delegate respondsToSelector:@selector(selectUploadPhoto:)]) {
        [_delegate selectUploadPhoto:self.selectIndex];
    }
}

@end
