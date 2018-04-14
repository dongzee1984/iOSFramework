//
//  WYFileManager.h
//  WYCore
//
//  Created by wanglidong on 13-4-26.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  文件关联操作类

#import <Foundation/Foundation.h>

@interface WYFileManager : NSObject

#pragma mark - size
/** 计算一个目录的总大小
 *
 * @param path 目录全路径
 *
 * @return 目录大小, 单位: 字节
 */
+ (long long)sizeOfFolder:(NSString *)path;

/** 设备磁盘总大小
 */
+ (long long)deviceTotalSize NS_AVAILABLE(10_5, 2_0);

/** 设备磁盘剩余空间大小
 */
+ (long long)deviceFreeSize NS_AVAILABLE(10_5, 2_0);

/** 设置文件属性:修改时间
 *
 * @param date 更新时间
 *
 * @param path 文件（夹）全路径
 *
 * @return 设置成功 YES / 否则 NO
 */
+ (BOOL)setModifyTime:(NSDate *)date ofItemAtPath:(NSString *)path NS_AVAILABLE(10_5, 2_0);
// 失败时想要查看原因使用下面的接口.
+ (BOOL)setModifyTime:(NSDate *)date ofItemAtPath:(NSString *)path  error:(NSError **)error NS_AVAILABLE(10_5, 2_0);

#pragma mark - file/folder
/** 获取目录下的所有项目，包括文件夹和文件
 *
 * @param path 目录全路径
 *
 * @return 文件（夹）列表
 */
+ (NSArray *)childrenAtPath:(NSString *)path;

/** 获取目录下的所有有效文件
 *
 * @param path 目录全路径
 *
 * @return 文件列表
 */
+ (NSArray *)filesAtPath:(NSString *)path;

/** 检查是否存在文件或目录
 *
 * @param path 目录全路径
 * @param isDirectory path是否为目录
 *
 * @return 存在 YES / 否则 NO
 */
+ (BOOL)isExist:(NSString *)path isDirectory:(BOOL)isDirectory;

/***************************************************************
 同一目录下, 无法同时存在同名的文件和目录, 为保证正确创建, 采用了以下规则:
 1. newFoler 会删除同名的file
 2. newFile  会删除同名的folder 
 **************************************************************/

/** 新建目录
 *
 * @param path 目录全路径
 * @param shouldForce 是否强制新建, 强制新建会先删除已存在的目录(包括其子目录, 慎用!!!), 再新建.
 *
 * @return 目录创建成功 YES / 否则 NO
 */
+ (BOOL)newFolder:(NSString *)path force:(BOOL)shouldForce NS_AVAILABLE(10_5, 2_0);
// 通常newFoler是不会失败的, 失败时想要查看原因使用下面的接口.
+ (BOOL)newFolder:(NSString *)path error:(NSError **)error force:(BOOL)shouldForce NS_AVAILABLE(10_5, 2_0);

/** 新建文件
 *
 * @param path 文件全路径
 * @param shouldForce 是否强制新建, 强制新建会先删除已存在的文件, 再新建.
 *
 * @return 文件创建成功 YES / 否则 NO
 */
+ (BOOL)newFile:(NSString *)path force:(BOOL)shouldForce NS_AVAILABLE(10_5, 2_0);

/** 生成一个写入流
 *
 * @param path 文件全路径
 * @param shouldAppend 是否将新内容追加到原有文件结尾
 *
 * @return 写入流
 */
+ (NSOutputStream *)outputStreamToFileAtPath:(NSString *)path append:(BOOL)shouldAppend NS_AVAILABLE(10_5, 2_0);

/** 拷贝文件(夹)
 *
 * 目标路径(及其上级目录)如果不存在, 会自动创建
 *
 * @param srcPath 文件(夹)源路径
 * @param dstPath 文件(夹)目标路径
 * @param shouldForce 是否强制拷贝, 强制拷贝会先删除目标路径已存在的文件(夹), 再拷贝.
 *
 * @return 复制成功 YES / 否则 NO
 */
+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath force:(BOOL)shouldForce NS_AVAILABLE(10_5, 2_0);
// 失败时想要查看原因使用下面的接口.
+ (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error NS_AVAILABLE(10_5, 2_0);

/** 移动文件(夹)
 *
 * 参考 copyItemAtPath, 唯一区别是会删除源路径 srcPath
 *
 */
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath force:(BOOL)shouldForce NS_AVAILABLE(10_5, 2_0);
// 失败时想要查看原因使用下面的接口.
+ (BOOL)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error NS_AVAILABLE(10_5, 2_0);

/** 删除文件(夹)
 *
 * 会先检查目标路径是否存在
 *
 * @param path 文件(夹)全路径
 *
 * @return 复制成功 YES / 否则 NO
 */
+ (BOOL)removeItemAtPath:(NSString *)path NS_AVAILABLE(10_5, 2_0);

// 失败时想要查看原因使用下面的接口.
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error NS_AVAILABLE(10_5, 2_0);

/** 扩展名转小写
 *
 * @param path 文件全路径
 *
 * @return 扩展名转为小写后的文件全路径
 */
+ (NSString *)lowercaseExtensionForPath:(NSString *)path;

#pragma mark write

#pragma mark read
typedef void (^WYReadBlock)(uint8_t *buf, long long offset, NSUInteger length, int *realReadLength);

/** 计算文件分块数据
 *
 * @param path 文件全路径
 * @param blockSize 每个分块大小
 *
 * @return 文件分块信息
 */
+ (NSDictionary *)calcBlocksOfFile:(NSString *)path withBlockSize:(NSInteger)blockSize;
/** 获取块数据
 *
 * @param path 文件全路径
 * @param offset 块起始位置
 * @param size 块待读取大小
 *
 * @return 文件分块信息
 */
+ (NSData *)readDataOfFile:(NSString *)path fromOffset:(long long)offset size:(int)size;

/** 计算文件分块数据
 *
 * @param blockSize 每个分块大小
 * @param readBlock 读取文件, 由调用者实现
 *
 * @return 文件分块信息
 */
+ (NSDictionary *)calcBlocksWithSize:(NSInteger)blockSize usingReadBlock:(WYReadBlock)readBlock;
/** 获取块数据
 *
 * @param offset 块起始位置
 * @param size 块待读取大小
 * @param readBlock 读取文件, 由调用者实现
 *
 * @return 文件分块信息
 */
+ (NSData *)readDataFromOffset:(long long)offset size:(int)size usingReadBlock:(WYReadBlock)readBlock;

@end

#pragma mark - C Function API

/** 以下代码作为[WYFileManager同名类方法]的C函数版
 * 1. 不太频繁的处理，使用推荐使用同名类方法(OC方式)
 * 2. 大量循环，频繁调用，使用C的方式提高调用效率
 * 3. 只能有限地略减少调用开销
 * 4. 参数及返回值参照同名类方法
 */
