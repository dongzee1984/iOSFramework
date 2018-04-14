//
//  WYAnimation.h
//  WYCore
//
//  Created by wanglidong on 13-4-23.
//  Copyright (c) 2013年 ksyun. All rights reserved.
//
//  动画控制类，默认动画播放时间为系统动画时间。

#import <UIKit/UIKit.h>

@interface WYAnimation : NSObject

/** 在view上加入一个循环自转的动画, 移除需要手动调用
 + (void)removeAnimation:(UIView *)view forKey:(NSString *)key;
 
 * @param view     装载动画的视图
 * @param key      标识该动画的关键字
 * @param duration 转动一圈的时间
 */
+ (void)addAnimationRotate:(UIView *)view forKey:(NSString *)key withDuration:(CFTimeInterval)duration;

/** 移除view上的动画key

 * @param view     装载动画的视图
 * @param key      标识该动画的关键字
 */
+ (void)removeAnimation:(UIView *)view forKey:(NSString *)key;

/** 淡入淡出效果显示一个图片
 
 * @param imageView 图片控件
 * @param image     要显示的图片
 */
+ (void)fadeAnimation:(UIImageView *)imageView withImage:(UIImage *)image;

/**  先小后大效果
 * @param view 装载动画的视图
 * @param completion 动画结束后的回调block
 */
+ (void)zoomInAndOutAnimation:(UIView *)view completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);

/**  缩小消失
 * @param view 装载动画的视图
 * @param completion 动画结束后的回调block
 */
+ (void)zoomInAnimation:(UIView *)view delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
/**  放大消失
 * @param view 装载动画的视图
 * @param completion 动画结束后的回调block
 */
+ (void)zoomOutAnimation:(UIView *)view delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);


@end
