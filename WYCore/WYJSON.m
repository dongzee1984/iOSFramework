//
//  WYJSON.m
//  WYJSON
//
//  Created by wanglidong on 13-6-14.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYJSON.h"

#import "JSONKit.h"

#define IS_NSJSON_AVAILABLE() NSClassFromString(@"NSJSONSerialization")

#if 0
#define LOG_FUNC() NSLog(@"+++++++++++++++ %s line[%d]",__FUNCTION__,__LINE__)
#else
#define LOG_FUNC()
#endif

@implementation WYJSON
+ (void)enableCategory
{
    [JSONDecoder enableCategory];
}

+ (NSData *)dataWithJSONObject:(id)obj
{
    if (!obj) {
        return nil;
    }
    else if (IS_NSJSON_AVAILABLE()) {
        return [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    }
    else
    {
        return [obj JSONData];
    }
}

+ (NSString *)stringWithJSONObject:(id)obj
{
    if (!obj) {
        return nil;
    }
    else if (IS_NSJSON_AVAILABLE()) {
        
        return [[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]autorelease];
    }
    else
    {
        return [obj JSONString];
    }
}

+ (id)JSONObjectWithData:(NSData *)data
{
    return [self JSONObjectWithData:data error:NULL];
}

+ (id)JSONObjectWithData:(NSData *)data error:(NSError **)error
{
    if (!data) {
        return nil;
    }
    else if (IS_NSJSON_AVAILABLE()) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:error];
    }
    else
    {
        return [data objectFromJSONDataWithParseOptions:JKParseOptionStrict error:error];
    }
}

+ (id)JSONObjectWithString:(NSString *)string
{
    return [self JSONObjectWithString:string error:NULL];
}

+ (id)JSONObjectWithString:(NSString *)string error:(NSError **)error
{
    if (!string) {
        return nil;
    }
    else if (IS_NSJSON_AVAILABLE()) {
        return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
    }
    else
    {
        return [string objectFromJSONStringWithParseOptions:JKParseOptionStrict error:error];
    }
}

@end
