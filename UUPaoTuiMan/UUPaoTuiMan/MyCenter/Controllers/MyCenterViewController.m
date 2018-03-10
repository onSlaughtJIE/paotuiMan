//
//  MyCenterViewController.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/7/29.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MyCenterViewController.h"
#import "MineMessageViewController.h"
#import "MySetViewController.h"
#import "HomePageNavView.h"
#import "RealTimeViewController.h"
#import "HomeListViewController.h"

@interface MyCenterViewController ()<HomePageTypeDelegate, UIScrollViewDelegate>
@property(nonatomic, weak) UIScrollView *mianScrollView;
@property(nonatomic, weak) HomePageNavView *homeView;
@end

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavView];
    [self setScrollView];
}

- (void)setScrollView{
    UIScrollView *mianScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    mianScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - 64);
    mianScrollView.showsHorizontalScrollIndicator = NO;
    mianScrollView.pagingEnabled = YES;
    mianScrollView.delegate = self;
    [self.view addSubview:mianScrollView];
    _mianScrollView = mianScrollView;
    
    RealTimeViewController *timeVC = [[RealTimeViewController alloc] init];
    [self addChildViewController:timeVC];
    timeVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [mianScrollView addSubview:timeVC.view];
    
}

- (void)HomePageSelectType:(NSInteger)PriceType{
    [_mianScrollView setContentOffset:CGPointMake(PriceType * SCREEN_WIDTH, 0) animated:NO];
    if (PriceType > 0) {
        [[_mianScrollView viewWithTag:1719] removeFromSuperview];
        [[_mianScrollView viewWithTag:1718] removeFromSuperview];
        HomeListViewController *unListVC = [[HomeListViewController alloc] init];
        unListVC.orderStatus = [NSString stringWithFormat:@"%@", @(PriceType + 1)];
        unListVC.view.frame = CGRectMake(SCREEN_WIDTH * PriceType, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        unListVC.view.tag = 1717 + PriceType;
        [self addChildViewController:unListVC];
        [_mianScrollView addSubview:unListVC.view];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger n = scrollView.contentOffset.x / scrollView.frame.size.width;
    _homeView.index = n;
    [self HomePageSelectType:n];
}

- (void)setNavView{
    self.controllTitleLabel.hidden = YES;
    self.view.backgroundColor = WHITE_COLOR;
    [self.popButton setImage:[UIImage imageNamed:@"MyCenter_Mine"] forState:UIControlStateNormal];
    [self.popButton addTarget:self action:@selector(MyCenterVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(SCREEN_WIDTH - 40, self.popButton.top, 30, 30);
    [sureButton setImage:[UIImage imageNamed:@"MyCenter_Set"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(SetMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:sureButton];
    
    HomePageNavView *homeView = [[HomePageNavView alloc] initWithFrame:CGRectMake(self.popButton.right + 15, self.popButton.top, SCREEN_WIDTH - 140, self.naviView.height - self.popButton.top)];
    homeView.delegate = self;
    homeView.centerX = self.naviView.centerX;
    [self.naviView addSubview:homeView];
    _homeView = homeView;
}

- (void)MyCenterVC{
    MineMessageViewController *mineVC = [[MineMessageViewController alloc] init];
    [self.navigationController pushViewController:mineVC animated:YES];
}

- (void)SetMessage{
    MySetViewController *setVC = [[MySetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
