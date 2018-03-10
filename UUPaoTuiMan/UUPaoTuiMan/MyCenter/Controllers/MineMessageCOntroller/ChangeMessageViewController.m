//
//  ChangeMessageViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "ChangeMessageViewController.h"
#import "HeadIconTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "CameraViewController.h"
#import "MineMessageGenderView.h"

@interface ChangeMessageViewController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *xltableView;
@property(nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation ChangeMessageViewController
{
    NSString *iconImage;//选择的头像(base64)
    NSString *gender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self supviewCusNavi];
    [self setNaviUI];
    [self createtableView];
}

- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_xltableView];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView registerClass:[HeadIconTableViewCell class] forCellReuseIdentifier:@"HeadIconTableViewCell"];
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        HeadIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadIconTableViewCell" forIndexPath:indexPath];
        [cell.iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API, _model.face]] placeholderImage:[UIImage imageNamed:@"icon_mine_ren"]];
        cell.iconImage.tag = 1324;
        return cell;
    }
    NSArray *titleArray = @[@"编号", @"信用分", @"性别", @"手机号"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    cell.textLabel.text = titleArray[indexPath.row - 1];
    if (![cell viewWithTag:1057]) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = 1057;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1057];
    label.text = self.titleArray[indexPath.row - 1];
    label.tag = 1057 + indexPath.row;
    [label sizeToFit];
    label.centerY = cell.centerY;
    label.left = tableView.width - label.width - 15;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            //头像
            UIActionSheet*sheet;
            sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
            [sheet showInView:self.view];
        }
            break;
            case 3:
        {
            MineMessageGenderView *genderView = [[MineMessageGenderView alloc] initWithFrame:self.view.frame];
            genderView.tag = 1459;
            [self.view.window addSubview:genderView];
            genderView.RemoveGenderBlock = ^{
                [[self.view.window viewWithTag:1459] removeFromSuperview];
            };
            genderView.changeGenderBlock = ^(NSString *selectGender) {
                if ([selectGender isEqualToString:@"男"]) {
                    gender = @"1";
                }else if ([selectGender isEqualToString:@"女"]){
                    gender = @"2";
                }else{
                    gender = @"3";
                }
                [[self.view.window viewWithTag:1459] removeFromSuperview];
                [self saveIconAction];
            };
        }
            break;
        default:
            break;
    }
}

#pragma 触发事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (buttonIndex) {
            case 2:
                // 取消
                return;
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
                
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        switch (buttonIndex) {
            case 2:
                // 取消
                return;
            case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                [self showOnleText:@"相机权限未打开" delay:1.5];
                return;
                break;
                
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                break;
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //相册中被点击图片
    UIImage * selectImage = [info objectForKeyedSubscript:UIImagePickerControllerEditedImage];
    //转化成nsdata类型
    NSData * data = UIImageJPEGRepresentation(selectImage,0.5f);
    NSString * encodeString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    iconImage = encodeString;
    [self saveIconAction];
    UIImageView *iconView = [self.view viewWithTag:1324];
    iconView.image = selectImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveIconAction{
    [self showProgressHUD];
    [NetDataRequest UpdateUserNameWithGender:gender icon:iconImage success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:[resobject  objectForKey:@"msg"] delay:1];
            UILabel *label = (UILabel *)[self.view viewWithTag:1060];
            if ([gender isEqualToString:@"2"]) {
                label.text= @"女";
            }else if ([gender isEqualToString:@"1"]){
                label.text= @"男";
            }else{
                label.text= @"保密";
                [label sizeToFit];
            }
            //重新获取个人信息
            [self updateUserMsg];
        } else {
            [self showOnleText:[resobject  objectForKey:@"msg"] delay:1];
        }
    } errors:^(id errors) {
        [self showOnleText:@"网络异常,请稍后再试" delay:1];
        [self hidenProgressHUD];
    }];
}
- (void)updateUserMsg {
    [NetDataRequest CenterMessageForMeWithDic:@{@"nid":[XLUserMessage getUserID]} success:^(id resobject) {
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            NSDictionary *dataDic = [resobject objectForKey:@"data"];
            [XLUserMessage setUserID:[dataDic objectForKey:@"staff_id"]];
            [XLUserMessage setUserIcon:[dataDic objectForKey:@"face"]];
            [XLUserMessage setUserName:[dataDic objectForKey:@"name"]];
            [XLUserMessage setUserMoney:[dataDic objectForKey:@"money"]];
            [XLUserMessage setUserPhone:[dataDic objectForKey:@"mobile"]];
            [XLUserMessage setUserLogin:YES];
        }else{
            [self showOnleText:resobject[@"msg"] delay:1];
        }
        
    } errors:^(id errors) {
        
    }];
}

- (void)setNaviUI {
    self.controllTitleLabel.text = @"个人信息";
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray new];
        [_titleArray addObject:self.model.id_number];
        [_titleArray addObject:self.model.credit_score];
        if ([self.model.sex isEqualToString:@"1"]) {
            [_titleArray addObject:@"男"];
        }else if([self.model.sex isEqualToString:@"2"]){
            [_titleArray addObject:@"女"];
        }else{
            [_titleArray addObject:@"保密"];
        }
        gender = self.model.sex;
        [_titleArray addObject:self.model.mobile];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
