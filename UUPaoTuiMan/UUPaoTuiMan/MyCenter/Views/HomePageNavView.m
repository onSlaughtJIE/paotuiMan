//
//  HomePageNavView.m
//  UUPaoTuiMan
//
//  Created by qianyuan on 2017/8/8.
//  Copyright © 2017年 qianyuan. All rights reserved.
//

#import "HomePageNavView.h"
#import <UIImageView+AFNetworking.h>

@interface HomePageNavView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation HomePageNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = NavBarColor;
        self.titleArray = @[@"实时", @"列表", @"待完成"];
        [self addSubview:self.collectionView];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    for (int i = 0; i < _titleArray.count; i++) {
        UICollectionViewCell *MallCell = (UICollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UILabel *label = (UILabel *)[MallCell viewWithTag:12];
        UIView *lineView = (UIView *)[MallCell viewWithTag:2];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self updateCellStatus:label withLineView:lineView selected:i == index];
    }
}

#pragma mark -------------- UICollectionVIewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *MallCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MallCell" forIndexPath:indexPath];
    if (![MallCell viewWithTag:12]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MallCell.width - 2, MallCell.height - 5)];
        label.tag = 12;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [MallCell addSubview:label];
        label.textColor = WHITE_COLOR;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom + 2, label.width - 20, 2)];
        lineView.tag = 2;
        lineView.backgroundColor = MallCell.selected ? WHITE_COLOR : CLEAR_COLOR;
        [MallCell addSubview:lineView];
    }
    UILabel *label = (UILabel *)[MallCell viewWithTag:12];
    label.text = self.titleArray[indexPath.row];

    return MallCell;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.titleArray.count > 4) {
        return CGSizeMake(self.width / 5, 30);
    }
    return CGSizeMake(self.width /self.titleArray.count, 30);
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *MallCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[MallCell viewWithTag:12];
    UIView *lineView = (UIView *)[MallCell viewWithTag:2];
    
    [self updateCellStatus:label withLineView:lineView selected:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(HomePageSelectType:)]) {
        [self.delegate HomePageSelectType:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *MallCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[MallCell viewWithTag:12];
    UIView *lineView = (UIView *)[MallCell viewWithTag:2];
    
    [self updateCellStatus:label withLineView:lineView selected:NO];
}

-(void)updateCellStatus:(UILabel *)label withLineView:(UIView *)view selected:(BOOL)selected
{
//    label.textColor =selected ?  ORANGE_COLOR: GRAY_COLOR;
//    view.backgroundColor = selected ? ORANGE_COLOR : CLEAR_COLOR;
    view.backgroundColor = selected ? WHITE_COLOR : CLEAR_COLOR;
}

#pragma mark -------------- LazyLoading
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayout];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MallCell"];
    }
    return _collectionView;
}

@end

@implementation RealTimeFootView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage)];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView addGestureRecognizer:tap];
}

- (void)changeHeadImage{
    if (_ChangeHeadImageBlock) {
        _ChangeHeadImageBlock();
    }
}

- (void)setMessageModel:(CenterMessageModel *)messageModel{
    _todayOrderLabel.text = [NSString stringWithFormat:@"%@单", messageModel.todayOrderCount];
    _todayMoneyLabel.text = [NSString stringWithFormat:@"%@元", messageModel.todayMoney];
    [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_API,messageModel.face]] placeholderImage:[UIImage imageNamed:@"MineHead"]];
}

@end
