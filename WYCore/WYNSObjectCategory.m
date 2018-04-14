//
//  NSObjectCategory.m
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYNSObjectCategory.h"

#define LOG_THIS_FILE 0

@implementation WYNSObjectCategory

+ (void)enableCategory
{

}

@end


#pragma mark - NSMutableArray
@implementation NSMutableArray (WYCategory)

- (void)addSafely:(id)object
{
    if (object == nil) return;
    
    [self addObject:object];
}

@end



#pragma mark - NSDictionary
@implementation NSDictionary (WYCategory)
- (long long)longlongForKey:(id)key
{
    return [((NSNumber *)[self objectForKey:key]) longLongValue];
}
- (NSInteger)integerForKey:(id)key
{
    return [[self objectForKey:key] integerValue];
}
- (int)intForKey:(id)key
{
    return [[self objectForKey:key] intValue];
}
- (float)floatForKey:(id)key
{
    return [[self objectForKey:key] floatValue];
}
- (double)doubleForKey:(id)key
{
    return [[self objectForKey:key] doubleValue];
}
- (BOOL)boolForKey:(id)key
{
    return [[self objectForKey:key] boolValue];
}

@end

#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (WYCategory)

#pragma mark basecally type value add to dictionary
- (void)setLongLong:(long long)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithLongLong:value] forKey:key];
}
- (void)setInteger:(NSInteger)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithInteger:value] forKey:key];
}
- (void)setInt:(int)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}
- (void)setFloat:(float)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}
- (void)setDouble:(double)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}
- (void)setBool:(BOOL)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

#pragma mark safely set object
- (void)setSafely:(id)value forKey:(id)key
{
    if (value == nil || key == nil) return;
    [self setObject:value forKey:key];
}

@end
