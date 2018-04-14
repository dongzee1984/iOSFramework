//
//  WYStoreProductViewController.h
//  WYCore
//
//  Created by wanglidong on 13-5-11.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  SKStoreProductViewController子类, 用于显示appStore

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


SK_EXTERN_CLASS_AVAILABLE(6_0) @interface WYStoreProductViewController : SKStoreProductViewController<SKStoreProductViewControllerDelegate>

/** 以视图方式显示appstore
 *
 * @param appIdentifier app标识, 不能为空
 * @param pvc 模态弹出的父窗口, 不能为空
 *
 * @return 是否能显示store视图 能 YES / 不能 NO, 建议使用浏览器打开
 */
+ (BOOL)showProduct:(NSString *)appIdentifier onParentView:(UIViewController *)pvc;

@end
