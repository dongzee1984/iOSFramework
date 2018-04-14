//
//  WYAlertView.h
//  WYCore
//
//  Created by wanglidong on 13-4-25.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  UIAlertView子类, 用于显示对话框。

#import <UIKit/UIKit.h>

typedef void (^WYAlertViewClickedButtonAtIndexBlock)(NSInteger buttonIndex); //

@interface WYAlertView : UIAlertView

@property(nonatomic, assign)BOOL shouldDismissWhenAppEnterBackground; // app回到后台时是否自动取消, Default is YES.

/** 产生一个Alert对话框,未使用ARC时需要手动释放
 *
 * @param title     弹出标题
 * @param message   提示信息
 * @param cancelButtonTitle 取消按钮
 * @param cancelBlock 取消处理
 * @param otherButtonTitles 第一个nil之前参数有效, buttons和blocks必须【成对】出现, 且block不能为nil.
 *
 * @return 返回对话框对象
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYAlertViewClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** 弹出一个对话框，buttons和blocks必须成对出现
 *
 * 同上
 */
+ (void)show:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(WYAlertViewClickedButtonAtIndexBlock)cancelBlock otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** 产生一个Alert对话框,未使用ARC时需要手动释放, 只有一个按钮
 *
 * @param title     弹出标题
 * @param message   提示信息
 * @param buttonTitle 按钮
 * @param completion 处理
 *
 * @return 返回对话框对象
 */
- (id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle completion:(WYAlertViewClickedButtonAtIndexBlock)completion;

/** 弹出一个对话框, 只有一个按钮
 *
 * 同上
 */
+ (void)show:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle completion:(WYAlertViewClickedButtonAtIndexBlock)completion;


/////// simple DEMO ///////
/*
 
 [WYAlertView show:@"demo" message:@"this is a demo." cancelButtonTitle:@"cancel" cancelBlock:nil otherButtonTitles:
 @"button1",^{
 NSLog(@"click button1");
 },
 @"button2",^(NSInteger buttonIndex){
 NSLog(@"click button[%d]",buttonIndex); // 如果需要使用点击了哪个按钮
 },
 nil];
 
 */

@end
