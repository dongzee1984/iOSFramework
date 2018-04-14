//
//  WYDevice.m
//  WYCore
//
//  Created by wanglidong on 13-4-27.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYDevice.h"
#import "OpenUDID.h"
#import "SystemConfiguration/SCNetworkReachability.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation WYDevice

+ (NSString *)openUDID
{
    return [OpenUDID value];
}

+ (NSString *)name
{
    return [[UIDevice currentDevice] name];
}

+ (float)batteryLevel
{
    return [[UIDevice currentDevice] batteryLevel];
}

+ (UIDeviceBatteryState)batteryState
{
    return [[UIDevice currentDevice] batteryState];
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)platformString
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad2";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])         return @"iPhone Simulator";
    return platform==nil?@"unknown":platform;
}

+ (NSString *)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (BOOL)cameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)frontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

@end

BOOL isNetworkReachabel()
{
	BOOL isReachabel = NO;
	
	struct sockaddr addr = {0};
	addr.sa_len = sizeof(addr);
	addr.sa_family = AF_INET;
	SCNetworkReachabilityRef defaultRoute = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &addr);
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(defaultRoute, &flags))
	{
		isReachabel = flags & kSCNetworkFlagsReachable;
	}
	CFRelease(defaultRoute);
	
	return isReachabel;
}


#if 0
BOOL isUsingWifi()
{
	BOOL isUsingWifi = NO;
	struct sockaddr addr = {0};
	addr.sa_len = sizeof(addr);
	addr.sa_family = AF_INET;
	SCNetworkReachabilityRef defaultRoute = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &addr);
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(defaultRoute, &flags))
	{
		BOOL isReachabel = (flags & kSCNetworkFlagsReachable) != 0;
		BOOL needsConnection = (flags & kSCNetworkFlagsConnectionRequired) != 0;
		BOOL isWWAN = (flags & kSCNetworkReachabilityFlagsIsWWAN) != 0;		// 运营商网络，非wifi
		isUsingWifi = isReachabel && !needsConnection && !isWWAN;
	}
	CFRelease(defaultRoute);

	return isUsingWifi;
}

BOOL isUsingWWAN()
{
	BOOL isUsingWWAN = NO;
	struct sockaddr addr = {0};
	addr.sa_len = sizeof(addr);
	addr.sa_family = AF_INET;
	SCNetworkReachabilityRef defaultRoute = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &addr);
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(defaultRoute, &flags))
	{
		BOOL isReachabel = (flags & kSCNetworkFlagsReachable) != 0;
		BOOL needsConnection = (flags & kSCNetworkFlagsConnectionRequired) != 0;
		BOOL isWWAN = (flags & kSCNetworkReachabilityFlagsIsWWAN) != 0;		// 运营商网络，非wifi
		isUsingWWAN = isReachabel && !needsConnection && isWWAN;
	}
	CFRelease(defaultRoute);

	return isUsingWWAN;
}
#endif