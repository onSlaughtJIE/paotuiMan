//
//  OrderPopViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "OrderPopView.h"

@interface OrderPopView ()
{
    NSTimer *orderTimer;
    NSInteger timerCode;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAddressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddressDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRemarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *startPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *endPhoneBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;

@end

@implementation OrderPopView
- (void)awakeFromNib{
    [super awakeFromNib];
    _codeTextFiled.keyboardType =  UIKeyboardTypePhonePad;
}

- (void)setIsList:(BOOL)isList{
    _phoneLabel.hidden = isList ;
    _startPhoneLabel.hidden = isList;
    _phoneBtn.hidden = isList;
    _endPhoneBtn.hidden = isList;
    _codeTextFiled.hidden = isList;
}

- (void)setCurrentLocation:(CLLocation *)currentLocation{
    _currentLocation = currentLocation;
}

- (void)setListModel:(OrderListModel *)listModel{
    _listModel = listModel;
    _endAddressLabel.text = @"收货地址:";
    _endAddressDetailLabel.text = listModel.addr;
    _startAddressLabel.text = @"发货地址:";
    _startAddressDetailLabel.text = listModel.o_addr;
    NSAttributedString *startPhoneStr = [[NSAttributedString alloc] initWithString:listModel.o_mobile attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName:RED_COLOR, NSUnderlineColorAttributeName:RED_COLOR}];
    [_phoneBtn setAttributedTitle:startPhoneStr forState:UIControlStateNormal];
    NSAttributedString *endPhoneStr = [[NSAttributedString alloc] initWithString:listModel.mobile attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName:RED_COLOR, NSUnderlineColorAttributeName:RED_COLOR}];
    [_endPhoneBtn setAttributedTitle:endPhoneStr forState:UIControlStateNormal];
    if ([listModel.type isEqualToString:@"help"]) {
        _titleLabel.text = @"代帮帮";
        _endAddressLabel.text = @"";
        _endAddressDetailLabel.text = @"";
        _startAddressLabel.text = @"帮帮地址:";
        _startAddressDetailLabel.text = listModel.o_addr;
        _startPhoneLabel.text = @"";
        [_endPhoneBtn setTitle:@"" forState:UIControlStateNormal];
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
        _startPhoneLabel.text = @"";
        [_endPhoneBtn setTitle:@"" forState:UIControlStateNormal];
    }else if ([listModel.type isEqualToString:@"song"]) {
        _titleLabel.text = @"帮我送";
    }
    _userRemarkLabel.text = listModel.intro;
    _moneyLabel.text = [NSString stringWithFormat:@"%@元", listModel.jiesuan_amount];
    double orderDistance = [self distanceBetweenOrderBy:[listModel.lat doubleValue] :[listModel.o_lat doubleValue] :[listModel.lng doubleValue] :[listModel.o_lng doubleValue]];
    _orderDistanceLabel.text = [NSString stringWithFormat:@"订单距离:%.2f公里", orderDistance];
    double Distance = [self distanceBetweenOrderBy:self.currentLocation.coordinate.latitude :[listModel.o_lat doubleValue] :self.currentLocation.coordinate.longitude :[listModel.o_lng doubleValue]];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里", Distance];
}

-(double)distanceBetweenOrderBy:(double) lat1 :(double) lat2 :(double) lng1 :(double) lng2{
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double  distance  = [curLocation distanceFromLocation:otherLocation] / 1000;
    return  distance;
}

- (IBAction)CancelAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(CancelOrderPopView)]) {
        [_delegate CancelOrderPopView];
    }
}

- (IBAction)phoneAction:(id)sender {
    UIButton *button = sender;
    if (button.tag == 8) {
        //收货电话
        NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",_listModel.o_mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }else{
        //发货电话
        NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",_listModel.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
}
- (IBAction)SendCodeAction:(id)sender {
    UITextField *textFiled = sender;
    if (_delegate && [_delegate respondsToSelector:@selector(SendCodeNum:)]) {
        [_delegate SendCodeNum:textFiled.text];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

@end
