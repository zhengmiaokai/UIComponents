//
//  MKEffectTipView.h
//  LeCard
//
//  Created by mikazheng on 2020/4/1.
//  Copyright © 2020 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^FinishBlock) (void);

NS_ASSUME_NONNULL_BEGIN

@interface MKEffectTipView : UIView

+ (void)showWithduration:(CGFloat)duration inView:(UIView *)view finish:(FinishBlock)finish;

@end

NS_ASSUME_NONNULL_END
