//
//  WYStoreProductView.h
//  WYCore
//
//  Created by wanglidong on 13-5-11.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYStoreProductView : NSObject

/** 以视图方式显示appstore
 *
 * @param appURL app地址
 * @param pvc 模态弹出的父窗口, 不能为空
 *
 */
+ (void)showProduct:(NSString *)appURL onParentView:(UIViewController *)pvc;

@end
