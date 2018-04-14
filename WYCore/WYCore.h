//
//  WYCore.h
//  WYCore
//
//  Created by wanglidong on 13-4-1.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#ifndef WYCore_WYCore_h
#define WYCore_WYCore_h


/* Definition of `WY_INLINE'. */

#if !defined(WY_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define WY_INLINE static inline
# elif defined(__cplusplus)
#  define WY_INLINE static inline
# elif defined(__GNUC__)
#  define WY_INLINE static __inline__
# else
#  define WY_INLINE static
# endif
#endif


#import "WYNSObjectCategory.h"

#endif
