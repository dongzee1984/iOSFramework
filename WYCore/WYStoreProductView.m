//
//  WYStoreProductView.m
//  WYCore
//
//  Created by wanglidong on 13-5-11.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYStoreProductView.h"
#import "WYStoreProductViewController.h"
#import "WYString.h"
//#import "WYWebViewController.h"

@implementation WYStoreProductView

+ (void)showProduct:(NSString *)appURL onParentView:(UIViewController *)pvc
{
    if (!appURL) {
        return;
    }
    
    NSString *appIdentifier = [WYString subString:appURL from:@"id" to:@"?mt"];
    if (!appIdentifier) {
        appIdentifier = [WYString subString:appURL from:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" to:nil];
    }
    
    // 使用iOS6 自带store视图
    if (appIdentifier && [WYStoreProductViewController showProduct:appIdentifier onParentView:pvc]) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    
    // 使用自实现的 store视图
//    [WYWebViewController showURL:appURL onParentView:pvc];
}

@end
