//
//  AchieveListTableViewCell.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "AchieveListTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
@interface AchieveListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRemarkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressWidth;
@property (weak, nonatomic) IBOutlet UILabel *orderTImeLabel;

@end

@implementation AchieveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)CheckOrderAction:(id)sender {
    if (_checkOrderDetailBlock) {
        _checkOrderDetailBlock();
    }
}

- (void)setCurrentLocation:(CLLocation *)currentLocation{
    _currentLocation = currentLocation;
}

- (void)setListModel:(OrderListModel *)listModel{
    _listModel = listModel;
    _endAddressLabel.text = @"收";
    _endAddressDetailLabel.text = listModel.addr;
    _startAddressLabel.text = @"发";
    _startAddressDetailLabel.text = listModel.o_addr;
    if ([listModel.type isEqualToString:@"help"]) {
        _titleLabel.text = @"代帮帮";
        _endAddressLabel.text = @"";
        _endAddressDetailLabel.text = @"";
        _startAddressLabel.text = @"帮帮地址:";
        _startAddressDetailLabel.text = listModel.o_addr;
        _addressWidth.constant = 70;
    }else if ([listModel.type isEqualToString:@"paotui"]){
        _titleLabel.text = @"帮我取";
    }else if ([listModel.type isEqualToString:@"buy"]){
        _titleLabel.text = @"帮我买";
    }else if ([listModel.type isEqualToString:@"queue"]){
        _titleLabel.text = @"代排队";
        _endAddressLabel.text = @"";
        _endAddressDetailLabel.text = @"";
        _startAddressLabel.text = @"排队地址:";
        _startAddressDetailLabel.text = listModel.o_addr;
        _addressWidth.constant = 70;
    }else if ([listModel.type isEqualToString:@"song"]) {
        _titleLabel.text = @"帮我送";
    }
    _userRemarkLabel.text = listModel.intro;
    _moneyLabel.text = [NSString stringWithFormat:@"%@元", listModel.jiesuan_amount];
    double Distance = [self distanceBetweenOrderBy:_currentLocation.coordinate.latitude :[listModel.o_lat doubleValue] :_currentLocation.coordinate.longitude :[listModel.o_lng doubleValue]];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里", Distance];
    _orderTImeLabel.text = [NSString stringWithFormat:@"下单时间:%@",  [XLConvertTools timeSp:listModel.dateline]];
}

-(CLLocationDistance)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    CLLocationDistance kilometers=[curLocation distanceFromLocation:otherLocation]/1000;
    return  kilometers;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
