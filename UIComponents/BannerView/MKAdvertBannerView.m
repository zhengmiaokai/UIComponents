//
//  MKAdvertBannerView.m
//  Basic
//
//  Created by zhengmiaokai on 2020/2/12.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import "MKAdvertBannerView.h"
#import "MKCollectionViewLayout.h"
#import <MKUtils/UIColor+Addition.h>
#import <MKUtils/UIView+Addition.h>
#import <MKUtils/NSArray+Additions.h>

@interface LCAdVertBannderCell : UICollectionViewCell

@property (nonatomic, strong) UIView <MKAdVertBannderProtocol>* adContentView;

@end

@implementation LCAdVertBannderCell

- (void)setAdContentView:(UIView <MKAdVertBannderProtocol> *)adContentView{
    _adContentView = adContentView;
    
    adContentView.frame = self.contentView.bounds;
    [self.contentView addSubview:adContentView];
}

@end

@interface MKAdvertBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger _nums;
    NSInteger _lastX;
    NSInteger _dragIndex;
}
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) MKCollectionViewLayout* flowLayout;

@end

@implementation MKAdvertBannerView

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self invalidateTimer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        
        self.minLineSpace = 15;
        self.itemWidth = frame.size.width - 60;
        
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - Getter -
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        MKCollectionViewLayout* layout = [[MKCollectionViewLayout alloc] init];
        layout.isZoom = NO;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = self.minLineSpace;
        CGFloat inset = self.frame.size.width - self.minLineSpace - self.itemWidth;
        layout.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
        layout.itemSize = CGSizeMake(self.itemWidth,  self.frame.size.height);
        self.flowLayout = layout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,  self.frame.size.height) collectionViewLayout:layout];
        _collectionView.layer.masksToBounds = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[LCAdVertBannderCell class] forCellWithReuseIdentifier:@"LCAdvertBannerViewCell"];
    }
    return _collectionView;
}

- (void)setIsZoom:(BOOL)isZoom {
    self.flowLayout.isZoom = isZoom;
}

#pragma mark - Setter -
- (void)setMinLineSpace:(NSInteger)minLineSpace {
    _minLineSpace = minLineSpace;
    _flowLayout.minimumLineSpacing = minLineSpace;
}

- (void)setItemWidth:(NSInteger)itemWidth {
    _itemWidth = itemWidth;
    _flowLayout.itemSize = CGSizeMake(itemWidth, self.frame.size.height);
}

- (void)setDatas:(NSArray *)datas {
    _datas = [datas copy];
    _nums = datas.count * (_repeats?100000:1);
    
    [self.collectionView reloadData];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetBannerItemPosition];
        
        if (self.autoScroll) {
            [self setupTimer];
        }
    });
}

#pragma mark - Action -
- (void)resetBannerItemPosition {
    if(self.collectionView.contentOffset.x == 0 && _nums > 0) {
        NSInteger targeIndex = _repeats?(_nums * 0.5):0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targeIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _lastX = self.collectionView.contentOffset.x;
        self.collectionView.userInteractionEnabled = YES;
    }
}

- (void)setupTimer {
    [self invalidateTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/// 自动滚动
- (void)automaticScroll {
    if(_nums == 0) return;
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

/// 当前位置
- (NSInteger)currentIndex {
    if(self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) return 0;
    NSInteger index = (self.collectionView.contentOffset.x + (self.itemWidth + self.minLineSpace) * 0.5) / (self.minLineSpace + self.itemWidth);
    return MAX(0,index);
}

/// 滚动到指定位置
- (void)scrollToIndex:(NSInteger)index {
    
    if(index >= _nums){ //滑到最后则调到中间
        index = _nums * 0.5;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDelegate -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _nums;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LCAdVertBannderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LCAdvertBannerViewCell" forIndexPath:indexPath];
    
    NSInteger index = indexPath.item % _datas.count;
    
    if (!cell.adContentView) {
        if (_dataSource && [_dataSource respondsToSelector:@selector(advertBannerContentViewWithFrame:)]) {
           cell.adContentView =  [_dataSource advertBannerContentViewWithFrame:cell.bounds];
        }
    }
    
    if (cell.adContentView) [cell.adContentView refreshUIWithData:[_datas safeObjectAtIndex:index]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item % _datas.count;
    if (_delegate && [_delegate respondsToSelector:@selector(advertBannerSelectedIndex:)]) {
        [_delegate advertBannerSelectedIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /// 滑动时关闭交互
    self.collectionView.userInteractionEnabled = NO;
    
    if (!self.datas.count) return;

    if (_delegate && [_delegate respondsToSelector:@selector(advertBannerScrollToIndex:)]) {
        NSInteger index = [self currentIndex] % self.datas.count;
        [_delegate advertBannerScrollToIndex:index];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastX = scrollView.contentOffset.x;
    if (!_autoScroll) return;
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!_autoScroll) return;
    [self setupTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.collectionView.userInteractionEnabled = YES;
    
    if (!self.datas.count) return;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat currentX = scrollView.contentOffset.x;
    CGFloat moveWidth = currentX - _lastX;
    NSInteger shouldPage = moveWidth / (self.itemWidth*.5);
    if (velocity.x > 0 || shouldPage > 0) {
        _dragIndex = 1;
    }else if (velocity.x < 0 || shouldPage < 0){
        _dragIndex = -1;
    }else{
        _dragIndex = 0;
    }
    self.collectionView.userInteractionEnabled = NO;
    NSInteger idx = (_lastX + (self.itemWidth + self.minLineSpace) * 0.5) / (self.minLineSpace + self.itemWidth);
    NSInteger scrollIndex = idx + _dragIndex;
    if (scrollIndex < 0) scrollIndex = 0;
    if (scrollIndex >= _nums) scrollIndex = _nums - 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSInteger idx = (_lastX + (self.itemWidth + self.minLineSpace) * 0.5) / (self.minLineSpace + self.itemWidth);
    NSInteger scrollIndex = idx + _dragIndex;
    if (scrollIndex < 0) scrollIndex = 0;
    if (scrollIndex >= _nums) scrollIndex = _nums - 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
