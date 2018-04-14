//
//  WYBase.h
//  WYCore
//
//  Created by wanglidong on 13-4-2.
//  Copyright (c) 2013年 wy. All rights reserved.
//
//  常用宏

#ifndef WYCore_WYBase_h
#define WYCore_WYBase_h

/******************************************************
 * 储存单位
 ******************************************************/
#define WY_STORAGE_ARY 1024                        // 进制
#define WY_STORAGE_KB 1024                         // 1KB
#define WY_STORAGE_MB (1024 * 1024)                // 1MB
#define WY_STORAGE_GB (1024 * 1024 * 1024)         // 1GB


/******************************************************
 * 时间单位
 ******************************************************/
#define WY_TIMEINTERVAL_MIN 60.0                   // 1min
#define WY_TIMEINTERVAL_HOUR (60.0 * 60.0)         // 1h
#define WY_TIMEINTERVAL_DAY (60.0 * 60.0 * 24.0)   // 1day

/******************************************************
 * 扩展名
 ******************************************************/
FOUNDATION_EXPORT NSString *const WYExtensionTypePNG;
FOUNDATION_EXPORT NSString *const WYExtensionTypeJPEG;
FOUNDATION_EXPORT NSString *const WYExtensionTypeJPG;

/******************************************************
 * 识别设备
 ******************************************************/
#ifndef IS_PAD
#define IS_PAD() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#endif
#ifndef IS_PHONE
#define IS_PHONE() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#endif
#ifndef IS_RETINA
#define IS_RETINA() ([UIScreen instancesRespondToSelector:@selector(scale)] ? ([[UIScreen mainScreen] scale] == 2.0) : NO)
#endif

// 根据状态栏判断方向
#ifndef IS_PORTRAIT_SB
#define IS_PORTRAIT_SB() (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
#endif
#ifndef IS_LANDSCAPE_SB
#define IS_LANDSCAPE_SB() (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
#endif

//常规动画播放时间，按系统控件动画时间0.3s
#define WY_SYS_ANIM_DURATION 0.3

/******************************************************
 * 工具宏 : 数学
 ******************************************************/
//交换两个数（类型任意）
#ifndef SWAP
#define SWAP(A,B) ({ __typeof__(*(A)) __t = (*(A)); *A = *B; *B = __t; })
#endif


/******************************************************
 * 工具宏 : UI
 ******************************************************/
// RGB模式的UIColor定义
//   r,g,b[0,1]
#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1.0]
#endif
//   原值, r,g,b[0,255.0], 需要除以255.0
#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#endif
//   16进制
#define RGB_HEX(v) [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0 blue:((float)(v & 0xFF))/255.0 alpha:1.0]

// 文件末尾
#endif
