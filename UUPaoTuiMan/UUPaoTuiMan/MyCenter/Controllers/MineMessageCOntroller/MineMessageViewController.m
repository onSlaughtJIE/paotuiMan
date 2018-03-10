//
//  MineMessageViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/29.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MineMessageViewController.h"
#import "FirstCenterCollectionViewCell.h"
#import "CenterMessageModel.h"
#import "MineCollectionReusableView.h"
#import "AccountViewController.h"
#import "ChangeMessageViewController.h"
#import "MessageCenterViewController.h"
#import "AchieveOrderViewController.h"
#import "ProfitsViewController.h"
#import "MyDepositViewController.h"
#import "ShopStoreViewController.h"
#import "RecommendViewController.h"

@interface MineMessageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *secondArray;
@property(nonatomic, strong) CenterMessageModel *messageModel;
@end

@implementation MineMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    self.controllTitleLabel.text = @"个人中心";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    
    UIButton *keButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keButton.frame = CGRectMake(SCREEN_WIDTH - 40, self.popButton.top, 30, 30);
    [keButton setImage:[UIImage imageNamed:@"ic_kefu"] forState:UIControlStateNormal];
    [keButton addTarget:self action:@selector(goKeFu) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:keButton];
    
}

- (void)goKeFu{
    //联系客服
//    //是否安装QQ
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
//    {
//        //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
//        NSString *QQ = @"1285299969";
//        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }else{
//        [self showOnleText:@"您还未安装QQ" delay:2];
//    }

    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",kCall];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCenterMessageData];
}

- (void)getCenterMessageData{
    [self showProgressHUD];
    [NetDataRequest CenterMessageForMeWithDic:@{@"nid":[XLUserMessage getUserID]} success:^(id resobject) {
        [self hidenProgressHUD];
         if ([[NSString stringWithFormat:@"%@", [resobject objectForKey:@"msgcode"]] isEqualToString:@"0"]) {
            self.messageModel = [CenterMessageModel PersonMessageWithDic:resobject[@"data"]];
        }
        [_collectionView reloadData];
    } errors:^(id errors) {
        [self hidenProgressHUD];
    }];
}

#pragma mark ----------------- UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSArray *imageArray = @[@"Center_Yue",@"ic_quyu_daili", @"Center_Message", @"Center_money", @"Center_shop", @"ic_yaoqing"];
        NSArray *titleArray = @[@"账户余额", @"区域代理", @"消息通知",@"我的押金", @"跑客商城", @"推荐有奖"];
        FirstCenterCollectionViewCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCell" forIndexPath:indexPath];
        cameraCell.titleLabel.text = titleArray[indexPath.row];
        cameraCell.headImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
        if ([_messageModel.unreadyCount integerValue] == 0) {
            cameraCell.jiaoLabel.hidden = YES;
        }else{
            cameraCell.jiaoLabel.hidden = indexPath.row != 1;
            cameraCell.jiaoLabel.text = [NSString stringWithFormat:@"%@", _messageModel.unreadyCount];
        }
        return cameraCell;
    }
    AchievementCollectionViewCell *achievementCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"achievementCell" forIndexPath:indexPath];
    NSArray *secondArray = @[@"完成订单", @"奔跑里程", @"获得收益"];
    achievementCell.titleLabel.text = secondArray[indexPath.row];
    switch (indexPath.section) {
        case 1:
        if (indexPath.row == 0) {
            BOOL isYes = [XLConvertTools isEmptyString:[NSString stringWithFormat:@"%@", _messageModel.todayOrderCount]];
            achievementCell.numberLabel.text = isYes ? @"0" : [NSString stringWithFormat:@"%@",_messageModel.todayOrderCount];
        }else if (indexPath.row == 1){
            BOOL isYes = [XLConvertTools isEmptyString:[NSString stringWithFormat:@"%@",_messageModel.todayMileage]];
            achievementCell.numberLabel.text = isYes ? @"0" : [NSString stringWithFormat:@"%@",_messageModel.todayMoney];
        }else{
            BOOL isYes = [XLConvertTools isEmptyString:[NSString stringWithFormat:@"%@",_messageModel.todayMoney]];
            achievementCell.numberLabel.text = isYes ? @"0" : [NSString stringWithFormat:@"%@",_messageModel.totalMoney];
        }
        break;
        case 2:
        if (indexPath.row == 0) {
            BOOL isYes = [XLConvertTools isEmptyString:[NSString stringWithFormat:@"%@",_messageModel.totalOrderCount]];
            achievementCell.numberLabel.text = isYes ? @"0":[NSString stringWithFormat:@"%@",_messageModel.totalOrderCount];
        }else if (indexPath.row == 1){
            BOOL isYes = [XLConvertTools isEmptyString:[NSString stringWithFormat:@"%@",_messageModel.totalMileage]];
            achievementCell.numberLabel.text = isYes ? @"0":[NSString stringWithFormat:@"%@",_messageModel.totalMileage];
        }else{
            BOOL isYes = [XLConvertTools isEmptyString:[NSString stringWithFormat:@"%@",_messageModel.totalMoney]];
            achievementCell.numberLabel.text = isYes ? @"0":[NSString stringWithFormat:@"%@",_messageModel.totalMoney];
        }
        break;
        default:
        break;
    }

    return achievementCell;
}
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return  3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (!section) {
        return CGSizeMake(SCREEN_WIDTH, 140);
    }
    return CGSizeMake(SCREEN_WIDTH, 30);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section) {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
   return CGSizeMake(SCREEN_WIDTH, 6);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 44);
    }else{
        return CGSizeMake(SCREEN_WIDTH / 3, 80);
    }
}
   
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFootView" forIndexPath:indexPath];
            footView.backgroundColor = backViewColor;
            return footView;
        }else{
            MineCollectionReusableView *mineHeadView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mineHeadView" forIndexPath:indexPath];
            mineHeadView.messageModel = self.messageModel;
            mineHeadView.ChangeHeadImageBlock = ^{
                ChangeMessageViewController *changeVC = [[ChangeMessageViewController alloc] init];
                changeVC.model = self.messageModel;
                [self.navigationController pushViewController:changeVC animated:YES];
            };
            return mineHeadView;
        }
 
    }else{
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeadView" forIndexPath:indexPath];
        if (![headView viewWithTag:731]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headView.width, headView.height)];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = DARKGRAY_COLOR;
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 731;
            [headView addSubview:label];
        }
        UILabel *label = (UILabel *)[headView viewWithTag:731];
        if (indexPath.section == 1) {
            label.text = @"————今日成就————";
        }else{
            label.text = @"————累计成就————";
        }
        return headView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AccountViewController *accountVC = loadViewControllerFromStoryboard(@"AccountViewController", @"AccountVC");
            [self.navigationController pushViewController:accountVC animated:YES];
        }else if (indexPath.row == 1){
            
            
        }else if(indexPath.row == 2){
            MessageCenterViewController *messageVC = [[MessageCenterViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }else if(indexPath.row == 3){
            MyDepositViewController *depositVC = loadViewControllerFromStoryboard(@"MyDepositViewController", @"DepositVC");
            [self.navigationController pushViewController:depositVC animated:YES];
        }else if(indexPath.row == 4){
            ShopStoreViewController *storeVC = [[ShopStoreViewController alloc] init];
            [self.navigationController pushViewController:storeVC animated:YES];
        }else{
            RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
    }else if(indexPath.section == 2 && indexPath.row == 0){
        AchieveOrderViewController *orderVC = [[AchieveOrderViewController alloc] init];
        orderVC.type = @"2";
        [self.navigationController pushViewController:orderVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        AchieveOrderViewController *orderVC = [[AchieveOrderViewController alloc] init];
        orderVC.type = @"1";
        [self.navigationController pushViewController:orderVC animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        ProfitsViewController *profitsVC = [[ProfitsViewController alloc] init];
        profitsVC.type = @"all";
        [self.navigationController pushViewController:profitsVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        ProfitsViewController *profitsVC = [[ProfitsViewController alloc] init];
        profitsVC.type = @"today";
        [self.navigationController pushViewController:profitsVC animated:YES];
    }
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.top = 64;
        _collectionView.height = SCREEN_HEIGHT - 64;
        _collectionView.backgroundColor = CLEAR_COLOR;
        [_collectionView registerNib:[UINib nibWithNibName:@"FirstCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"firstCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"AchievementCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"achievementCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFootView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeadView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"MineCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mineHeadView"];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
