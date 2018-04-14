//
//  NSObjectCategory.h
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYNSObjectCategory : NSObject

/* 空函数
 * 为了把category编译到app里, 保证category可用, 先调用一次这个无意义的函数
 * 当引用工程设置了 other linker flag -ObjC / all_load时, 无需调用
 */
+ (void)enableCategory;

@end

#pragma mark - NSMutableArray
@interface NSMutableArray (WYCategory)
/*
 * 为保证传入数据的安全性，在add前验证value的安全性。
 */
- (void)addSafely:(id)object;

@end
// 回避nil值
#ifndef kUFArrayAddObjectSafe
#define kUFArrayAddObjectSafe(arr,v)\
do{\
[arr addSafely:v];\
}while(0)
#endif


#pragma mark - NSDictionary
@interface NSDictionary (WYCategory)
/*
 * 取出dictionary里的对象，转为基本类型数据
 * 不做容错，外部保证传入数据的准确性，如果不确定时，强转后再传入。
 */
- (long long)longlongForKey:(id)key;
- (NSInteger)integerForKey:(id)key;
- (int)intForKey:(id)key;
- (float)floatForKey:(id)key;
- (double)doubleForKey:(id)key;
- (BOOL)boolForKey:(id)key;

@end

#pragma mark - NSMutableDictionary
@interface NSMutableDictionary (WYCategory)

/*
 * 将基本类型数据添加到dictionary
 * 不做容错，外部保证传入数据的准确性，如果不确定时，强转后再传入。
 */
- (void)setLongLong:(long long)value forKey:(id)key;
- (void)setInteger:(NSInteger)value forKey:(id)key;
- (void)setInt:(int)value forKey:(id)key;
- (void)setFloat:(float)value forKey:(id)key;
- (void)setDouble:(double)value forKey:(id)key;
- (void)setBool:(BOOL)value forKey:(id)key;

#pragma mark safely set object
/*
 * 为保证传入数据的安全性，在set前验证key/value的安全性。
 */
- (void)setSafely:(id)value forKey:(id)key;

@end

#ifndef kUFDicSetObjectSafe
#define kUFDicSetObjectSafe(dic,v,k)\
do{\
[dic setSafely:v forKey:k];\
}while(0)
#endif

