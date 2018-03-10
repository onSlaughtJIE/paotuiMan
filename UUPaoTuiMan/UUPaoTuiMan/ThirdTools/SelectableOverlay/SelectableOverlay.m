//
//  SelectableOverlay.m
//  officialDemo2D
//
//  Created by yi chen on 14-5-8.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import "SelectableOverlay.h"

@implementation SelectableOverlay

#pragma mark - MAOverlay Protocol

- (CLLocationCoordinate2D)coordinate
{
    return [self.overlay coordinate];
}

- (MAMapRect)boundingMapRect
{
    return [self.overlay boundingMapRect];
}

#pragma mark - Life Cycle

- (id)initWithOverlay:(id<MAOverlay>)overlay
{
    self = [super init];
    if (self)
    {
        self.overlay       = overlay;
        self.selected      = NO;
        self.selectedColor = [UIColor colorWithRed:56 / 255 green:160 / 255 blue:250 / 255  alpha:1];
        self.regularColor  = [[UIColor blueColor] colorWithAlphaComponent:0.7];
    }
    return self;
}

@end
