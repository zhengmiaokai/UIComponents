//
//  MKPageControl.h
//  Basic
//
//  Created by mikazheng on 2020/2/18.
//  Copyright © 2020 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPageControl : UIView

@property (nonatomic, assign) NSInteger marginLeft;
@property (nonatomic, assign) NSInteger marginRight;
@property (nonatomic, assign) NSInteger spacing;

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame hImageName:(NSString *)hImageName lImageName:(NSString *)nImageName;

@end

NS_ASSUME_NONNULL_END

/*
 MKPageControl* pageControl = [[MKPageControl alloc] initWithFrame:CGRectZero hImageName:@"novice_guide_bannerr_light" lImageName:@"novice_guide_bannerr_dis"];
 pageControl.spacing = 3;
 pageControl.pageCount = 3;
 pageControl.currentIndex = 0;
 pageControl.top = 100;
 [self addSubview:pageControl];
 */
