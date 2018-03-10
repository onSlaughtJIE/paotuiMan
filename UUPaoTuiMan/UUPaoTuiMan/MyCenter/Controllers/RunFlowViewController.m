//
//  RunFlowViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/9.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RunFlowViewController.h"
#import "RunFlowTableViewCell.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CoreLocation.h>
#import "RunFLowPictureViewController.h"

@interface RunFlowViewController ()<UITableViewDelegate, UITableViewDataSource, RunFlowSelectButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    RunFlowHeadView *headView;
    NSInteger indexSelect;
    NSString *imageString;
}
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titleArray;

@end

@implementation RunFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self supviewCusNavi];
    [self setNavView];
    [self.view addSubview:self.tableView];
    indexSelect = [_listModel.process_step integerValue];
    [self getFirstSelectCell];
}

- (void)getFirstSelectCell{
    NSInteger selectIndex;
    if (indexSelect < 4) {
        _titleArray = @[@[@"致电发货人(第一步)", @"请先致电发货人确认地址和时间", @"", @"联系发货人"], @[@"我已到达(第二步)", @"到达取货地点后点击", @"\"我已到达\"", @"我已到达"],@[@"拍照(第三步)", @"为了避免货物纠纷", @"请在取货的时候拍照存证", @"去拍照"], @[@"我已取货(第四步)", @"取货后点击", @"\"我已取货\"", @"我已取货"]];
        selectIndex = indexSelect;
    }else{
        [self setSecondHeadView];
        selectIndex = indexSelect - 4;
    }
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)setNavView{
    self.controllTitleLabel.text = _contentTitle;
    self.view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    headView = [[NSBundle mainBundle] loadNibNamed:@"RunFlowHeadView" owner:nil options:nil].firstObject;
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140);
    headView.addressLabel.text = _listModel.o_addr;
    self.tableView.tableHeaderView = headView;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    backView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:backView];
    
    UIButton *daoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    daoBtn.size = CGSizeMake(100, 30);
    daoBtn.right = backView.width - 10;
    daoBtn.top = 10;
    daoBtn.layer.borderColor = RED_COLOR.CGColor;
    daoBtn.layer.borderWidth = 1;
    daoBtn.layer.cornerRadius = 5;
    daoBtn.clipsToBounds = YES;
    [daoBtn setTitle:@"查看导航" forState:UIControlStateNormal];
    [daoBtn setTitleColor:RED_COLOR forState:UIControlStateNormal];
    [daoBtn addTarget:self action:@selector(daoHangAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:daoBtn];
    
    UIButton *keButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keButton.frame = CGRectMake(SCREEN_WIDTH - 70, self.popButton.top, 60, 30);
    if (_listModel.goods_img) {
//        [keButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [keButton addTarget:self action:@selector(goLookPicture) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [keButton setTitleColor:GRAY_COLOR forState:UIControlStateNormal];
    }
    [keButton setTitle:@"查看图片" forState:UIControlStateNormal];
    keButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.naviView addSubview:keButton];
    
}

- (void)goLookPicture{
    RunFLowPictureViewController *pictureVC = [[RunFLowPictureViewController alloc] init];
    pictureVC.imageUrl = _listModel.goods_img;
    [self.navigationController pushViewController:pictureVC animated:YES];
}

- (void)backAction:(UIButton *)button{
    if (_RunFlowAchieveBlock && imageString) {
        _RunFlowAchieveBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)daoHangAction:(UIButton *)button{
    //导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        //地理编码器
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //设定一个终点坐标
        [geocoder geocodeAddressString:headView.addressLabel.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *placemark in placemarks){
                //坐标（经纬度)
                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"UUPaoTuiMan",@"demoURL://",coordinate.latitude, coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }];
    }else{
        [self showOnleText:@"您的iPhone未安装高德地图" delay:1];
    }
    
}

#pragma mark ------------------- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RunFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RunFlowTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.delegate = self;
    cell.indexPatch = indexPath.row;
    NSArray *array = _titleArray[indexPath.row];
    cell.titleLabel.text = array.lastObject;
    cell.subTitleLabel.text = array[1];
    cell.messageLabel.text = array[2];
    [cell.selectBtn setTitle:array.lastObject forState:UIControlStateNormal];
    cell.selectBtn.userInteractionEnabled = YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RunFlowTableViewCell *cell = (RunFlowTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self getFirstSelectCell];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 115) style:UITableViewStyleGrouped];
        _tableView.delegate = self; 
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"RunFlowTableViewCell" bundle:nil] forCellReuseIdentifier:@"RunFlowTableViewCell"];
    }
    return _tableView;
}

#pragma mark ------------- RunFlowSelectDelegate
- (void)RunFlowSelectWith:(NSInteger)indexPatch{
    RunFlowTableViewCell *cell = (RunFlowTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPatch inSection:0]];
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"验证码"]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请输入收货人的验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *codeTextField = alertC.textFields.lastObject;
            if ([XLConvertTools isEmptyString:codeTextField.text]) {
                [self showOnleText:@"请输入下单用户的验证码" delay:1];
                return;
            }
            [NetDataRequest AchievePaoNanOrderWithOrderId:_listModel.paotui_id CodeNum:codeTextField.text success:^(id resobject) {
                if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
                    [self getFlowRequestData:@"TelephoneConsigner"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (_RunFlowAchieveBlock) {
                            _RunFlowAchieveBlock(YES);
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    });
                }else{
                    [self showOnleText:resobject[@"msg"] delay:1];
                }
                
            } errors:^(id errors) {
                [self showOnleText:@"网络或数据异常" delay:1];
            }];
        }]];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入验证码";
        }];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"联系发货人"]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"打电话给发货人?" message:_listModel.o_mobile preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self getFlowRequestData:@"TelephoneConsigner"];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_listModel.o_mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            [self getFlowRequestData:@"TelephoneConsigner"];
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"我已到达"]) {
        cell.selectBtn.tag = 1810;
        if (!cell.selectBtn.userInteractionEnabled) {
            return;
        }
        [self getFlowRequestData:@"ArriveConsignmentPlace"];
    }
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"去拍照"]) {
        cell.selectBtn.tag = 1811;
        if (!cell.selectBtn.userInteractionEnabled) {
            return;
        }
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"我已取货"]) {
        cell.selectBtn.tag = 1812;
        if (!cell.selectBtn.userInteractionEnabled) {
            return;
        }
      [self getFlowRequestData:@"AlreadyPickup"];
    }
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"联系收货人"]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"打电话给收货人?" message:_listModel.mobile preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self getFlowRequestData:@"TelephoneReceive"];
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_listModel.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            [self getFlowRequestData:@"TelephoneReceive"];
        }]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    if ([cell.selectBtn.titleLabel.text isEqualToString:@"我已送达"]) {
        cell.selectBtn.tag = 1814;
        if (!cell.selectBtn.userInteractionEnabled) {
            return;
        }
        [self getFlowRequestData:@"ArraiveReceivingPlace"];
    }
}

- (void)getSelectCellWithIndex:(NSInteger)indexPatch{
    RunFlowTableViewCell *cell = (RunFlowTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPatch inSection:0]];
    if (!cell.selected) {
    
        return;
    }
    
    if (indexPatch == _titleArray.count - 1) {
        [self setSecondHeadView];
        [_tableView reloadData];
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

    }else{
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:++indexPatch inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}
//开始跑男流程
- (void)getFlowRequestData:(NSString *)type{
    NSDictionary *typeDic = @{@"TelephoneConsigner":@"0",@"ArriveConsignmentPlace":@"1",@"TakePicture":@"2",@"AlreadyPickup":@"3",@"TelephoneReceive":@"4",@"ArraiveReceivingPlace":@"5"};
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:type forKey:@"stepType"];
    [dic setValue:_listModel.paotui_id forKey:@"orderId"];
    [dic setValue:imageString forKey:@"goodsImg"];
    [NetDataRequest OrderFlowWithStatus:dic Success:^(id resobject) {
        if ([resobject[@"msgcode"] integerValue] == 0) {
            NSInteger index = [[typeDic objectForKey:type] integerValue];
            UIButton *selectBtn = (UIButton *)[self.view viewWithTag:1809 + index];
            selectBtn.userInteractionEnabled = NO;
            indexSelect = index;
            if (index > 3) {
                index = index - 4;
            }
            [self getSelectCellWithIndex: index];
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络或数据异常" delay:1];
    }];
}

- (void)setSecondHeadView{
    _titleArray = @[@[@"致电收货人(第五步)", @"请先致电收货人确认地址和时间", @"", @"联系收货人"], @[@"我已送达(第六步)", @"到达收货地点后点击", @"\"我已送达\"", @"我已送达"], @[@"输入验证码(第七步)", @"请向收货人要去", @"短信验证码", @"验证码"]];
    headView.firstLineView.backgroundColor = RED_COLOR;
    headView.secondView.backgroundColor = RED_COLOR;
    headView.secondLineView.backgroundColor = RED_COLOR;
    headView.addressLabel.text = _listModel.addr;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //相册中被点击图片
    UIImage * selectImage = [info objectForKeyedSubscript:UIImagePickerControllerEditedImage];
    //转化成nsdata类型
    NSData * data = UIImageJPEGRepresentation(selectImage,0.5f);
    NSString * encodeString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    imageString = encodeString;
    [self getFlowRequestData:@"TakePicture"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
