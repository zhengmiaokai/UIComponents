//
//  MKLoadingView.m
//  LeCard
//
//  Created by mikazheng on 2020/4/9.
//  Copyright © 2020 LC. All rights reserved.
//

#import "MKLoadingView.h"
#import <MKUtils/UIColor+Addition.h>
#import <MKUtils/UIView+Addition.h>


@interface MKLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;

@property (nonatomic, strong) UIView* centerView;

@end

@implementation MKLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)layoutSubviews {
    _centerView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)initSubView {
    self.hidden = YES;
    
    self.userInteractionEnabled = YES;
    
    UIView* centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    centerView.layer.cornerRadius = 8;
    centerView.layer.masksToBounds = YES;
    centerView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    centerView.center = CGPointMake(self.width/2, self.height/2);
    [self addSubview:centerView];
    self.centerView = centerView;
    
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:_centerView.bounds];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    indicatorView.transform = transform;
    indicatorView.hidesWhenStopped = YES;
    [_centerView addSubview:indicatorView];
    self.indicatorView = indicatorView;
}

- (void)showLoading:(UIView *)view {
    [view addSubview:self];
    self.hidden = NO;
    [_indicatorView startAnimating];
}

- (void)hideLoading {
    self.hidden = NO;
    [_indicatorView stopAnimating];
    [self removeFromSuperview];
}

+ (void)showInView:(UIView *)view {
    MKLoadingView* loadingView = [[MKLoadingView alloc] initWithFrame:view.bounds];
    [loadingView showLoading:view];
}

+ (void)hideInView:(UIView *)view {
    [view.subviews enumerateObjectsUsingBlock:^(UIView*  _Nonnull subview, NSUInteger index, BOOL * _Nonnull stop) {
        if ([subview isKindOfClass:[self class]]) {
            MKLoadingView* loadingView = (MKLoadingView *)subview;
            [loadingView hideLoading];
        }
    }];
}

@end
