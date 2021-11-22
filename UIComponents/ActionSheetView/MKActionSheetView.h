//
//  MKActionSheetView.h
//  UIComponents
//
//  Created by mikazheng on 2021/7/24.
//

#import <UIKit/UIKit.h>

@class MKActionSheetView;

@protocol MKActionSheetViewDelegate <NSObject>

- (void)sheetView:(MKActionSheetView *)sheetView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)sheetViewCancel:(MKActionSheetView *)sheetView;

@end

@interface MKActionSheetView : UIView

@property (nonatomic, strong) UIView* sheetHeaderView;

- (instancetype)initWithDelegate:(id <MKActionSheetViewDelegate>)delegate cancelTitle:(NSString *)cancelTitle buttonTitles:(NSArray *)buttonTitles;

- (void)showInView:(UIView *)view;
- (void)show;

@end
