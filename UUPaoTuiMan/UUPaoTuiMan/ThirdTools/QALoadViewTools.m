//
//  QALoadViewTools.m
//  QianAiMall
//
//  Created by qianyuan on 2017/6/21.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "QALoadViewTools.h"

@implementation QALoadViewTools

id loadViewFromXibWithName(NSString *xibName,id owner)
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:xibName owner:owner options:nil];
    
    for (NSObject *objec in objects) {
        if ([objec isKindOfClass:[UIView class]]) {
            return objec;
        }
    }
    return nil;
}

id loadViewControllerFromStoryboard(NSString *name,NSString *identifier)
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *vc = nil;
    
    if (identifier == nil)
    {
        vc = [storyboard instantiateInitialViewController];
    }
    else
    {
        vc = [storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }
    return nil;
}

@end
