//
//  WYString.m
//  WYCore
//
//  Created by wanglidong on 13-5-3.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYString.h"
#import "WYBase.h"

// 字节转字符串
#define SizeFormat_B		@"%0.0fB"
#define SizeFormat_KB		@"%0.0fKB"
#define SizeFormat_MB		@"%0.1fMB"
#define SizeFormat_GB		@"%0.1fGB"

char strToChar(char a, char b)
{
    char encoder[3] = {'\0','\0','\0'};
    encoder[0] = a;
    encoder[1] = b;
    return (char) strtol(encoder,NULL,16);
}

@implementation WYString

#pragma mark - NSString

+ (NSInteger)firstIndexOfChar:(unichar)ch inString:(NSString *)string
{
    for(NSInteger i = 0; i < string.length; ++i)
    {
        if(ch == [string characterAtIndex:i])
        {
            return i;
        }
    }
    return -1; // 没找到
}

+ (NSInteger)lastIndexOfChar:(unichar)ch inString:(NSString *)string
{
    for(NSInteger i = string.length - 1; i >= 0; --i)
    {
        if(ch == [string characterAtIndex:i])
        {
            return i;
        }
    }
    
    return -1; // 没找到
}

+ (void)decodeHexString:(NSString *)string toBytes:(unsigned char *)bytes
{
    const char *cstring = [string cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char *index = bytes;
    
    while ((*cstring) && (*(cstring +1))) {
        
        *index = strToChar(*cstring, *(cstring + 1));
        ++index;
        cstring += 2;
    }
    *index = '\0';
}

+ (NSString *)subUTF8String:(NSString *)string maxLength:(NSUInteger)maxLength
{
    if (string.length <= 0 || maxLength <= 0) {
        return nil;
    }
    
    NSMutableString *r = [NSMutableString string];
    NSUInteger i = 0, bytesCount = 0;
    NSUInteger len = string.length;
    
    while (bytesCount <= maxLength && i < len) {
        
        unichar uc = [string characterAtIndex:i];
        
        bytesCount += isascii(uc) ? 1 : 3;
        
        if (bytesCount > maxLength) {
            break;
        }
        
        [r appendFormat:@"%C",uc]; // 略快
        //        [r appendString:[NSString stringWithCharacters:&uc length:1]];
        
        ++i;
    }
    
    return r;
}

+ (NSString *)subString:(NSString *)string from:(NSString *)fromString to:(NSString *)toString
{
    if(self ==nil) return nil;
    
    NSMutableString* str = [[[NSMutableString alloc]initWithString:string] autorelease];
    
    if(nil != toString)
    {
        NSRange range = [string rangeOfString:toString];
        int location = range.location;
        int len = range.length;
        
        //没找到toString
        if (len <= 0) {
            return nil;
        }
        //删除toString及其后面
        NSInteger length = [str length];
        [str deleteCharactersInRange:NSMakeRange(location,length-location)];
    }
    
    if(nil != fromString)
    {
        NSRange range = [string rangeOfString:fromString];
        int location = range.location;
        int len = range.length;
        
        //没找到fromString
        if (len <= 0) {
            return nil;
        }
        //删除fromString及其前面
        [str deleteCharactersInRange:NSMakeRange(0,location+len)];
    }
    
    return str;
}

+ (NSString *)URLEncodedUTF8String:(NSString *)string
{
	return [self URLEncodedString:string withCFStringEncoding:kCFStringEncodingUTF8];
}

+ (NSString *)URLEncodedString:(NSString *)string withCFStringEncoding:(CFStringEncoding)encoding
{
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[string mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding) autorelease];
}

+ (NSString *)absolutePath:(NSString *)string
{
    //convert path  like : file://... to /a/...
    return ([string isAbsolutePath] ? string : [[NSURL URLWithString:string] relativePath]);
}

#pragma mark convert to NSString
+ (NSString *)sortQueryParams:(NSDictionary *)params urlEncode:(BOOL)shouldUrlEncode
{
    if([params count] <= 0) return nil;
    NSMutableDictionary *encodedParameters = [NSMutableDictionary dictionary];
    if(shouldUrlEncode)
    {
        for(NSString *key in params) {
            [encodedParameters setObject:[self URLEncodedUTF8String:[params objectForKey:key]] forKey:[self URLEncodedUTF8String:key]];
        }
    }
    else
    {
        [encodedParameters setDictionary:params];
    }
    
    NSArray *sortedKeys = [[encodedParameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *parameterArray = [NSMutableArray array];
    for(NSString *key in sortedKeys) {
        
        [parameterArray addObject:[NSString stringWithFormat:@"%@=%@", key, [encodedParameters objectForKey:key]]];
    }
    
    if(shouldUrlEncode)
    {
        return [self URLEncodedUTF8String:[parameterArray componentsJoinedByString:@"&"]];
    }
    else
    {
        return [parameterArray componentsJoinedByString:@"&"];
    }
}

+ (NSDictionary *)parseQueryString:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[pairs count]];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

+ (NSString *)stringWithLongLong:(long long)value
{
    return [NSString stringWithFormat:@"%lld",value];
}

+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
    return [[[NSString alloc]initWithData:data encoding:encoding]autorelease];
}
+ (NSString *)stringWithUTF8Data:(NSData *)data
{
    return [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format
{
    if (!date) {
        return nil;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];
    NSString *fixString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return fixString;
}
+ (NSString *)stringWithNowFormat:(NSString *)format
{
    return [self stringWithDate:[NSDate date] format:format];
}
+ (NSString *)stringWithNowTimeInteval
{
    return [NSString stringWithFormat:@"%0.0f",[[NSDate date] timeIntervalSince1970]];
}
@end

NSString* stringWithSizeX(double size)
{
    if(size < WY_STORAGE_ARY)
    {
        return [NSString stringWithFormat:SizeFormat_KB,1.0f];
    }
    
    NSString* strFileInfoFormat = nil;
    size /= WY_STORAGE_ARY;
    if (size < WY_STORAGE_ARY)
    {
        strFileInfoFormat = SizeFormat_KB;
    }
    else
    {
        size /= WY_STORAGE_ARY;
        if (size < WY_STORAGE_ARY)
            strFileInfoFormat = SizeFormat_MB;
        else
        {
            size /= WY_STORAGE_ARY;
            strFileInfoFormat = SizeFormat_GB;
        }
    }
    
    return [NSString stringWithFormat:strFileInfoFormat,size];
}

NSString* stringWithSize(double size)
{
    if(size <= 0.0f)
    {
        return [NSString stringWithFormat:SizeFormat_KB,0.0f];
    }
    
    return stringWithSizeX(size);
}

NSString* stringWithSizeAvoidZero(double size)
{
    if(size <= 0.0f)
    {
        return @"-- --";
    }

    return stringWithSizeX(size);
}

NSString* stringWithSizeAllowB(double size)
{
    if(size <= 0.0f)
    {
        return [NSString stringWithFormat:SizeFormat_KB,0.0f];
    }
    else if(size < WY_STORAGE_ARY)
    {
        return [NSString stringWithFormat:SizeFormat_B,size];
    }

    return stringWithSizeX(size);
}

/** stringWithUTF8String 效率太差
 
 NSUInteger maxLength = 440;
 NSRange rg = NSMakeRange(0, [string length]);
 int size = [string maximumLengthOfBytesUsingEncoding:NSUTF8StringEncoding];
 char *buffer = malloc(size);
 memset(buffer, 0, size);
 
 [string getBytes:buffer maxLength:maxLength usedLength:NULL encoding:NSUTF8StringEncoding options:NSStringEncodingConversionExternalRepresentation range:rg remainingRange:NULL];
 
 NSString *r = [NSString stringWithUTF8String:buffer];
 
 NSLog(@"%@ len [%d] lengthOfBytesUsingEncoding[%d]",r,[r length],[r lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
 free(buffer);
 
 */
