//
//  LCPageControl.m
//  Basic
//
//  Created by mikazheng on 2020/2/18.
//  Copyright © 2020 LC. All rights reserved.
//

#import "MKPageControl.h"

#import <MKUtils/UIColor+Addition.h>
#import <MKUtils/UIView+Addition.h>

#define LCPageControlTag 168

@interface MKPageControl ()

@property (nonatomic, strong) UIImage* hightImage;
@property (nonatomic, strong) UIImage* lightImage;

@end

@implementation MKPageControl

- (instancetype)initWithFrame:(CGRect)frame hImageName:(NSString *)hImageName lImageName:(NSString *)nImageName {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        self.spacing = 4;
        self.hightImage = [UIImage imageNamed:hImageName];
        self.lightImage = [UIImage imageNamed:nImageName];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview) {
        if (_marginLeft) {
            self.left = _marginLeft;
        } else if (_marginRight) {
            self.right = self.superview.width - _marginRight;
        } else {
            self.centerX = self.superview.width/2;
        }
    }
}

- (void)setPageCount:(NSInteger)pageCount {
    _pageCount = pageCount;
    
    for (UIView* subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat orginX = 0;
    CGFloat viewHeight = 0;
    for (int i=0; i<pageCount; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.tag = LCPageControlTag + i;
        if (_currentIndex == i) {
            imageView.image = _hightImage;
            imageView.frame = CGRectMake(orginX, 0, _hightImage.size.width, _hightImage.size.height);
            viewHeight = imageView.image.size.height;
        } else {
            imageView.image = _lightImage;
            imageView.frame = CGRectMake(orginX, 0, _lightImage.size.width,_lightImage.size.height);
        }
        [self addSubview:imageView];
        orginX = imageView.right + _spacing;
    }
    self.width = orginX - _spacing;
    self.height = viewHeight;
    
    [self setNeedsDisplay];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (_currentIndex == currentIndex) {
        // 防止频繁赋值
        return;
    }
    _currentIndex = currentIndex;
    
    CGFloat orginX = 0;
    for (int i=0; i<_pageCount; i++) {
        UIImageView* imageView = [self viewWithTag:LCPageControlTag + i];
        if (_currentIndex == i) {
            imageView.image = _hightImage;
            imageView.frame = CGRectMake(orginX, 0, _hightImage.size.width, _hightImage.size.height);
        } else {
            imageView.image = _lightImage;
            imageView.frame = CGRectMake(orginX, 0, _lightImage.size.width, _lightImage.size.height);
        }
        orginX = imageView.right + _spacing;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
