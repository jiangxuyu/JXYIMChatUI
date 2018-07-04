//
//  JXYChatBarMoreView.m
//  JXYChatDemo
//
//  Created by longmaster39 on 2017/7/13.
//  Copyright © 2017年 longmaster39. All rights reserved.
//

#import "JXYChatBarMoreView.h"
#import "JXYChatBarMoreViewCell.h"
#import "JXYUICommon.h"

@interface JXYChatBarMoreView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, JXYChatBarMoreViewCellDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JXYChatBarMoreView
{
    NSDictionary *_toolDic;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self setPageCollectionView:frame];
    }
    return self;
}

- (void)setPageCollectionView:(CGRect)frame
{
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [flowLayout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, frame.size.height)];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[JXYChatBarMoreViewCell class] forCellWithReuseIdentifier:@"JXYChatBarMoreViewCell"];
}

- (void)setToolDic:(NSDictionary *)toolDic
{
    _toolDic = toolDic;
    self.itemCount = (int)toolDic.count;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.itemCount % 8 == 0) {
        return self.itemCount / 8;
    } else if (self.itemCount % 8 > 0) {
        return self.itemCount / 8 + 1;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JXYChatBarMoreViewCell *itemView = [collectionView dequeueReusableCellWithReuseIdentifier:@"JXYChatBarMoreViewCell" forIndexPath:indexPath];
    itemView.delegate = self;
    if (self.itemCount >= 8 * (indexPath.row + 1)) {
        itemView.itemCount = 8;
    } else {
        itemView.itemCount = (int)(self.itemCount - 8 * (indexPath.row));
    }
    itemView.sectionNum = indexPath.row;
    itemView.toolDic = _toolDic;
    return itemView;
}

#pragma mark - JXYChatBarMoreViewCellDelegate
- (void)jxy_selectItemAtItemName:(NSString *)itemName
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jxy_selectItemAtItemName:)]) {
        [self.delegate jxy_selectItemAtItemName:itemName];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.numberOfPages = [self.collectionView numberOfItemsInSection:indexPath.section];
    self.pageControl.currentPage = indexPath.item;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    self.pageControl.numberOfPages = [self.collectionView numberOfItemsInSection:indexPath.section];
    self.pageControl.currentPage = indexPath.row;
}

@end
