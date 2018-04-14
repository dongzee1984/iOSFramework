//
//  WYString.h
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  NSString工具方法类

#import <Foundation/Foundation.h>

@interface WYString : NSObject

#pragma mark NSString
/**字符串转char *，结果通过 result 传出, result传入前需在外部分配空间
 *
 * @param string    输入串
 * @param bytes     字节数组
 *
 */
+ (void)decodeHexString:(NSString *)string toBytes:(unsigned char *)bytes;

/** 按字节截取含中文的字符串
 *
 *  1. 截取时按UTF8编码计算字节数
 *
 * @param string    输入串
 * @param maxLength 保留字节长度
 *
 * @return 截取后的字符串
 */
+ (NSString *)subUTF8String:(NSString *)string maxLength:(NSUInteger)maxLength;

/** 截取字符串string, 从 fromString 到 toString 的内容
 *
 *  特殊场景：
 *      如果fromString为nil，则从头开始
 *      如果toString为nil，则截取到末尾
 *      如果fromString或toString不为nil，又没有发现fromString或toString，则返回nil
 */
+ (NSString *)subString:(NSString *)string from:(NSString *)fromString to:(NSString *)toString;

// 
/** 获取字符在字符串第一次出现的位置
 *
 * @return 位置索引
 *         -1表示没有这个字符
 */
+ (NSInteger)firstIndexOfChar:(unichar)ch inString:(NSString *)string;

/** 获取字符在字符串最后一次出现的位置
*
* @return 位置索引
*         -1表示没有这个字符
*/
+ (NSInteger)lastIndexOfChar:(unichar)ch inString:(NSString *)string;


/** 将字符串以URL编码返回值
 */
+ (NSString *)URLEncodedUTF8String:(NSString *)string;
+ (NSString *)URLEncodedString:(NSString *)string withCFStringEncoding:(CFStringEncoding)encoding;

/** 将路径格式“file://”，转为绝对路径
 *
 * @param string    输入串
 *
 * @return 转换后的路径（/a/b/...）
 */
+ (NSString *)absolutePath:(NSString *)string;

#pragma mark convert to NSString

/** 将字典按key排序, 组成 s =  k(1)=v(1) & k(2)=v(2) ... & k(n)=v(n)
 *
 * @param shouldUrlEncode 是否需要进行UrlEncode编码, 包括key, value, 以及 s
 *
 * @return 组装好的字符串
 */
+ (NSString *)sortQueryParams:(NSDictionary *)params urlEncode:(BOOL)shouldUrlEncode;
/** 将query参数串拆分为参数字典
 *
 * @param query query字符串
 *
 * @return 参数字典
 */
+ (NSDictionary *)parseQueryString:(NSString *)query;

/** 将 NSData 转为字符串
  *
  * @param encoding 编码
 */
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

/** 将 NSData 转为字符串, 使用UTF8编码
 */
+ (NSString *)stringWithUTF8Data:(NSData *)data;

/** 将 long long 转为字符串
 */
+ (NSString *)stringWithLongLong:(long long)value;

/** 将 NSDate 转为字符串
 *
 * @param date   日期时间
 * @param format 格式, e.g. @"yyyy-MM-dd HH:mm:ss"
 *
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
/** 将 当前时间 转为字符串
 *
 * @param format 格式, e.g. @"yyyy-MM-dd HH:mm:ss"
 *
 */
+ (NSString *)stringWithNowFormat:(NSString *)format;
/** 将 当前时间 转为时间戳字符串, since 1970.
 *e.g. @"1369118167"
 *
 */
+ (NSString *)stringWithNowTimeInteval;

@end

#pragma mark - C Function API

/** 以下代码作为[WYUtil同名类方法]的C函数版
 * 1. 不太频繁的处理，使用推荐使用同名类方法(OC方式)
 * 2. 大量循环，频繁调用，使用C的方式提高调用效率
 * 3. 只能有限地略减少调用开销
 * 4. 参数及返回值参照同名类方法
 */

/** 字节转字符串
 */
NSString* stringWithSize(double size);
//当 size <= 0.0, 显示 "-- --"
NSString *stringWithSizeAvoidZero(double size);
NSString* stringWithSizeAllowB(double size); //显示单位 B

