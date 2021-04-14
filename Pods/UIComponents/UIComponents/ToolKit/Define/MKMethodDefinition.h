//
//  DynamicDefinition.h
//  Basic
//
//  Created by zhengmiaokai on 2018/7/26.
//  Copyright © 2018年 zhengmiaokai. All rights reserved.
//

#ifndef MKMethodDefinition_h
#define MKMethodDefinition_h

#import "MKMetaDefinition.h"

/* methond */

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

///weakify
#define weakify(...) \
rac_keywordify \
metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

///strongify
#define strongify(...) \
rac_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(rac_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

#endif /* MKMethodDefinition_h */
