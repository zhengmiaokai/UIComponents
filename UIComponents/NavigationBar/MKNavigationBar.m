//
//  MKNavigationBar.m
//  Basic
//
//  Created by zhengmiaokai on 2018/9/27.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "MKNavigationBar.h"
#import "Constant.h"

@interface MKNavigationBar ()

@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic, strong) UIBarButtonItem *rightOhterButton;

@property (nonatomic, strong) UILabel *nameLab;

@end

@implementation MKNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView  {
    self.backgroundColor = [UIColor clearColor];
    self.navigationItem = [[UINavigationItem alloc] init];
    [self pushNavigationItem:_navigationItem animated:NO];
    
    [self setShadowImage:[[UIImage alloc] init]];
    [self setBackgroundImage:[[UIImage imageNamed:@"top_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0.5, 0)] forBarMetrics:UIBarMetricsDefault];
    
    self.nameLab.text = @"";
    self.naviAlpha = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
            view.top = [UIApplication sharedApplication].statusBarFrame.size.height;
        } else if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            view.frame = self.bounds;
        }
    }
    
    [self setNavigationBarAlpha:self.naviAlpha];
}

#pragma mark - 透明度切换 -
- (void)setOffsetY:(CGFloat)offsetY alphaBlock:(void(^)(CGFloat alpha))alphaBlock {
    
    CGFloat alpha = 0;
    if (offsetY > 50) {
        alpha = MIN(1, 1 - ((50 + kNavigationBarHeight - offsetY) / kNavigationBarHeight));
        
        [self setNavigationBarAlpha:alpha];
    } else {
        [self setNavigationBarAlpha:alpha];
    }
    
    self.naviAlpha = alpha;
    if (alphaBlock) {
        alphaBlock(alpha);
    }
    [self setNavigaionBarItemsAlpha:alpha];
}

- (void)setNavigationBarAlpha:(CGFloat)alpha {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] || [view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            /* 未配置top_background，隐藏BarBackground
             view.alpha = alpha;
             */
            view.alpha = 0;
        }
    }
    /* 未配置top_background，设置颜色 */
    self.backgroundColor = [UIColor colorWithHexString:self.backgroundColor.hexString alpha:alpha];
}

/**
 ** 根据alpha值设置right left title的相对颜色值
 **/
- (void)setNavigaionBarItemsAlpha:(CGFloat)alpha {
        UIColor* colorAlpha;
        
        if (alpha > 0) {
            colorAlpha = [UIColor colorWithHexString:@"#ffffff"];
        } else {
            colorAlpha = [UIColor colorWithHexString:@"#222222"];;
        }
        _leftButton.tintColor = colorAlpha;
        _rightButton.tintColor = colorAlpha;
        _rightOhterButton.tintColor = colorAlpha;
        _nameLab.textColor = colorAlpha;
}

- (void)updataNavigationAlpha:(CGFloat)alpha {
    self.naviAlpha = alpha;
    [self setNavigationBarAlpha:alpha];
    [self setNavigaionBarItemsAlpha:alpha];
}

#pragma mark - 元素配置 -
- (void)setTitle:(NSString *)title {
    _nameLab.text = title;
}

- (void)setTitleHidden:(BOOL)hidden {
    _nameLab.hidden = hidden;
}


- (void)setItemsColor:(UIColor *)color {
    _leftButton.tintColor = color;
    _rightButton.tintColor = color;
    _rightOhterButton.tintColor = color;
    _nameLab.textColor = color;
}

- (void)setTitleColor:(UIColor *)color {
    _nameLab.textColor = color;
}

- (void)setTitleView:(UIView*)titleView {
    self.navigationItem.titleView = titleView;
    
    if (_nameLab) {
        [_nameLab removeFromSuperview];
        _nameLab  = nil;
    }
}

- (void)setTitleAlpha:(CGFloat)alpha {
    _nameLab.alpha = alpha;
}

- (void)setRightItemImage:(NSString *)ImageName target:(id)target action:(SEL)action {
    self.rightButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_rightButton setImage:[UIImage imageNamed:ImageName]];
    _rightButton.tintColor = [UIColor colorWithHexString:@"#222222"];
    [_navigationItem setRightBarButtonItem:_rightButton];
}

- (void)setRightItemsImages:(NSArray *)imageNames  target:(id)target action:(SEL)action  ohterAction:(SEL)otherAction{
    self.rightButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_rightButton setImage:[UIImage imageNamed:[NSString stringValue:[imageNames safeObjectAtIndex:0]]]];
    _rightButton.tintColor = [UIColor colorWithHexString:@"#222222"];
    
    self.rightOhterButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:otherAction];
    [_rightOhterButton setImage:[UIImage imageNamed:[NSString stringValue:[imageNames safeObjectAtIndex:1]]]];
    _rightOhterButton.tintColor = [UIColor colorWithHexString:@"#222222"];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    [_navigationItem setRightBarButtonItems:@[_rightButton,_rightOhterButton,spaceItem]];
}

- (void)setRightItem:(NSString *)name target:(id)target action:(SEL)action {
    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:target action:action];
    _rightButton.tintColor = [UIColor colorWithHexString:@"#222222"];
    [_navigationItem setRightBarButtonItem:_rightButton];
}


- (void)setRightItemWithFontOfSize:(UIFont *)font {
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] forState:UIControlStateNormal];
}


- (void)setRightTintColor:(UIColor *)color {
    _rightButton.tintColor = color;
}

- (void)setRightBarButtonItems:(NSArray *)items {
    [_navigationItem setRightBarButtonItems:items];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)item {
    [_navigationItem setRightBarButtonItem:item];
}

- (void)setLeftItem:(NSString *)name target:(id)target action:(SEL)action {
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:name style:UIBarButtonItemStylePlain target:target action:action];
    _leftButton.tintColor = [UIColor colorWithHexString:@"#222222"];
    [_navigationItem setLeftBarButtonItem:_leftButton];
}

- (void)setLeftItemImage:(NSString *)ImageName target:(id)target action:(SEL)action {
    self.leftButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:target action:action];
    [_leftButton setImage:[UIImage imageNamed:ImageName]];
    _leftButton.tintColor = [UIColor colorWithHexString:@"#222222"];
    [_navigationItem setLeftBarButtonItem:_leftButton];
}

- (void)setLeftTintColor:(UIColor *)color {
    _leftButton.tintColor = color;
}

#pragma mark - Getter -
- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight - 44, kScreenWidth - 100, 44)];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont boldSystemFontOfSize:21];
        _nameLab.textColor = [UIColor colorWithHexString:@"#222222"];
        _nameLab.centerX = kScreenWidth * 0.5;
        [self addSubview:_nameLab];
    }
    return _nameLab;
}

@end
