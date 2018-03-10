//
//  OrderListModel.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject

@property(nonatomic, copy) NSString *addr;
@property(nonatomic, copy) NSString *clientip;
@property(nonatomic, copy) NSString *contact;
@property(nonatomic, copy) NSString *danbao_amount;
@property(nonatomic, copy) NSString *dateline;
@property(nonatomic, copy) NSString *day;
@property(nonatomic, copy) NSString *goods_cost;
@property(nonatomic, copy) NSString *house;
@property(nonatomic, copy) NSString *intro;
@property(nonatomic, copy) NSString *jiesuan_amount;
@property(nonatomic, copy) NSString *lat;
@property(nonatomic, copy) NSString *lng;
@property(nonatomic, copy) NSString *mile_count;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *o_addr;
@property(nonatomic, copy) NSString *o_contact;
@property(nonatomic, copy) NSString *o_house;
@property(nonatomic, copy) NSString *o_lat;
@property(nonatomic, copy) NSString *o_lng;
@property(nonatomic, copy) NSString *o_mobile;
@property(nonatomic, copy) NSString *o_time;
@property(nonatomic, copy) NSString *order_num;
@property(nonatomic, copy) NSString *order_status;
@property(nonatomic, copy) NSString *p_mobile;
@property(nonatomic, copy) NSString *voice_time;
@property(nonatomic, copy) NSString *voice;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *staff_id;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *pay_type;
@property(nonatomic, copy) NSString *pay_time;
@property(nonatomic, copy) NSString *pay_status;
@property(nonatomic, copy) NSString *pay_ip;
@property(nonatomic, copy) NSString *pay_code;
@property(nonatomic, copy) NSString *paotui_id;
@property(nonatomic, copy) NSString *paotui_amount;
@property(nonatomic, copy) NSString *order_type;
@property(nonatomic, copy) NSString *codeNum;
@property(nonatomic, copy) NSString *queue_time;
@property(nonatomic, copy) NSString *finish_time;
@property(nonatomic, copy) NSString *add_price;
@property(nonatomic, copy) NSString *cat_type;
@property(nonatomic, copy) NSString *p_name;
@property(nonatomic, copy) NSString *process_step;
@property(nonatomic, copy) NSString *queue_end_time;
@property(nonatomic, copy) NSString *queue_start_time;
@property(nonatomic, copy) NSString *goods_img;

- (instancetype)initWithOrderDictionary:(NSDictionary *)dictionary;
+ (instancetype)OrderWithDictionary:(NSDictionary *)dictionary;

@end

@interface ProfiftsModel : NSObject
@property(nonatomic, copy) NSString *log_id;
@property(nonatomic, copy) NSString *staff_id;
@property(nonatomic, copy) NSString *money;
@property(nonatomic, copy) NSString *intro;
@property(nonatomic, copy) NSString *admin;
@property(nonatomic, copy) NSString *day;
@property(nonatomic, copy) NSString *clientip;
@property(nonatomic, copy) NSString *dateline;
@property(nonatomic, copy) NSString *type;

- (instancetype)initWithProfitsDictionary:(NSDictionary *)dictionary;
+ (instancetype)ProfitsWithDictionary:(NSDictionary *)dictionary;
@end

@interface MallListModel : NSObject
@property(nonatomic, copy) NSString *cate_id;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *photo;
@property(nonatomic, copy) NSString *shop_id;
@property(nonatomic, copy) NSString *product_id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *sales;

- (instancetype)initWithMallListDictionary:(NSDictionary *)dictionary;
+ (instancetype)MallListWithDictionary:(NSDictionary *)dictionary;

@end

@interface MallSellRecordList : NSObject
@property(nonatomic, copy) NSString *count_price;
@property(nonatomic, copy) NSString *create_time;
@property(nonatomic, copy) NSString *product_num;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *title;

- (instancetype)initWithMallRecordListDictionary:(NSDictionary *)dictionary;
+ (instancetype)MallRecordListWithDictionary:(NSDictionary *)dictionary;
@end
