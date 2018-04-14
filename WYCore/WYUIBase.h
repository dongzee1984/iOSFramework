//
//  WYUIBase.h
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  CoreGraphics base / UIView 工具类

#import <UIKit/UIKit.h>

@interface WYUIBase : NSObject

/**
 * 关闭当前所有弹出式菜单
 */
+ (void)dismissAllActionView;

@end

#pragma mark - C Function API

/** 以下代码作为[WYUtil同名类方法]的C函数版
 * 1. 不太频繁的处理，使用推荐使用同名类方法(OC方式)
 * 2. 大量循环，频繁调用，使用C的方式提高调用效率
 * 3. 只能有限地略减少调用开销
 * 4. 参数及返回值参照同名类方法
 */

#pragma mark CGPoint
/** 两点距离
 */
CGFloat distanceBetweenPoints(CGPoint pa, CGPoint pb);



UIKIT_EXTERN NSString *const dismissAllActionViewNotify;
