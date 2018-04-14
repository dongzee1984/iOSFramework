//
//  WYJSON.h
//  WYJSON
//
//  Created by wanglidong on 13-6-14.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYJSON : NSObject
/* 空函数
 * 为了把category编译到app里, 保证category可用, 先调用一次这个无意义的函数
 * 当引用工程设置了 other linker flag -ObjC / all_load时, 无需调用
 */
+ (void)enableCategory;

/** 将 NSDictionary / NSArray 转为JSON对象
 *
 * @return 返回 JSON 对象字节流
 */
+ (NSData *)dataWithJSONObject:(id)obj;

/** 将 NSDictionary / NSArray 转为JSON对象
 *
 * @return 返回 JSON 对象字符串
 */
+ (NSString *)stringWithJSONObject:(id)obj;


/** 将 字节流 转为 NSDictionary / NSArray 对象
 *
 * @return 返回 NSDictionary / NSArray
 */
+ (id)JSONObjectWithData:(NSData *)data;
+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error;

/** 将 字符串 转为 NSDictionary / NSArray 对象
 *
 * @return 返回 NSDictionary / NSArray
 */
+ (id)JSONObjectWithString:(NSString *)string;
+ (id)JSONObjectWithString:(NSString *)string error:(NSError **)error;

@end
