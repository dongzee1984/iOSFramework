//
//  WYData.h
//  WYCore
//
//  Created by wanglidong on 13-5-22.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYData : NSObject

/** 将 data 进行 gzip压缩
 */
+ (NSData *)dataWithDataGzip:(NSData *)data;

/** 将 string 进行 gzip压缩
 */
+ (NSData *)dataWithStringGzip:(NSString *)string;

@end
