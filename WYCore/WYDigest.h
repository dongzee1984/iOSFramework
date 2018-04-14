//
//  WYDigest.h
//  WYCore
//
//  Created by wanglidong on 13-4-27.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  加密算法类

#import <Foundation/Foundation.h>

@interface WYDigest : NSObject

/** 计算 NSString 的 SHA1 / MD5
 */
+ (NSString *)SHA1:(NSString *)string;
+ (NSString *)MD5:(NSString *)string;
+ (NSString *)SHA1FromBytes:(const unsigned char *)sha1;
+ (NSString *)MD5FromBytes:(const unsigned char *)md5;

+ (uint32_t)CRC32:(NSData *)data;

/** HMAC-SHA1加密
 */
+ (NSData *)HMACSHA1EncodedData:(NSData *)data withKey:(NSString *)key;
+ (NSData *)HMACSHA1EncodedString:(NSString *)string withKey:(NSString *)key;

/** string进行RC4加密
 *
 * @param string    输入串
 * @param key       密钥
 *
 * @return 加密后的字符串
 */
+ (NSString *)ARC4Encrypt:(NSString *)string withKey:(NSString *)key;

/** RC4加密/解密
 *
 * @param data  源数据
 *
 * @return 加密/解密后的数据
 */
+ (NSData *)RC4Encrypt:(NSData *)data withKey:(unsigned char *)key;
+ (NSData *)RC4Decrypt:(NSData *)data withKey:(unsigned char *)key;

@end
