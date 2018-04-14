//
//  WYActionSheet.h
//  WYCore
//
//  Created by wanglidong on 13-5-2.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WYActionSheetClickedButtonAtIndexBlock)(NSInteger buttonIndex); //

@interface WYActionSheet : UIActionSheet<UIActionSheetDelegate>

@property(nonatomic, assign)BOOL shouldDismissWhenAppEnterBackground; // app回到后台时是否自动取消, Default is YES.
@property(nonatomic, assign)BOOL shouldDismissWhenDeviceRotate; // 屏幕旋转时是否自动取消, Default is YES.

/** 产生一个ActionSheet, 未使用ARC时需要手动释放
 *
 * @param title     提示信息
 * @param cancelButtonTitle 取消按钮
 * @param cancelBlock 取消处理
 * @param otherButtonTitles 第一个nil之前参数有效, buttons和blocks必须【成对】出现, 且block不能为nil.
 *
 * @return 返回ActionSheet对象
 */
- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** 显示一个ActionSheet, buttons和blocks必须成对出现
 *  同上
 */
+ (void)showInview:(UIView *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromTabBar:(UITabBar *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromToolbar:(UIToolbar *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** 显示一个ActionSheet, 有destructiveButton的, destructiveButtonTitle & destructiveBlock 不能为nil.
 *  同上
 */
+ (void)showInview:(UIView *)view
         withTitle:(NSString *)title
 cancelButtonTitle:(NSString *)cancelButtonTitle
       cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromTabBar:(UITabBar *)view
             withTitle:(NSString *)title
     cancelButtonTitle:(NSString *)cancelButtonTitle
           cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
      destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
     otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromToolbar:(UIToolbar *)view
              withTitle:(NSString *)title
      cancelButtonTitle:(NSString *)cancelButtonTitle
            cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
 destructiveButtonTitle:(NSString *)destructiveButtonTitle
       destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
      otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromBarButtonItem:(UIBarButtonItem *)item
                     animated:(BOOL)animated
                    withTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
                  cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
             destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showFromRect:(CGRect)rect
              inView:(UIView *)view
            animated:(BOOL)animated
           withTitle:(NSString *)title
   cancelButtonTitle:(NSString *)cancelButtonTitle
         cancelBlock:(WYActionSheetClickedButtonAtIndexBlock)cancelBlock
destructiveButtonTitle:(NSString *)destructiveButtonTitle
    destructiveBlock:(WYActionSheetClickedButtonAtIndexBlock)destructiveBlock
   otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

/////// simple DEMO ///////
/*
 
 WYActionSheet *sheet = [[[WYActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"%d",[indexPath row]] cancelButtonTitle:@"CANCEL" cancelBlock:^(NSInteger buttonIndex){
 NSLog(@"%s [%d]",__func__,buttonIndex);
 } otherButtonTitles:@"1",^(NSInteger buttonIndex){
 NSLog(@"%s [%d]",__func__,buttonIndex);
 }, @"2",^(NSInteger buttonIndex){
 NSLog(@"%s [%d]",__func__,buttonIndex);
 },nil] autorelease];
 
 [sheet setDestructiveButtonIndex:0];// sets destructive (red) button. -1 means none set. default is -1. ignored if only one button
 
 [sheet showFromTabBar:self.tabBarController.tabBar];
 
 */
