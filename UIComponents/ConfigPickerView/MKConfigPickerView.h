//
//  MKConfigPickerView.h
//  UIComponents
//
//  Created by mikazheng on 2021/11/18.
//

#import <UIKit/UIKit.h>

@interface MKConfigPickerView : UIView

- (instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents values:(NSArray *)values confirmBack:(void(^)(NSInteger row, NSString *content, id value))confirmBack;

- (void)showInView:(UIView *)view;
- (void)show;

@end
