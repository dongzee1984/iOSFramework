//
//  WYDate.m
//  WYCore
//
//  Created by wanglidong on 13-5-9.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYDate.h"
#import "WYBase.h"

@implementation WYDate

+ (NSDate *)dateWithString:(NSString *)string
{
    if (!string) {
        return nil;
    }

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale* locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    [dateFormatter release];
    return date;
}

+ (BOOL)isToday:(NSDate *)date withTimeZoneName:(NSString *)tzName
{
    return [self isToday:date withTimeZoneName:tzName defaultValue:NO];
}
+ (BOOL)isToday:(NSDate *)date withTimeZoneName:(NSString *)tzName defaultValue:(BOOL)defaultValue
{
    //时间未设置时，默认为今天
    if(date == nil) return defaultValue;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:tzName]];
    
    NSDate *now = [NSDate date];
    
    NSUInteger dateUnitFlags = 	NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *today = [cal components:dateUnitFlags fromDate:now];
    NSDateComponents *modifyTime = [cal components:dateUnitFlags fromDate:date];
    
    return (today.day == modifyTime.day);
}
+ (NSTimeInterval)todayZerowithTimeZoneName:(NSString *)tzName
{
    NSDate *now = [NSDate date];
    
    NSUInteger dateUnitFlags = 	NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone timeZoneWithName:tzName]];
    NSDateComponents *today = [cal components:dateUnitFlags fromDate:now];
    [today setHour:0];
    [today setMinute:0];
    [today setSecond:0];
    return [[cal dateFromComponents:today] timeIntervalSince1970];
    
//    return [now timeIntervalSince1970] - today.hour * WY_TIMEINTERVAL_HOUR - today.minute * WY_TIMEINTERVAL_MIN - today.second;
}
+ (NSTimeInterval)timeInterval
{
    return [[NSDate date] timeIntervalSince1970];
}
@end
