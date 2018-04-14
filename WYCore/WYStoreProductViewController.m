//
//  WYStoreProductViewController.m
//  WYCore
//
//  Created by wanglidong on 13-5-11.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYStoreProductViewController.h"
#import "WYBase.h"

//NSClassFromString(@"SKStoreProductViewController")

#define LOG_THIS_FILE 0

@implementation WYStoreProductViewController

#pragma mark - point
+ (BOOL)showProduct:(NSString *)appIdentifier onParentView:(UIViewController *)pvc
{
#if LOG_THIS_FILE
    NSLog(@"%s[%@]",__func__,appIdentifier);
#endif
    if(NSClassFromString(@"SKStoreProductViewController") &&
       appIdentifier != nil &&
       pvc != nil &&
       [pvc isKindOfClass:[UIViewController class]])
    {
        //        [[KSTip shareTip] showInView:self.view withText:@""];
        
        // Initialize Product View Controller
        WYStoreProductViewController *storeProductViewController = [[WYStoreProductViewController alloc] init];
        // Configure View Controller
        [storeProductViewController setDelegate:storeProductViewController];
        [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appIdentifier}
                                              completionBlock:^(BOOL result, NSError *error) {
                                                  if (error) {
                                                      
                                                      //                                                      [[KSTip shareTip] hide];
                                                      NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                                                  } else {
                                                      //                                                      [[KSTip shareTip] hide];
                                                      // Present Store Product View Controller
                                                      //                                                      [self presentViewController:storeProductViewController animated:YES completion:nil];
                                                  }
                                              }];
        [pvc presentViewController:storeProductViewController animated:YES completion:nil];
        [storeProductViewController release];
        return YES;
    }

    return NO;
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// iOS6.0 & later
- (NSUInteger)supportedInterfaceOrientations
{
    if(IS_PHONE())
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if(IS_PHONE())
    {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
    else
    {
        return YES;
    }
}

- (void)dealloc
{
#if LOG_THIS_FILE
    NSLog(@"%s",__func__);
#endif
    [super dealloc];
}

@end
