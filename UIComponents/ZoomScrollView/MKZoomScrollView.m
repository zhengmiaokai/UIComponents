//
//  MKZoomScrollView.m
//  Basic
//
//  Created by zhengMK on 2020/3/23.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import "MKZoomScrollView.h"
#import "Constant.h"

@interface MKZoomScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView* imageView;

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, assign) CGRect orginRect;

@end

@implementation MKZoomScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScale:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClose:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        _imageView.image = image;
        
        [_scrollView setZoomScale:1 animated:NO];
        
        self.orginRect = CGRectMake(0, 0, self.width, self.width / image.size.width * image.size.height);
        
        [self resetFrame:_orginRect];
    }
}

- (void)closeWithFrame:(CGRect)rect {
    _scrollView.frame = rect;
    _imageView.frame = _scrollView.bounds;
}

- (void)resetFrame:(CGRect)rect {
    _scrollView.frame = rect;
    _scrollView.center = CGPointMake(self.width/2, self.height/2);
    _imageView.frame = _scrollView.bounds;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    [self closeWithFrame:_imageRect];
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
    [UIView animateWithDuration:0.25 animations:^{
        [self resetFrame:self.orginRect];
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    }];
}

- (void)touchClose:(UITapGestureRecognizer *)gesture {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
        [self closeWithFrame:self.imageRect];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchScale:(UIGestureRecognizer *)gesture {
    CGFloat zoomScale = _scrollView.zoomScale;
    zoomScale = (zoomScale == 1.0) ? 2.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = self.imageView.frame.size.height/scale;
    zoomRect.size.width  = self.imageView.frame.size.width/scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width/2);
    zoomRect.origin.y = center.y - (zoomRect.size.height/2);
    return zoomRect;
}

#pragma mark -- UIScrollViewDelegate --
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale <= 1) {
        _imageView.center = CGPointMake(scrollView.width/2, scrollView.height/2);
    }
}

@end
