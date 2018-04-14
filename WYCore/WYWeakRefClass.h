//
//  WYWeakRefClass.h
//  WYCore
//
//  Created by wanglidong on 13-5-1.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  对象弱引用类

#import <Foundation/Foundation.h>

@interface WYWeakRefClass : NSObject

+ (id)getWeakReferenceOf:(id)source;

- (void)forwardInvocation:(NSInvocation *)anInvocation;

@property(nonatomic,assign)id source;

@end
