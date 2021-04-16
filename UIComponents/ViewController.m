//
//  ViewController.m
//  UIComponents
//
//  Created by mikazheng on 2021/4/13.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import <MKUtils/MarcoConstant.h>
#import <MKUtils/UIView+Addition.h>
#import <MKUtils/UIColor+Addition.h>
#import <MKUtils/NSArray+Additions.h>
#import <MKUtils/UIScreen+Addition.h>

#import "MKAdvertBannerView.h"
#import "MKPageControl.h"
#import "MKZoomScrollView.h"
#import "MKEffectTipView.h"
#import "MKLoadingView.h"
#import "MKNavigationBar.h"

@interface MKAdBannerContentView : UIView <MKAdVertBannderProtocol>

@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation MKAdBannerContentView

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

- (void)refreshUIWithData:(NSString *)imgUrl {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
}

@end


@interface ViewController () <MKAdvertBannerViewDelegate, MKAdvertBannerViewDataSource>

@property (nonatomic, strong) MKNavigationBar* navigationBar;

@property (nonatomic, strong) MKAdvertBannerView* advertBannerView;

@property (nonatomic, strong) MKPageControl* pageControl;

@property (nonatomic, strong) UIImageView* bigImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    MKNavigationBar* navigationBar = [[MKNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
    navigationBar.backgroundColor = [UIColor colorWithHexString:@"#52d0c6"];
    [navigationBar setTitle:@"首页"];
    [navigationBar setRightItem:@"浮窗" target:self action:@selector(showFloatView:)];
    [self.view addSubview:navigationBar];
    self.navigationBar = navigationBar;
    
    [self.view addSubview:self.advertBannerView];
    [self.view addSubview:self.pageControl];
    
    _pageControl.centerX = _advertBannerView.centerX;
    _pageControl.top = _advertBannerView.bottom + 10;
    
    NSArray* datas = @[@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20191119%2F19%2F1574164281-gkiSIwOmVM.jpg&refer=http%3A%2F%2Fimage.biaobaiju.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1620895914&t=33710159e2a5fc563c1eebf72e52919a", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20191119%2F19%2F1574164281-gkiSIwOmVM.jpg&refer=http%3A%2F%2Fimage.biaobaiju.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1620895914&t=33710159e2a5fc563c1eebf72e52919a", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20191119%2F19%2F1574164281-gkiSIwOmVM.jpg&refer=http%3A%2F%2Fimage.biaobaiju.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1620895914&t=33710159e2a5fc563c1eebf72e52919a", @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20191119%2F19%2F1574164281-gkiSIwOmVM.jpg&refer=http%3A%2F%2Fimage.biaobaiju.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1620895914&t=33710159e2a5fc563c1eebf72e52919a"];
    
    [self setAdsenceInfo:datas];
    _pageControl.pageCount = datas.count;
    _pageControl.currentIndex = 0;
    
    
    UIImageView* bigImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, _pageControl.bottom + 80, kScreenWidth - 140, 150)];
    bigImage.contentMode = UIViewContentModeScaleAspectFill;
    bigImage.layer.masksToBounds = YES;
    [bigImage sd_setImageWithURL:[NSURL URLWithString:[datas safeObjectAtIndex:0]]];
    [bigImage addTarget:self action:@selector(showBigPicture:)];
    [self.view addSubview:bigImage];
    self.bigImage = bigImage;
    
    
    [MKLoadingView showInView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MKLoadingView hideInView:self.view];
        [MKEffectTipView showWithduration:1 inView:self.view finish:^{
            
        }];
    });
}

- (void)showFloatView:(id)sender {
    [MKEffectTipView showWithduration:1 inView:self.view finish:^{
        
    }];
}

#pragma mark - Getter -
- (MKAdvertBannerView *)advertBannerView {
    if (_advertBannerView == nil) {
        _advertBannerView = [[MKAdvertBannerView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + 20, kScreenWidth,  150)];
        _advertBannerView.itemWidth = kScreenWidth - 60;
        _advertBannerView.minLineSpace = -20;
        _advertBannerView.isZoom = YES;
        _advertBannerView.autoScroll = YES;
        _advertBannerView.repeats = YES;
        _advertBannerView.dataSource = self;
        _advertBannerView.delegate = self;
    }
    return _advertBannerView;
}

- (MKPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[MKPageControl alloc] initWithFrame:CGRectZero hImageName:@"novice_guide_bannerr_light" lImageName:@"novice_guide_bannerr_dis"];
        _pageControl.spacing = 4;
    }
    return _pageControl;
}
#pragma mark - Action -
- (void)showBigPicture:(UITapGestureRecognizer *)tap {
    MKZoomScrollView* zoomView = [[MKZoomScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    zoomView.image = _bigImage.image;
    zoomView.imageRect = _bigImage.frame;
    [zoomView showInView:self.view];
}

#pragma mark - LCAdvertBannerViewDeleagte -
- (void)advertBannerSelectedIndex:(NSInteger)index {
    
}

- (void)advertBannerScrollToIndex:(NSInteger)index {
    if (index == 1 || index == 2) {
        [UIView animateWithDuration:1 animations:^{
            [self.navigationBar updataNavigationAlpha:1];
        }];
    } else {
        [UIView animateWithDuration:1 animations:^{
            [self.navigationBar updataNavigationAlpha:0];
        }];
    }
    _pageControl.currentIndex = index;
}

#pragma mark - MKAdvertBannerViewDataSource -
- (UIView <MKAdVertBannderProtocol>*)advertBannerContentViewWithFrame:(CGRect)frame {
    MKAdBannerContentView* cell = [[MKAdBannerContentView alloc] initWithFrame:frame];
    return (UIView <MKAdVertBannderProtocol> *)cell;
}

- (void)setAdsenceInfo:(NSArray *)adsenceInfo {
    _advertBannerView.datas = adsenceInfo;
}

@end
