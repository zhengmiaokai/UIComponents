//
//  MKZoomScrollView.h
//  Basic
//
//  Created by zhengMK on 2020/3/23.
//  Copyright © 2020 zhengmiaokai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKZoomScrollView : UIView

@property (nonatomic, strong) UIImage* image;

@property (nonatomic, assign) CGRect imageRect;

- (void)showInView:(UIView *)view;

@end
