//
//  MKConstant.h
//  UIComponents
//
//  Created by mikazheng on 2021/11/22.
//

#ifndef MKConstant_h
#define MKConstant_h
#import <MKUtils/UIScreen+Addition.h>

#define IPHONEX_BOTTOM (isNotchScreen ? 34 : 0)

#define UIScalePixel(num) ([[UIScreen mainScreen] bounds].size.width/375.0*num)

#define UIScaleFont(num)  [UIFont systemFontOfSize:UIScalePixel(num)]

#endif /* MKConstant_h */
