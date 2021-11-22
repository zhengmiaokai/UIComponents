//
//  MKSpaceTextField.m
//  UIComponents
//
//  Created by mikazheng on 2021/7/31.
//

#import "MKSpaceTextField.h"

@interface MKSpaceTextField () <UITextFieldDelegate>

@end

@implementation MKSpaceTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setRealText:(NSString *)realText {
    for (NSNumber* spaceIndex in _spaceIndexs) {
        if (spaceIndex.intValue <= realText.length) {
            NSString* replaceStr = [NSString stringWithFormat:@"%@ ", [realText substringWithRange:NSMakeRange(0, spaceIndex.intValue)]];
            realText = [realText stringByReplacingCharactersInRange:NSMakeRange(0, spaceIndex.intValue) withString:replaceStr];
        }
    }
    self.text = realText;
}

- (NSString *)realText {
    return [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_originalDelegate && [_originalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_originalDelegate textFieldDidEndEditing:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_originalDelegate && [_originalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_originalDelegate textFieldDidBeginEditing:textField];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) { // 删除字符
        NSInteger currentIndex = textField.text.length - 2;
        for (NSNumber* index in self.spaceIndexs) {
            if (currentIndex == index.intValue) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
        }
    } else {
        NSInteger currentIndex = textField.text.length;
        for (NSNumber* index in self.spaceIndexs) {
            if (currentIndex == index.intValue) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
    }
    return YES;
}


@end
