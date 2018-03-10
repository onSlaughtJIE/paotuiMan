//
//  MySetViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/29.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MySetViewController.h"
#import <Masonry.h>
#import "XLUpdatePhoneViewController.h"
#import "XLAboutViewController.h"
#import "CacheManager.h"
#import "BankAccountViewController.h"
#import "ViewController.h"
#import "OpinionViewController.h"

@interface MySetViewController ()<UITableViewDelegate, UITableViewDataSource>
    
@property (nonatomic, strong) UITableView *xltableView;
@property (nonatomic, strong) NSArray *sourceArray;

@end

@implementation MySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sourceArray = @[@"修改密码", @"提现账户", @"申请解约", @"关于我们",@"意见反馈", @"清除缓存"];
    self.controllTitleLabel.text = @"设置";
    [self.popButton addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = WHITE_COLOR;
    [self createtableView];
}

- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_xltableView];
    [_xltableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.view);
        make.top.offset(64);
    }];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 44;
    [_xltableView setLayoutMargins:UIEdgeInsetsZero];
    _xltableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    _xltableView.tableFooterView = footerView;
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:loginOutBtn];
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footerView);
        make.height.offset(34);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setBackgroundColor:RED_COLOR];
    loginOutBtn.layer.cornerRadius = 4;
    [loginOutBtn addTarget:self action:@selector(loginoutAction:) forControlEvents:UIControlEventTouchUpInside];
}
    
- (void)loginoutAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [XLUserMessage loginOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
        ViewController *loginVC = loadViewControllerFromStoryboard(@"Main", @"LoginVC");
        [self.navigationController pushViewController:loginVC animated:YES];
    });
}
    
#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [_sourceArray objectAtIndex:indexPath.row];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 5) {
        if (![cell viewWithTag:1839]) {
            UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.width - 30, 15, 80, 20)];
            clearLabel.textColor = DARKGRAY_COLOR;
            clearLabel.font = [UIFont systemFontOfSize:15];
            clearLabel.textAlignment = NSTextAlignmentLeft;
            clearLabel.tag = 1839;
            [cell addSubview:clearLabel];
        }
        UILabel *clearLabel = (UILabel *)[cell viewWithTag:1839];
        double cache = [[CacheManager defaultCacheManager] GetCacheSize];
        clearLabel.text = [NSString stringWithFormat:@"%.2fM", cache];
        clearLabel.left = SCREEN_WIDTH - clearLabel.width - 10;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = backViewColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            XLUpdatePhoneViewController *vc = [[UIStoryboard storyboardWithName:@"XLOpinionController" bundle:nil] instantiateViewControllerWithIdentifier:@"updatePassword"];
            vc.titleStr = [_sourceArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
        case 2:
            [self setApplyForEnd];
        break;
        case 3:
        {
            XLAboutViewController *vc = [[UIStoryboard storyboardWithName:@"XLOpinionController" bundle:nil] instantiateViewControllerWithIdentifier:@"aboutVC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        break;
        case 1:
        {
            BankAccountViewController *bankVC = [[BankAccountViewController alloc] init];
            [self.navigationController pushViewController:bankVC animated:YES];
        }
        break;
        case 4:
        {
            OpinionViewController *opinionVC = [[UIStoryboard storyboardWithName:@"XLOpinionController" bundle:nil] instantiateViewControllerWithIdentifier:@"OpinionVC"];
            [self.navigationController pushViewController:opinionVC animated:YES];
        }
            break;
        case 5:
        {
            CacheManager * cachemanager=[CacheManager defaultCacheManager];
            [cachemanager clearCache:^(BOOL success)
             {
                 [_xltableView reloadData];
                 [self showOnleText:@"清理缓存成功" delay:1];
             }];
        }
            break;
    
        default:
        break;
    }
}
    
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setApplyForEnd{
    UIAlertController *AlertC = [UIAlertController alertControllerWithTitle:nil message:@"确定申请解约?" preferredStyle:UIAlertControllerStyleAlert];
    [AlertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [AlertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入您的登录密码";
    }];
    [AlertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *TextField = AlertC.textFields.firstObject;
        if ([XLConvertTools isEmptyString:TextField.text]) {
            [self showOnleText:TextField.placeholder delay:1];
            return;
        }
        [self showProgressHUD];
        [NetDataRequest ApplyForendWithLoginPassword:TextField.text success:^(id resobject) {
            [self hidenProgressHUD];
            if ([[NSString stringWithFormat:@"%@", resobject[@"msgcode"]] isEqualToString:@"0"]) {
                [self showOnleText:@"申请解约成功" delay:1];
                [XLUserMessage setUserLogin:NO];
                [XLUserMessage loginOut];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ViewController *loginVC = loadViewControllerFromStoryboard(@"Main", @"LoginVC");
                    [self.navigationController pushViewController:loginVC animated:YES];
                });
            }else{
                [self showOnleText:resobject[@"msg"] delay:1];
            }
        } errors:^(id errors) {
            [self hidenProgressHUD];
        }];
        
    }]];
    
    [self presentViewController:AlertC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
