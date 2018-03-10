//
//  MessageDetailViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/10/11.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "CenterMessageModel.h"

@interface MessageDetailViewController ()<UIScrollViewDelegate>

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviUI];
    [self messageDetailRequestData];
}

- (void)messageDetailRequestData{
    [self showProgressHUD];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setValue:[XLUserMessage getUserID] forKey:@"nid"];
    [userDic setValue:_messageId forKey:@"msg_id"];
    if ([_staff_id isEqualToString:@"0"]) {
        [userDic setValue:@"1" forKey:@"type"];
    }
    [NetDataRequest MessageDetailWithStatus:userDic Success:^(id resobject) {
        [self hidenProgressHUD];
        if ([resobject[@"msgcode"] integerValue] == 0) {
            MessageCenterModel *model = [MessageCenterModel CenterMessageWithDic:resobject[@"data"]];
            [self creatMsgView:model];
        }
    } errors:^(id errors) {
        [self hidenProgressHUD];
        [self showOnleText:@"网络或数据异常" delay:1];
    }];
}

- (void)creatMsgView:(MessageCenterModel *)msgModel{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    UILabel *titleLabel = [UILabel labelWithTitle:msgModel.title fontSize:17 color:BLACK_COLOR alignment:NSTextAlignmentLeft];
    titleLabel.top = titleLabel.left = 15;
    [titleLabel sizeToFit];
    [mainScrollView addSubview:titleLabel];
    
    NSString *timeStr = [XLConvertTools timeSp:msgModel.dateline];
    UILabel *timeLabel = [UILabel labelWithTitle:timeStr fontSize:15 color:GRAY_COLOR alignment:NSTextAlignmentLeft];
    timeLabel.left = titleLabel.left;
    timeLabel.top = titleLabel.bottom + 5;
    [timeLabel sizeToFit];
    [mainScrollView addSubview:timeLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.left, timeLabel.bottom + 10, SCREEN_WIDTH - 30, 1)];
    view.backgroundColor = GRAY_BACKGROUND_COLOR;
    [mainScrollView addSubview:view];
    
    UILabel *contentLabel = [UILabel labelWithTitle:msgModel.content fontSize:15 color:GRAY_COLOR alignment:NSTextAlignmentLeft];
    CGFloat height = [msgModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size.height;
    contentLabel.frame = CGRectMake(titleLabel.left, view.bottom + 10, view.width, height);
    contentLabel.numberOfLines = 0;
    [mainScrollView addSubview:contentLabel];
    
    mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentLabel.bottom + 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNaviUI {
    self.view.backgroundColor = WHITE_COLOR;
    self.controllTitleLabel.text = @"消息详情";
    [self.popButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
