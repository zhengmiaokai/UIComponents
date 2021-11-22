//
//  MKSpaceTextField.h
//  UIComponents
//
//  Created by mikazheng on 2021/7/31.
//

#import <UIKit/UIKit.h>

@interface MKSpaceTextField : UITextField

@property (nonatomic, copy) NSArray <NSNumber *> * spaceIndexs;

@property (nonatomic, weak) id <UITextFieldDelegate> originalDelegate;

@property (nonatomic, copy) NSString* realText;

@end
