//
//  RegisterViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/27.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RegisterViewController.h"
#import "RealNameViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAOfflineMap.h>


@interface RegisterViewController ()<CLLocationManagerDelegate>
{
    NSString *_type;
    NSString *cityCode;
    NSString *adCode;
}
    @property (weak, nonatomic) IBOutlet UIButton *cityButton;
    @property (weak, nonatomic) IBOutlet UITextField *phoneText;
    @property (weak, nonatomic) IBOutlet UITextField *codeText;
    @property (weak, nonatomic) IBOutlet UITextField *passwordText;
    @property (weak, nonatomic) IBOutlet UIButton *codeButton;
    @property (nonatomic, strong) NSTimer *codeTimer;
    @property (nonatomic, assign) NSInteger codeNum;

@property(nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controllTitleLabel.text = @"用户注册";
    _codeNum = 30;
    [self.popButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    self.passwordText.secureTextEntry = YES;
    _type = @"1";
    [self StartLocationManager];
}
- (IBAction)personAction:(id)sender {
    UIButton *button = sender;
    button.selected = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:11];
    btn.selected = NO;
    _type = @"1";
}
- (IBAction)bossinssAction:(id)sender {
    UIButton *button = sender;
    button.selected = YES;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10];
    btn.selected = NO;
    _type = @"2";
}

- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendCodeAction:(id)sender {
    if (![XLConvertTools isMobileNumber:_phoneText.text]) {
        [self showOnlyText:@"请输入正确的手机号" delay:2 position:PositionCenter];
        return;
    }
    [NetDataRequest userSendCodeWithDic:@{@"mobile":_phoneText.text, @"tplType":@"paonanRegister"} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"验证码已发送至手机" delay:1];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
    }];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceNumAction) userInfo:nil repeats:YES];

}
- (IBAction)registerAction:(id)sender {
    if (_phoneText.text.length < 1 || _codeText.text.length < 1 || _passwordText.text.length < 1) {
        [self showOnleText:@"注册内容不能为空,请核对后再试" delay:2];
        return;
    }
    if (![XLConvertTools isMobileNumber:_phoneText.text]) {
        [self showOnlyText:@"请输入正确的手机号" delay:2 position:PositionCenter];
        return;
    }
    cityCode = @"410100";
    adCode = @"0371";

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:cityCode forKey:@"cityCode"];
    [dic setValue:adCode forKey:@"adCode"];
    [dic setValue:_codeText.text forKey:@"phoneCode"];
    [dic setValue:_phoneText.text forKey:@"mobile"];
    [dic setValue:_passwordText.text forKey:@"password"];
    [dic setValue:_type forKey:@"type"];

    [NetDataRequest userRegisterWithDic:dic success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [XLUserMessage setUserID:resobject[@"data"][@"staff_id"]];
            [self showOnleText:@"注册成功" delay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                RealNameViewController *realnameVC = [[RealNameViewController alloc] init];
                [self presentViewController:realnameVC animated:YES completion:nil];
            });
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
    }];
}
- (void)reduceNumAction {
    _codeButton.userInteractionEnabled = NO;
    _codeNum--;
    if (_codeNum == 0) {
        [_codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        _codeButton.userInteractionEnabled = YES;
        [_codeButton setBackgroundColor:RED_COLOR];
        [_codeTimer invalidate];
        _codeTimer = nil;
        _codeNum = 30;
    }else {
        [_codeButton setTitle:[NSString stringWithFormat:@"%lds重新获取", _codeNum] forState:UIControlStateNormal];
        [_codeButton setBackgroundColor:LIGHTGRAY_COLOR];
    }
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_codeTimer) {
        [_codeTimer invalidate];
        _codeTimer = nil;
    }
}
    
- (void)dealloc {
    [_codeTimer invalidate];
    _codeTimer = nil;
}

//开始定位
-(void)StartLocationManager{
    if([CLLocationManager locationServicesEnabled])
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }else {
        NSLog(@"请开启定位功能！");
    }
}
#pragma mark - CoreLocation Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations firstObject];
    [XLUserMessage setAddressLocationLat:[NSString stringWithFormat:@"%@", @(currentLocation.coordinate.latitude)]];
    [XLUserMessage setAddressLocationLng:[NSString stringWithFormat:@"%@", @(currentLocation.coordinate.longitude)]];
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count) {
            for (CLPlacemark * place in placemarks) {
                NSDictionary * location = [place addressDictionary];
                [_cityButton setTitle:location[@"City"] forState:0];
                NSArray *lineMapArray = [MAOfflineMap sharedOfflineMap].cities;
                for (MAOfflineCity *city in lineMapArray) {
                    if ([city.name isEqualToString:location[@"City"]]) {
                        cityCode = city.cityCode;
                        adCode = city.adcode;
                    }
                }
            }
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
