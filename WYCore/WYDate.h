//
//  WYDate.h
//  WYCore
//
//  Created by wanglidong on 13-5-9.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYDate : NSObject

/** 将指定字符串转为日期类型
 * 格式为: yyyy-MM-dd HH:mm:ss
 *
 * @string 字符串
 *
 */
+ (NSDate *)dateWithString:(NSString *)string;

/** 判断 date 是否为今天
 *
 * @param date   日期时间, nil时不认为是今天
 * @param tzName 时区, e.g. @"Asia/Shanghai"
 *
 * return 是 YES / 不是 NO
 */
+ (BOOL)isToday:(NSDate *)date withTimeZoneName:(NSString *)tzName;

/** 判断 date 是否为今天
 *
 * @param date   日期时间
 * @param tzName 时区, e.g. @"Asia/Shanghai"
 * @param defaultValue //date == nil 时, 是否当作今天
 *
 * return 是 YES / 不是 NO
 */
+ (BOOL)isToday:(NSDate *)date withTimeZoneName:(NSString *)tzName defaultValue:(BOOL)defaultValue;

/** 获取今天零时的时间戳
 *
 * @param tzName 时区, e.g. @"Asia/Shanghai"
 *
 * return 时间戳
 */
+ (NSTimeInterval)todayZerowithTimeZoneName:(NSString *)tzName;
/** 获取当期时间戳
 */
+ (NSTimeInterval)timeInterval;

@end
