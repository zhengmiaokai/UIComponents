//
//  MKActionSheetView.m
//  UIComponents
//
//  Created by mikazheng on 2021/7/24.
//

#import "MKActionSheetView.h"
#import "MKConstant.h"
#import <MKUtils/UIView+Addition.h>
#import <MKUtils/MarcoConstant.h>

#define kActionSheetButtonTag 168

@interface MKActionSheetView ()

@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, weak) id <MKActionSheetViewDelegate> delegate;
@property (nonatomic, copy) NSString* cancelTitle;
@property (nonatomic, copy) NSArray* buttonTitles;

@end

@implementation MKActionSheetView

- (instancetype)initWithDelegate:(id <MKActionSheetViewDelegate>)delegate cancelTitle:(NSString *)cancelTitle buttonTitles:(NSArray *)buttonTitles {
    self = [super initWithFrame:kScreenBounds];
    if (self) {
        self.delegate = delegate;
        self.cancelTitle = cancelTitle;
        self.buttonTitles = buttonTitles;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = UIColorWithRGBA(0x000000, 0.6);
    [self addTarget:self action:@selector(onCancelTitleAction:)];
    
    CGFloat bottomHeight = ((1+_buttonTitles.count) * UIScalePixel(56)) + (3 * UIScalePixel(7));
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - bottomHeight - IPHONEX_BOTTOM, UIScalePixel(375), bottomHeight)];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView* buttonView = [[UIView alloc] initWithFrame:CGRectMake(UIScalePixel(12), UIScalePixel(7), UIScalePixel(351), UIScalePixel(56) * _buttonTitles.count)];
    buttonView.backgroundColor = UIColorWithRGB(0xFFFFFF);
    buttonView.layer.cornerRadius = 4;
    [bottomView addSubview:buttonView];
    
    for (int i=0; i<_buttonTitles.count; i++) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*UIScalePixel(56), buttonView.width, UIScalePixel(56))];
        button.tag = i + kActionSheetButtonTag;
        button.titleLabel.font = UIScaleFont(18);
        [button setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButtonTitleAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:button];
        
        if (i>0) {
            UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(UIScalePixel(12), i * UIScalePixel(56) - 0.5, UIScalePixel(327), 0.5)];
            lineView.backgroundColor = UIColorWithRGBA(0x000000, 0.08);
            [buttonView addSubview:lineView];
        }
    }
    
    UIButton* cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(UIScalePixel(12), buttonView.bottom + UIScalePixel(7), buttonView.width, UIScalePixel(56))];
    cancelbtn.backgroundColor = UIColorWithRGB(0xFFFFFF);
    cancelbtn.layer.cornerRadius = 4;
    [cancelbtn setTitle:_cancelTitle forState:UIControlStateNormal];
    [cancelbtn setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    cancelbtn.titleLabel.font = UIScaleFont(18);
    [cancelbtn addTarget:self action:@selector(onCancelTitleAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelbtn];
}

- (void)setSheetHeaderView:(UIView *)sheetHeaderView {
    if (_sheetHeaderView) {
        [_sheetHeaderView removeFromSuperview];
    }
    _sheetHeaderView = sheetHeaderView;
    _sheetHeaderView.centerX = _bottomView.centerX;
    _sheetHeaderView.bottom = _bottomView.top;
    [self addSubview:_sheetHeaderView];
}

- (void)onButtonTitleAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(sheetView:clickedButtonAtIndex:)]) {
        [_delegate sheetView:self clickedButtonAtIndex:btn.tag - kActionSheetButtonTag];
    }
    
    [self removeFromSuperview];
}

- (void)onCancelTitleAction:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(sheetViewCancel:)]) {
        [_delegate sheetViewCancel:self];
    }
    
    [self removeFromSuperview];
}

- (void)removeFromSuperview {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = UIColorWithRGBA(0x000000, 0);
        self.sheetHeaderView.alpha = 0;
        self.bottomView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    [self showAnimation];
}

- (void)show {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    [self showAnimation];
}

- (void)showAnimation {
    self.backgroundColor = UIColorWithRGBA(0x000000, 0);
    _sheetHeaderView.alpha = 0;
    _bottomView.top = kScreenHeight;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = UIColorWithRGBA(0x000000, 0.6);
        self.sheetHeaderView.alpha = 1;
        self.bottomView.bottom = kScreenHeight - IPHONEX_BOTTOM;
    }];
}

@end
