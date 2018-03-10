//
//  RealNameViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/28.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "RealNameViewController.h"
#import "RealNameView.h"
#import "CameraViewController.h"

@interface RealNameViewController ()<UIScrollViewDelegate, UITextFieldDelegate, selectUploadPhotoDelegate>
{
    NSString *_gender;
    NSInteger firstBottom;
}
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableDictionary *imageDic;

@end

@implementation RealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 80)];
    scrollView.backgroundColor = WHITE_COLOR;
    scrollView.layer.cornerRadius = 4;
    scrollView.clipsToBounds = YES;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    _gender = @"1";
    [self setNavView];
    [self setViewHead];
}

- (void)setNavView{
    self.controllTitleLabel.text = @"实名认证";
    self.view.backgroundColor = XLColorFromRGB(230, 65, 72, 1);
    [self.popButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setViewHead{
    UILabel *noticeLabel = [UILabel labelWithTitle:@"特别提示:跑客注册的年龄段为18-50之间" fontSize:15 color:XLColorFromRGB(230, 65, 72, 1) alignment:NSTextAlignmentLeft];
    noticeLabel.left = 10;
    noticeLabel.top = 20;
    [noticeLabel sizeToFit];
    [_scrollView addSubview:noticeLabel];
    
    UILabel *oneNoticeLabel = [UILabel labelWithTitle:@"1.完善个人资料,以便于信息审核;" fontSize:17 color:DARKGRAY_COLOR alignment:NSTextAlignmentLeft];
    oneNoticeLabel.left = noticeLabel.left;
    oneNoticeLabel.top = noticeLabel.bottom + 10;
    [oneNoticeLabel sizeToFit];
    [_scrollView addSubview:oneNoticeLabel];
    
    UILabel *twoNoticeLabel = [UILabel labelWithTitle:@"2.认证所需资料不公开给任何组织和个人;" fontSize:17 color:DARKGRAY_COLOR alignment:NSTextAlignmentLeft];
    twoNoticeLabel.left = noticeLabel.left;
    twoNoticeLabel.top = oneNoticeLabel.bottom + 5;
    [twoNoticeLabel sizeToFit];
    [_scrollView addSubview:twoNoticeLabel];
    
    NSMutableAttributedString *noticeStr = [[NSMutableAttributedString alloc] initWithString:@"3.审核通过后信息无法修改,如需帮助请致电客服:400-688-7888"];
    [noticeStr addAttribute:NSForegroundColorAttributeName value:XLColorFromRGB(230, 65, 72, 1) range:NSMakeRange(24,12)];
    UILabel *threeNoticeLabel = [UILabel labelWithTitle:nil fontSize:17 color:DARKGRAY_COLOR alignment:NSTextAlignmentLeft];
    threeNoticeLabel.attributedText = noticeStr;
    threeNoticeLabel.numberOfLines = 0;
    threeNoticeLabel.left = noticeLabel.left;
    threeNoticeLabel.width = _scrollView.width- 20;
    threeNoticeLabel.top = twoNoticeLabel.bottom;
    threeNoticeLabel.height = 50;
    [_scrollView addSubview:threeNoticeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, threeNoticeLabel.bottom + 10, _scrollView.width, 1)];
    lineView.backgroundColor = backViewColor;
    [_scrollView addSubview:lineView];

    NSArray *titleArray = @[@"姓名", @"性别", @"身份证", @"现居地", @"第二联系人", @"从事职业"];
	NSArray *noticeArray = @[@"请输入姓名", @"", @"请输入身份证号码", @"请输入现居地的详细地址", @"请输入联系人手机号", @"请输入您所从事职业"];
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 10 + 40 * i, 60, 20)];
        titleLabel.text = titleArray[i];
        [titleLabel sizeToFit];
        [_scrollView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 10, _scrollView.width, 1)];
        lineView.backgroundColor = backViewColor;
        [_scrollView addSubview:lineView];
        firstBottom = lineView.bottom + 10;
        
        UITextField *textFiled = [[UITextField alloc] init];
        textFiled.delegate = self;
        textFiled.left = titleLabel.right + 15;
        textFiled.top = titleLabel.top - 5;
        textFiled.width = _scrollView.width  - titleLabel.width - 30;
        textFiled.height = 30;
        textFiled.tag = 12 + i;
        if (i == 1) {
            [self setGenderSelect:titleLabel.right + 10 withCenterY:titleLabel.centerY];
        }else{
            textFiled.placeholder = noticeArray[i];
            [_scrollView addSubview:textFiled];
        }
    }
    [self uploadImageView];
}

- (void)uploadImageView{
    NSArray *labelArray = @[@"个人形象照片", @"手持身份证照片", @"身份证正面", @"身份证反面"];
    CGFloat endBottom = 0.0;
    for (int i = 0; i < labelArray.count; i ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,  firstBottom + 160 * i, 60, 20)];
        titleLabel.text = labelArray[i];
        [titleLabel sizeToFit];
        titleLabel.textColor = DARKGRAY_COLOR;
        [_scrollView addSubview:titleLabel];
        
        RealNameView *realView = [[RealNameView alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom + 5, _scrollView.width - 10, 130)];
        if (i != 0) {
            realView.backImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Photo%d", i + 1]];
            realView.imageView.hidden = YES;
        }else{
            realView.imageView.image = [UIImage imageNamed:@"Photo1"];
            realView.photoImageView.image = [UIImage imageNamed:@"Photo5"];
        }
        realView.selectIndex = i;
        realView.photoImageView.tag = 100 + i;
        endBottom = realView.bottom + 5;
        realView.delegate = self;
        [_scrollView  addSubview:realView];
    }
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(30, endBottom + 30, _scrollView.width - 60, 40);
    submitBtn.layer.cornerRadius = 4;
    submitBtn.clipsToBounds = YES;
    [submitBtn setBackgroundColor:[UIColor orangeColor]];
    [submitBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitRealNameMessage) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 40, submitBtn.bottom + 20);
}

- (void)setGenderSelect:(CGFloat)left withCenterY:(CGFloat)centerY{
    NSArray *genderArray = @[@"男", @"女"];
    for (int i = 0; i < 2; i++) {
        UIButton *genderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        genderBtn.frame = CGRectMake(left + 5 + 80 * i, 10, 20, 20);
        genderBtn.centerY = centerY;
        [genderBtn setImage:[UIImage imageNamed:@"UnSelect"] forState:UIControlStateNormal];
        [genderBtn setImage:[UIImage imageNamed:@"genderSelect"] forState:UIControlStateSelected];
        genderBtn.tag = 1 + i;
        [genderBtn addTarget:self action:@selector(genderSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:genderBtn];
        
        UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(genderBtn.right + 5, genderBtn.top, 30, 20)];
        genderLabel.text = genderArray[i];
        [_scrollView addSubview:genderLabel];
        if (i ==0) {
            genderBtn.selected = YES;
        }
    }
}

- (void)genderSelectAction:(UIButton *)button{
    for (int i = 0; i < 2; i++) {
        UIButton *btn = (UIButton *)[[button superview]viewWithTag:1 + i];
        [btn setSelected:NO];
    }
    [button setSelected:YES];
    _gender = button.tag == 1 ? @"1" : @"0";
}

- (void)dismissVC{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectUploadPhoto:(NSInteger)tapIndex{
    UIImageView *selectImageViwe = (UIImageView *)[self.view viewWithTag:100 + tapIndex];
    CameraViewController *cameraVC = [[CameraViewController alloc] init];
    [self presentViewController:cameraVC animated:YES completion:nil];
    cameraVC.selectPhotoImage = ^(UIImage *selectImage) {
        selectImageViwe.image = selectImage;
        if ([self UIImageToBase64Str:selectImage]) {
            [self.imageDic setObject:[self UIImageToBase64Str:selectImage] forKey:[NSString stringWithFormat:@"image%ld", (long)tapIndex + 1]];
        }
    };
}

-(NSString *)UIImageToBase64Str:(UIImage *)image{
    UIImage *imageNew = image;
    //设置image的尺寸
    CGSize imagesize = imageNew.size;
    imagesize.height =626;
    imagesize.width =413;
    //对图片大小进行压缩--
    imageNew = [self imageWithImage:imageNew scaledToSize:imagesize];
    NSData *imageData = UIImageJPEGRepresentation(imageNew,0.01);
    NSString *base64img=[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64img;
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)submitRealNameMessage{
    UITextField *nameText = (UITextField *)[_scrollView viewWithTag:12];
    UITextField *IDText = (UITextField *)[_scrollView viewWithTag:14];
    UITextField *AddressText = (UITextField *)[_scrollView viewWithTag:15];
    UITextField *phoneText = (UITextField *)[_scrollView viewWithTag:16];
    UITextField *jobText = (UITextField *)[_scrollView viewWithTag:17];
    if ([XLConvertTools isEmptyString:nameText.text]) {
        [self showOnleText:@"姓名不能为空" delay:1];
        return;
    }
    if (![XLConvertTools isMobileNumber:phoneText.text]) {
        [self showOnleText:@"请输入正确手机号码" delay:1];
        return;
    }
    if (![XLConvertTools isValidateIdentityCard:IDText.text]) {
        [self showOnleText:@"请输入正确的身份证号码" delay:1];
        return;
    }
    if ([XLConvertTools isEmptyString:AddressText.text] || [XLConvertTools isEmptyString:jobText.text]) {
        [self showOnleText:@"实名认证信息不能为空" delay:1];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [dic setValue:nameText.text forKey:@"real_name"];
    [dic setValue:IDText.text forKey:@"id_number"];
    [dic setValue:AddressText.text forKey:@"now_address"];
    [dic setValue:phoneText.text forKey:@"second_mobile"];
    [dic setValue:jobText.text forKey:@"job"];
    [dic setValue:_gender forKey:@"sex"];
    [dic setValue:self.imageDic[@"image1"] forKey:@"id_photo"];
    [dic setValue:self.imageDic[@"image2"] forKey:@"person_card_pic"];
    [dic setValue:self.imageDic[@"image3"] forKey:@"font_card_pic"];
    [dic setValue:self.imageDic[@"image4"] forKey:@"reverse_card_pic"];
    
    [self showProgressHUD];
    [NetDataRequest UserRealNameWithDic:dic success:^(id resobject) {
        [self hidenProgressHUD];
        if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            [self showOnleText:@"提交成功,请耐心等待审核" delay:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.presentingViewController.presentingViewController.view = 0;
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [self hidenProgressHUD];
            [self showOnleText:resobject[@"msg"] delay:1];
        }
    } errors:^(id errors) {
        NSLog(@"%@", errors);
    }];
}

- (NSMutableDictionary *)imageDic{
    if (!_imageDic) {
        _imageDic = [NSMutableDictionary dictionary];
    }
    return _imageDic;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
