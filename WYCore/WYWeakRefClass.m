//
//  WYWeakRefClass.m
//  WYCore
//
//  Created by wanglidong on 13-5-1.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYWeakRefClass.h"

@implementation WYWeakRefClass
@synthesize source;

- (id)init{
    self = [super init];
    //    if (self) {
    //    }
    return self;
}

+ (id) getWeakReferenceOf: (id) _source{
    
    WYWeakRefClass* ref = [[WYWeakRefClass alloc]init];
    ref.source = _source; //hold weak reference to original class
    
    return [ref autorelease];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [[self.source class ] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:self.source];
    
}
@end
