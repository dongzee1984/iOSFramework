//
//  WYDictionary.m
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYDictionary.h"

NSString * const WYDictKeyDiffSetOnlyA = @"_WYDictKeyDiffSetOnlyA"; //
NSString * const WYDictKeyDiffSetOnlyB = @"_WYDictKeyDiffSetOnlyB";
NSString * const WYDictKeyDiffSetBothAB = @"_WYDictKeyDiffSetBothAB";

@implementation WYDictionary

+ (NSDictionary *)diffSetBetween:(NSDictionary *)dictA dictB:(NSDictionary *)dictB
{
    // dir files
    NSDictionary *dirFiles = [dictA retain];
    // db files
    NSDictionary *dbFiles = [dictB retain];
    
    NSMutableArray *dList = [[NSMutableArray alloc]init];
    NSMutableArray *uList = [[NSMutableArray alloc]init];
    NSMutableArray *aList = [[NSMutableArray alloc]init];
    
    // 1. select in db exist ?
    NSArray *keys = [dirFiles allKeys];
    for (id key in keys) {
        id obj1 = [dbFiles objectForKey:key];
        // not found
        if(obj1 == nil)
        {
            [aList addObject:[dirFiles objectForKey:key]];
        }
        else
        {
            id obj2 = [dirFiles objectForKey:key];
            // not equal
            if([obj1 respondsToSelector:@selector(isEqualTo:)])
            {
                if(![obj1 performSelector:@selector(isEqualTo:) withObject:obj2])
                {
                    [uList addObject:obj2];
                }
            }
        }
    }
    
    // 2. select on server dir exist?
    keys = [dbFiles allKeys];
    for (id key in keys) {
        id obj = [dirFiles objectForKey:key];
        // not found
        if(obj == nil)
        {
            [dList addObject:[dbFiles objectForKey:key]];
        }
    }
    
    // 4. mark
    
    NSDictionary *list = [NSDictionary dictionaryWithObjectsAndKeys:
                          dList,WYDictKeyDiffSetOnlyB, // 仅存在于旧集合, 需要删除掉
                          uList,WYDictKeyDiffSetBothAB, // 两个集合都有且不同, 需要更新
                          aList,WYDictKeyDiffSetOnlyA, // 仅存在于新集合, 需要加入到B
                          nil];

    [dList release];
    [uList release];
    [aList release];
    
    [dirFiles release];
    [dbFiles release];

    return list;
}

@end
