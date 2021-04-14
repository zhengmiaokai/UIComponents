//
//  MKEffectTipView.m
//  LeCard
//
//  Created by mikazheng on 2020/4/1.
//  Copyright © 2020 LC. All rights reserved.
//

#import "MKEffectTipView.h"
#import "Constant.h"

@interface MKEffectTipView ()

@property (nonatomic, copy) FinishBlock finishBlock;

@end

@implementation MKEffectTipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    UIView* centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    centerView.backgroundColor =  [UIColor colorWithHexString:@"#000000" alpha:0.5];
    centerView.center = CGPointMake(self.width/2, self.height/2);
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    
    UIImageView* iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 48, 48)];
    iconImg.centerX = centerView.width/2;
    iconImg.image = [UIImage imageNamed:@"icon_feedback_success"];
    [centerView addSubview:iconImg];
    
    UILabel* titlelabel = [[UILabel alloc] init];
    titlelabel.font = kFont(13);
    titlelabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    titlelabel.text = @"success";
    [titlelabel sizeToFit];
    titlelabel.top = iconImg.bottom + 10;
    titlelabel.centerX = centerView.width/2;
    [centerView addSubview:titlelabel];
}

- (void)showWithduration:(CGFloat)duration inView:(UIView *)view {
    [view addSubview:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.finishBlock) {
            self.finishBlock();
        }
        [self removeFromSuperview];
    });
}


+ (void)showWithduration:(CGFloat)duration inView:(UIView *)view finish:(FinishBlock)finishBlock {
    MKEffectTipView* tipView = [[MKEffectTipView alloc] initWithFrame:view.bounds];
    tipView.finishBlock = finishBlock;
    [tipView showWithduration:duration inView:view];
}


@end
