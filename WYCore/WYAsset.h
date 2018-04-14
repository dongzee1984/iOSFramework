//
//  WYAsset.h
//  WYCore
//
//  Created by wanglidong on 13-6-5.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface WYAsset : NSObject
/*
 *  功能：
 *  取得一个ALAsset对象的ID
 *  格式：id.ext
 */
+ (NSString *)persistentId:(ALAsset *)asset;

+ (NSString *)persistentIdWithURL:(NSURL *)assetURL; //通过assetURL取得ID

/*
 *  功能：
 *  取得一个ALAsset对象的url string
 *  格式：assets-library://asset/asset.JPG?id=XXX&ext=XXX
 */
+ (NSString *)urlString:(ALAsset *)asset;

/*
 *  功能：
 *  取得一个ALAsset对象的ext
 *  格式：ext
 */
+ (NSString *)ext:(ALAsset *)asset;

/*
 *  功能：
 *  判断一个ALAsset对象是否为png
 *  格式：YES/NO
 *  修改记录：
 */
+ (BOOL)isPNG:(ALAsset *)asset;

/*
 *  功能：
 *  保存ALAsset对象到文件
 *  格式：YES/NO
 *  修改记录：
 */
+ (BOOL)saveAsset:(ALAsset *)asset toFile:(NSString *)filename;
/*
 *  功能：
 *  保存ALAsset对象（图片类型）到文件
 *  格式：YES/NO
 *  修改记录：
 */
+ (BOOL)saveImageAsset:(ALAsset *)asset toFile:(NSString *)filename withQuality:(float)quality;

/*
 *  功能：
 *  通过ALAsset格式字符串，获取ALAsset对象
 *  格式：ALAsset对象，autorelease，建议调用者手动retain以防提前释放。
 *  修改记录：
 */
+ (ALAsset *)assetForURL:(NSString *)strAsseturl;

/** 计算文件分块数据
 *
 * @param asset asset对象
 * @param blockSize 每个分块大小
 *
 * @return 文件分块信息
 */
+ (NSDictionary *)calcBlocksOfAsset:(ALAsset *)asset withBlockSize:(NSInteger)blockSize;
/** 获取块数据
 *
 * @param asset asset对象
 * @param offset 块起始位置
 * @param size 块待读取大小
 *
 * @return 文件分块信息
 */
+ (NSData *)readDataOfAsset:(ALAsset *)asset fromOffset:(long long)offset size:(int)size;

#pragma mark - single shared instance of ALAssetsLibrary
// 为 ALAssetsLibrary 提供一个共享单例，用于串行频繁访问时。
// 对于存在同一线程并发访问它的场景，不建议使用。
+ (ALAssetsLibrary *)defaultLibrary;
+ (void)terminatedeDefaultLibrary;

#pragma mark method of ALAssetsLibrary

/** 将 data 存入系统相册
 *
 * @param data            图片数据
 * @param metadata        图片的meta信息
 * @param completionBlock 操作完成后回调处理
 */
+ (void)saveImageDataToPhotosAlbum:(NSData *)data metadata:(NSDictionary *)metadata completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock;

+ (void)saveImageDataToPhotosAlbum:(NSData *)data completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock;

@end
