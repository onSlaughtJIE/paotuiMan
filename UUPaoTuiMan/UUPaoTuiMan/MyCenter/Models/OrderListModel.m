//
//  OrderListModel.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)initWithOrderDictionary:(NSDictionary *)dictionary{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+ (instancetype)OrderWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithOrderDictionary:dictionary];
}
@end

@implementation ProfiftsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)initWithProfitsDictionary:(NSDictionary *)dictionary{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+ (instancetype)ProfitsWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithProfitsDictionary:dictionary];
}

@end

@implementation MallListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)initWithMallListDictionary:(NSDictionary *)dictionary{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+ (instancetype)MallListWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithMallListDictionary:dictionary];
}

@end
@implementation MallSellRecordList
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (instancetype)initWithMallRecordListDictionary:(NSDictionary *)dictionary{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
+ (instancetype)MallRecordListWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithMallRecordListDictionary:dictionary];
}

@end
