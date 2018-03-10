//
//  MessageCenterTableViewCell.h
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterMessageModel.h"
@interface MessageCenterTableViewCell : UITableViewCell
@property(nonatomic, strong) MessageCenterModel *model;

+(CGFloat)getCellHeightWithContent:(NSString *)content;
@end
