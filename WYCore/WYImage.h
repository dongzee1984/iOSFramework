//
//  WYImage.h
//  WYCore
//
//  Created by wanglidong on 13-5-10.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYImage : NSObject

/** 将UIImage透明化
 *
 * @param image  原图
 *
 * @return 原图大小的透明图
 */
+ (UIImage *)transparentImage:(UIImage *)image;

/** 将UIImage转为rect大小, 但图案保持原大小, 多余部分透明
 *
 * @param image  原图
 * @param rect  矩形区域, size为区域大小, origin为image左上角坐标
 *
 * @return 原图大小的透明图
 */
+ (UIImage *)fill:(UIImage *)image withRect:(CGRect)rect;
/** 将UIImage转为rect大小, 使用原图平铺
 *
 * @param image  原图
 * @param rect  矩形区域
 *
 * @return 原图铺满的rect大小的图
 */
+ (UIImage *)fill:(UIImage *)image inRect:(CGRect)rect;

/** 缩放UIImage
 *
 * @param image  原图
 * @param size   预期大小
 *
 * @return 缩放后的图片
 */
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

/** 缩放UIImage, 保持原有宽高比
 *
 * @param image  原图
 * @param size   预期大小
 *
 * @return 缩放后的图片
 */
+ (UIImage *)scaleAspect:(UIImage *)image toSize:(CGSize)size;

/** 旋转UIImage
 *
 * @param image  原图
 * @param orientation 方向
 *
 * @return 旋转后的图片
 */
+ (UIImage *)rotateImage:(UIImage *)image;
+ (UIImage *)rotationImage:(UIImage *)image orientation:(UIImageOrientation)orient;



/** 保存图像数据到文件, 包含meta信息
 *
 * @param data  图片数据
 * @param path  文件全路径
 * @param meta  meta信息
 *
 * @return 保存成功 YES / 失败 NO
 */
+ (BOOL)saveImageData:(NSData *)data toFile:(NSString *)path withMeta:(NSDictionary *)meta;


@end
