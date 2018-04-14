//
//  ALAsset+WYCategory.h
//  WYCore
//
//  Created by wanglidong on 13-6-5.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (WYCategory)
/*
 *  功能：
 *  取得一个ALAsset对象的ID
 *  格式：id.ext
 */
- (NSString *)getAssetId;

+ (NSString *)getAssetId:(NSURL *)assetURL; //通过assetURL取得ID

/*
 *  功能：
 *  取得一个ALAsset对象的url string
 *  格式：assets-library://asset/asset.JPG?id=XXX&ext=XXX
 */
- (NSString *)getAssetUrlString;

/*
 *  功能：
 *  取得一个ALAsset对象的ext
 *  格式：ext
 */
- (NSString *)getAssetExt;

/*
 *  功能：
 *  判断一个ALAsset对象是否为png
 *  格式：YES/NO
 *  修改记录：
 */
- (BOOL)isPng;

/*
 *  功能：
 *  保存ALAsset对象到文件
 *  格式：YES/NO
 *  修改记录：
 */
- (BOOL)saveToFile:(NSString *)filename;
/*
 *  功能：
 *  保存ALAsset对象（图片类型）到文件
 *  格式：YES/NO
 *  修改记录：
 */
- (BOOL)savePhotoFile:(NSString *)filename withQuality:(float)quality;

///*
// *  功能：
// *  保存ALAsset对象（视频类型）到文件
// *  格式：YES/NO
// *  修改记录：
// */
//- (BOOL)saveVideoFile:(NSString *)filename;

/*
 *  功能：
 *  通过ALAsset格式字符串，获取ALAsset对象
 *  格式：ALAsset对象，autorelease，建议调用者手动retain以防提前释放。
 *  修改记录：
 */
+ (ALAsset *)assetForURL:(NSString *)strAsseturl;


#pragma mark - single shared instance of ALAssetsLibrary
// 为 ALAssetsLibrary 提供一个共享单例，用于串行频繁访问时。
// 对于存在同一线程并发访问它的场景，不建议使用。
+ (ALAssetsLibrary *)defaultLibrary;
+ (void)terminatedeDefaultLibrary;

/* 空函数
 * 为了把category编译到app里, 保证category可用, 先调用一次这个无意义的函数
 * 当引用工程设置了 other linker flag -ObjC / all_load时, 无需调用
 */
+ (void)enableCategory;

@end
