//
//  JXYChatBarMoreViewCell.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/13.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatBarMoreViewCell.h"
#import "JXYChatOtherItemView.h"
#import "JXYUICommon.h"

@interface JXYChatBarMoreViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JXYChatBarMoreViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return self;
}

- (void)setToolDic:(NSDictionary *)toolDic
{
    _toolDic = toolDic;
    [_collectionView reloadData];
}

- (void)setUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setItemSize:CGSizeMake((self.frame.size.width - 35)/4, self.bounds.size.height/2 - 5)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(17.5, 0, self.frame.size.width - 35, self.frame.size.height - 10)  collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    collectionView.dataSource = self;
    [self.contentView addSubview:self.collectionView = collectionView];
    
    [self.collectionView registerClass:[JXYChatOtherItemView class] forCellWithReuseIdentifier:@"JXYChatOtherItemView"];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXYChatOtherItemView *itemView = [collectionView dequeueReusableCellWithReuseIdentifier:@"JXYChatOtherItemView" forIndexPath:indexPath];
    NSDictionary *infoDic = [self.toolDic objectForKey:@(self.sectionNum * 8 + indexPath.item)];
    NSDictionary *imgDic = infoDic.allValues[0];
    itemView.title = infoDic.allKeys[0];
    itemView.icon = [UIImage imageNamed:imgDic.allKeys[0]];
    itemView.passIcon = [UIImage imageNamed:imgDic.allValues[0]];

    return itemView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jxy_selectItemAtItemName:)]) {
        NSDictionary *infoDic = [self.toolDic objectForKey:@(self.sectionNum * 8 + indexPath.item)];
        [self.delegate jxy_selectItemAtItemName:infoDic.allKeys[0]];
    }
}

@end
