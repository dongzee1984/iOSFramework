//
//  WYDictionary.h
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYDictionary : NSObject

/** 两个dict求差集
 *
 * return 结果集
 *
 */
+ (NSDictionary *)diffSetBetween:(NSDictionary *)dictA dictB:(NSDictionary *)dictB;

@end

FOUNDATION_EXPORT NSString * const WYDictKeyDiffSetOnlyA; // A 有, B 无
FOUNDATION_EXPORT NSString * const WYDictKeyDiffSetOnlyB; // A 无, B 有
FOUNDATION_EXPORT NSString * const WYDictKeyDiffSetBothAB; // 都有

