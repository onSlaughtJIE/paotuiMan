//
//  MineMessageGenderView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/7.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "MineMessageGenderView.h"

@implementation MineMessageGenderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self createtableView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(RemoveMessageGenderVIew)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }
    return YES;
}

- (void)RemoveMessageGenderVIew{
    if (_RemoveGenderBlock) {
        _RemoveGenderBlock();
    }
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArray = @[@"男", @"女", @"保密"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    if (![cell viewWithTag:1057]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 44)];
        label.tag = 1057;
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1057];
    label.text = titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArray = @[@"男", @"女", @"保密"];
    if (_changeGenderBlock) {
        _changeGenderBlock(titleArray[indexPath.row]);
    }
}

- (void)createtableView {
    _xltableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 130) style:UITableViewStylePlain];
    _xltableView.center = self.center;
    [self addSubview:_xltableView];
    _xltableView.delegate = self;
    _xltableView.dataSource = self;
    _xltableView.rowHeight = UITableViewAutomaticDimension;
    _xltableView.estimatedRowHeight = 40;
    [_xltableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    _xltableView.scrollEnabled = NO;
    _xltableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
@end
