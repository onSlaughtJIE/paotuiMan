//
//  CenterMessageModel.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/29.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "CenterMessageModel.h"

@implementation CenterMessageModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithPersonMessageWithDic:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+(instancetype)PersonMessageWithDic:(NSDictionary *)dictionary{
    return [[self alloc] initWithPersonMessageWithDic:dictionary];
}

@end

@implementation MessageCenterModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithMessageCenterWithDic:(NSDictionary *)dictionary{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+(instancetype)CenterMessageWithDic:(NSDictionary *)dictionary{
    return [[self alloc] initWithMessageCenterWithDic:dictionary];
}

@end
