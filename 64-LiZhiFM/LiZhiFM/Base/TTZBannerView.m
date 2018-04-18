//
//  WAMHomeHeaderView.m
//  LoveSex
//
//  Created by memory on 16/5/16.
//  Copyright © 2016年 czljcb. All rights reserved.
//

#import "TTZBannerView.h"

#import <Masonry/Masonry.h>
#import <UIImageView+WebCache.h>
#import "common.h"

#define kPageControlBottomMargin 5
#define kLargeNumber 10000
#define kWidth (self.frame.size.width)

// 轮播图时间间隔
#define kInterval 3.0


@interface TTZBannerCell ()


@end

@implementation TTZBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageV];
        self.iconView = imageV;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.right.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

@end


@interface TTZBannerView ()
<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView *iconCollectionView;

@property(nonatomic, strong)UIPageControl *pageVC;

@property(nonatomic, strong)UILabel *nameLB;

@property(nonatomic, strong)NSTimer *timer;

@property(nonatomic, assign)NSInteger numberOfSections;

@end

@implementation TTZBannerView

#pragma mark - view life circle  viewController生命周期方法

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - custom methods  自定义方法

- (void)setup{
    [self addSubview:self.iconCollectionView];
    [self addSubview:self.pageVC];
    [self addSubview:self.nameLB];
    
    [self.pageVC mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self);
        make.right.equalTo(self).offset(-2*kPageControlBottomMargin);
        make.bottom.equalTo(self).offset(kPageControlBottomMargin);
    }];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2*kPageControlBottomMargin);
        make.centerY.equalTo(self.pageVC);
        make.right.equalTo(self.pageVC.mas_left).offset(2*kPageControlBottomMargin);
    }];
    
    
    if (self.models == nil) {
        return;
    }
    
    if (self.models.count == 1) {
        self.iconCollectionView.scrollEnabled = NO;
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:kLargeNumber * 0.5];
    [self.iconCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self setTimer];
}

- (void)setTimer{
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:kInterval target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer{
    NSInteger index = self.iconCollectionView.contentOffset.x / kWidth;
    CGFloat offsetX = (index + 1 ) *kWidth;
    [self.iconCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - sources and delegates 代理、协议方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.pageVC.numberOfPages == 0) {
        return;
    }
    CGFloat offset =  self.iconCollectionView.contentOffset.x - kLargeNumber * kWidth;
    NSInteger index = (offset + 0.5 * kWidth) / kWidth;
    
    self.pageVC.currentPage = index % self.pageVC.numberOfPages;
    self.nameLB.text = [self.models[self.pageVC.currentPage] name];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.models.count == 1) {
        self.iconCollectionView.scrollEnabled = NO;
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.models.count == 1) {
        self.iconCollectionView.scrollEnabled = NO;
        return;
    }
    [self setTimer];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.models.count == 0) {
        return 1;
    }
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.models.count == 0) {
        TTZBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTZBannerCell" forIndexPath:indexPath];
        cell.iconView.image = nil;
        return cell;
    }
    TTZBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TTZBannerCell" forIndexPath:indexPath];
    NSString *imageName = (NSString *)[self.models[indexPath.item] icon];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectItemAtIndexPath) {
        self.selectItemAtIndexPath(self.models[indexPath.item]);
    }
}

#pragma mark - getters and setters 属性的设置和获取方法

- (UICollectionView *)iconCollectionView{
    if (_iconCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.frame.size;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _iconCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _iconCollectionView.showsHorizontalScrollIndicator = NO;
        _iconCollectionView.pagingEnabled = YES;
        _iconCollectionView.dataSource = self;
        _iconCollectionView.delegate = self;
        [_iconCollectionView registerClass:[TTZBannerCell class] forCellWithReuseIdentifier:@"TTZBannerCell"];
    }
    return _iconCollectionView;
}

- (UIPageControl *)pageVC{
    if (_pageVC == nil) {
        _pageVC = [[UIPageControl alloc] init];
        //_pageVC.backgroundColor = [UIColor orangeColor];
        //_pageVC.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageVC.currentPageIndicatorTintColor = kCommonColor;
        _pageVC.pageIndicatorTintColor = kBackgroundColor;
        
    }
    return _pageVC;
}

- (UILabel *)nameLB{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor whiteColor];
        _nameLB.font = [UIFont systemFontOfSize:12.0];
    }
    return _nameLB;
}

-(void)setModels:(NSArray *)models{
    _models = models;
    self.pageVC.numberOfPages = models.count;
    [self.iconCollectionView reloadData];
    
    if (models == nil) {
        self.numberOfSections = 1;
        return;
    }
    if (models.count == 0) {
        self.numberOfSections = 1;
        return;
    }
    
    self.numberOfSections = kLargeNumber;
    
    /**
     *  一张图片不滚动
     */
    if (self.models.count == 1){
        self.iconCollectionView.scrollEnabled = NO;
        self.nameLB.text = [models.firstObject name];
        self.pageVC.hidden = YES;
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:kLargeNumber * 0.5];
    [self.iconCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    
    self.pageVC.hidden = NO;
    self.iconCollectionView.scrollEnabled = YES;
    [self setTimer];
}


@end
