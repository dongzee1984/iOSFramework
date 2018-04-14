//
//  WYBundleImagePool.h
//  WYCore
//
//  Created by wanglidong on 13-4-1.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  资源图片加载管理器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYBundleImagePool : NSObject

/*
 * bundle中的小图 / 频繁使用的，建议使用该方法加载
 * 传入image名称作为key(可不含扩展名)，如果当前已加载该图，直接返回它；否则加载后返回。
 * 不做容错，外部保证传入数据的准确性（key不能为空 & key指向的文件保证存在）。
 */
- (UIImage *)loadWithKey:(NSString *)key;

/*
 * bundle中需要对原始图执行拉伸处理的，建议使用该方法加载
 * 传入image名称作为key(可不含扩展名)，如果当前已加载该图，直接返回它；否则加载后返回。
 * 不做容错，外部保证传入数据的准确性（key不能为空 & key指向的文件保证存在）。
 * 宽高自适应拉伸，可能效果不太好，需要再斟酌！
 */
- (UIImage *)loadWithKey:(NSString *)key leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
/*
 * bundle中需要对原始图执行平铺处理的，建议使用该方法加载
 * 传入image名称作为key(可不含扩展名)，如果当前已加载该图，直接返回它；否则加载后返回。
 * 不做容错，外部保证传入数据的准确性（key不能为空 & key指向的文件保证存在）。
 * 以原图进行平铺，可能效果不太好，需要再斟酌！
 */
- (UIImage *)loadWithKey:(NSString *)key inRect:(CGRect)rect;

/*
 * bundle中的大图，偶尔使用的，建议使用该方法加载
 * 传入image的名称（必须含扩展名，除非没有）
 * 不做容错，外部保证传入数据的准确性（name不能为空 & name指向的文件保证存在）。
 * 图片命名格式:(sample.png作为key)
 *        iPhone          sample.png
 *        iPhone retina   sample@2x.png
 *        iPad            sample~ipad.png
 *        iPad retina     sample@2x~ipad.png
 */
- (UIImage *)loadBigImageWithName:(NSString *)name;

/*
 * bundle中的大图，频繁使用的，建议使用该方法加载
 * 传入image的名称（必须含扩展名，除非没有）
 * 不做容错，外部保证传入数据的准确性（key不能为空 & key指向的文件保证存在）。
 * 图片命名格式参照 loadBigImageWithName
 */
- (UIImage *)loadBigImageWithKey:(NSString *)key;

/*
 * bundle中的大图，频繁使用的，建议使用该方法释放;与 loadBigImageWithName 配对使用。
 * 传入image的名称（必须含扩展名，除非没有）
 */
- (void)releaseBigImageWithKey:(NSString *)key;

/*
 * 释放一组图片
 */
- (void)releaseBigImageWithKeys:(NSArray *)keys;

/*
 * 释放全部图片
 */
- (void)releaseAllImages;

@end
