//
//  MKAdvertBannerView.h
//  Basic
//
//  Created by zhengmiaokai on 2020/2/12.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKAdVertBannderProtocol <NSObject>

- (void)refreshUIWithData:(id)Item;

@end

@protocol MKAdvertBannerViewDelegate <NSObject>

- (void)advertBannerSelectedIndex:(NSInteger)index;

- (void)advertBannerScrollToIndex:(NSInteger)index;

@end

@protocol MKAdvertBannerViewDataSource <NSObject>

- (UIView <MKAdVertBannderProtocol>*)advertBannerContentViewWithFrame:(CGRect)frame;

@end

@interface MKAdvertBannerView : UIView

@property (nonatomic, assign) NSInteger itemWidth;

@property (nonatomic, assign) NSInteger minLineSpace;

@property (nonatomic, assign) BOOL autoScroll;

@property (nonatomic, assign) BOOL repeats;

@property (nonatomic, copy) NSArray* datas;

@property (nonatomic, assign) BOOL isZoom;

@property (nonatomic, weak) id <MKAdvertBannerViewDataSource> dataSource;

@property (nonatomic, weak) id <MKAdvertBannerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

/* 示例
 - (MKAdvertBannerView *)advertBannerView {
     if (_advertBannerView == nil) {
         _advertBannerView = [[MKAdvertBannerView alloc] initWithFrame:CGRectMake(0, 15, self.width,  100)];
         _advertBannerView.itemWidth = ScreenFullWidth - 40;
         _advertBannerView.minLineSpace = 10;
         _advertBannerView.autoScroll = YES;
         _advertBannerView.repeats = YES;
         _advertBannerView.dataSource = self;
         _advertBannerView.delegate = self;
     }
     return _advertBannerView;
 }
 
 #pragma mark - LCAdvertBannerViewDeleagte -
 - (void)advertBannerSelectedIndex:(NSInteger)index {
     LCStarAdSenceInfoData* item = [_adsenceInfo safeObjectAtIndex:index];
 }

 - (void)advertBannerScrollToIndex:(NSInteger)index {
     _pageControl.currentIndex = index;
 }

 #pragma mark - MKAdvertBannerViewDataSource -
 - (UIView <MKAdVertBannderProtocol>*)advertBannerContentViewWithFrame:(CGRect)frame {
     LCAdBannerContentView* cell = [[LCAdBannerContentView alloc] initWithFrame:frame];
     return (UIView <MKAdVertBannderProtocol> *)cell;
 }
 
 - (void)setAdsenceInfo:(NSArray *)adsenceInfo {
     _adsenceInfo = adsenceInfo;
 
     if (adsenceInfo.count == 1) {
        _pageControl.hidden = YES;
        _advertBannerView.autoScroll = NO;
        _advertBannerView.repeats = NO;
     } else {
        _pageControl.hidden = NO;
        _advertBannerView.autoScroll = YES;
        _advertBannerView.repeats = YES;
             
        _pageControl.pageCount = polymericData.adsenceInfo.count;
        _pageControl.currentIndex = 0;
     }
     _advertBannerView.datas = adsenceInfo;
 }
 
 */

/*
 @interface LCAdBannerContentView ()<MKAdVertBannderProtocol>

 @property (nonatomic, strong) UIImageView* imageView;

 @end

 @implementation LCAdBannerContentView

 - (instancetype)initWithFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
     if (self) {
         UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
         imageView.contentMode = UIViewContentModeScaleAspectFill;
         imageView.layer.cornerRadius = 12;
         imageView.layer.masksToBounds = YES;
         [self addSubview:imageView];
         self.imageView = imageView;
     }
     return self;
 }

 - (void)refreshUIWithData:(LCStarAdSenceInfoData *)item {
     [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.picUrl] placeholderImage:[UIImage imageNamed:KDefaultDetailImage]];
 }

 @end
 */
