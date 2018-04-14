//
//  WYAnimation.m
//  WYCore
//
//  Created by wanglidong on 13-4-23.
//  Copyright (c) 2013年 ksyun. All rights reserved.
//

#import "WYAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "WYBase.h"

@implementation WYAnimation

+ (void)addAnimationRotate:(UIView *)view forKey:(NSString *)key withDuration:(CFTimeInterval)duration
{
    if(![view.layer animationForKey:key])
    {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = duration;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = NSIntegerMax;
        
        [view.layer addAnimation:rotationAnimation forKey:key];
    }
}

+ (void)removeAnimation:(UIView *)view forKey:(NSString *)key
{
    //    imageCd.transform = CATransform3DGetAffineTransform(imageCd.layer.transform);
    [CATransaction begin];
    [view.layer removeAnimationForKey:key];
    [CATransaction commit];
}

+ (void)fadeAnimation:(UIImageView *)imageView withImage:(UIImage *)image
{
    CATransition *transition = [CATransition animation];
    transition.duration = WY_SYS_ANIM_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.removedOnCompletion = YES;
    [imageView.layer addAnimation:transition forKey:nil];
    [imageView setImage:image];
}

+ (void)zoomInAndOutAnimation:(UIView *)view completion:(void (^)(BOOL finished))completion
{
    // step 1
    [UIView animateWithDuration:0.07 animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(0.9,0.9);
        [view setTransform:newTransform];} completion:^(BOOL finished){
            // step 2
            [UIView animateWithDuration:0.11 animations:^{
                CGAffineTransform newTransform = CGAffineTransformMakeScale(1.0,1.0);
                [view setTransform:newTransform];}completion:^(BOOL finished){
                    
                    // finish
                    completion(finished);
                }]; 
        }];
}

+ (void)zoomOutAnimation:(UIView *)view delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion
{
    [self zoomAnimation:view
                   from:CGAffineTransformMakeScale(0.01,0.01)
                     to:CGAffineTransformMakeScale(1.5,1.5)
                  delay:delay
             completion:completion];
}

+ (void)zoomInAnimation:(UIView *)view delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion
{
    [self zoomAnimation:view
                   from:CGAffineTransformMakeScale(1.5,1.5)
                     to:CGAffineTransformMakeScale(0.01,0.01)
                  delay:delay
             completion:completion];
}

#pragma mark - inner private methods
/**
   阶段1显示：从A缩放到正常
   阶段2隐藏：缩放到B。
 * @param view 装载动画的视图
 * @param from 初始态
 * @param to 结束态
 * @param completion 动画结束后的回调block
 */
+ (void)zoomAnimation:(UIView *)view from:(CGAffineTransform)transformA to:(CGAffineTransform)transformB delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion
{
    view.alpha = 0.0;
    view.transform = transformA;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        // 显示
        view.transform = CGAffineTransformMakeScale(1.0,1.0);
        view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3f delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            // 隐藏
            view.alpha = 0.0;
            view.transform = transformB;
        } completion:^(BOOL finished) {
            // 回调
            completion(finished);
        }];
    }];
}

@end
