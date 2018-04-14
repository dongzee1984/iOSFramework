//
//  WYDevice.h
//  WYCore
//
//  Created by wanglidong on 13-4-27.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  设备信息类

#import <UIKit/UIKit.h>

@interface WYDevice : NSObject

/** openUDID
    40位
 */
+ (NSString *)openUDID;

/** 获取设备名
    e.g. "My iPhone"
 */
+ (NSString *)name;

/** 获取电量值
    e.g. 0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
 */
+ (float)batteryLevel;
/** 获取电源状态
 *
 * UIDeviceBatteryStateUnknown if monitoring disabled
 */
+ (UIDeviceBatteryState)batteryState;

/** 获取系统版本号
 e.g. @"4.0"
 */
+ (NSString *)systemVersion;

/** 获取设备信息
 e.g. @"iPhone4,1"
 */
+ (NSString *)platform;
/** 获取设备信息
 e.g. @"iPhone 4S"
 */
+ (NSString *)platformString;

/** 获取app版本
 e.g. @"1.0.0"
 */
+ (NSString *)appVersion;

/** 检查摄像头是否可用
 */
+ (BOOL)cameraAvailable;
/** 检查前置摄像头是否可用
 */
+ (BOOL)frontCameraAvailable;

@end

// 网络连通性
BOOL isNetworkReachabel();

#ifndef _WYDEVICE_H_

#define _WYDEVICE_H_ 1

//比较系统版本号
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_0	478.23
#endif
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_1 478.26
#endif
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_2 478.29
#endif
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_0 478.47
#endif
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_1 478.52
#endif
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_2 478.61
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_4_0
#define kCFCoreFoundationVersionNumber_iOS_4_0 550.32
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_4_1
#define kCFCoreFoundationVersionNumber_iOS_4_1 550.38
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_4_2
#define kCFCoreFoundationVersionNumber_iOS_4_2 550.52
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_4_3
#define kCFCoreFoundationVersionNumber_iOS_4_3 550.58
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#endif
#ifndef kCFCoreFoundationVersionNumber_iOS_5_1
#define kCFCoreFoundationVersionNumber_iOS_5_1 690.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 788.00
#endif

#define IS_IOS_5_0() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0 && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_1)
#define IS_IOS_5_0_OR_GRATER() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0)
#define IS_IOS_5_1_OR_GRATER() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_1)

#define IS_IOS_3_2_OR_GRATER() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2)

#define IS_IOS_4_2_OR_GRATER() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_2)

#define IS_IOS_6_0_OR_GRATER() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0)

#define IS_IOS_4_0_OR_GRATER() (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0)

#define IS_IOS_5_0_OR_SMALLER() (kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_5_0)

//是否支持跳转到设置
#define isOSSupportGotoSet() IS_IOS_5_0()
// 是否支持手势
#define isOSSupportGestures() IS_IOS_3_2_OR_GRATER()
// 是否支持打开方式
#define isOSSupportOpenWith() IS_IOS_3_2_OR_GRATER()

// file end
#endif
