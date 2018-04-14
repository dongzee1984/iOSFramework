//
//  WYUIBase.m
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYUIBase.h"

@implementation WYUIBase

+ (void)dismissAllActionView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:dismissAllActionViewNotify object:nil];
}

@end

#pragma mark - CGPoint
CGFloat distanceBetweenPoints(CGPoint pa, CGPoint pb)
{
    return hypotf(pb.x - pa.x,pb.y - pa.y);
}



NSString *const dismissAllActionViewNotify = @"wydmaavn";


//MIN(H,MAX(n,L)) vs MAX(L,MIN(n,H))的效率
//当n在[L,H)内，MIN(H,MAX(n,L))效率最高
//当n在[H,∞)内，MAX(L,MIN(n,H))效率最高

//以下经测试，效率比MIN(H,MAX(n,L))或MAX(L,MIN(n,H))要低。仅作为一种思路，不具备实用性。
////将值限定在区间内（类型任意）
//#if !defined(MIN_MAX)
//#define MIN_MAX(n,L,H) MIN((H),MAX((n),(L)))
//#endif
////将值限定在区间内（类型任意）
//#if !defined(MAX_MIN)
//#define MAX_MIN(n,L,H) MAX((L),MIN((n),(H)))
//#endif

////将值限定在区间内，代替形如MIN(H,MAX(n,L))（类型任意）
//#if !defined(MIN_MAX)
//#define MIN_MAX(n,L,H) ({ *n = MAX(*n,L); *n = MIN(*n,H); })
//#endif
////将值限定在区间内，代替形如MAX(L,MIN(n,H))（类型任意）
//#if !defined(MAX_MIN)
//#define MAX_MIN(n,L,H) ({ *n = MIN(*n,H); *n = MAX(*n,L); })
//#endif

