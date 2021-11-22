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

#define UIColorWithRGB(rgbValue)        [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:(1)]

#define UIColorWithRGBA(rgbValue, a)        [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:(a)]

#define UIScalePixel(num) ([[UIScreen mainScreen] bounds].size.width/375.0*num)

#define UIScaleFont(num)  [UIFont systemFontOfSize:UIScalePixel(num)]

#endif /* MKConstant_h */
