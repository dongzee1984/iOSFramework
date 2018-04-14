//
//  ALAsset+WYCategory.m
//  WYCore
//
//  Created by wanglidong on 13-6-5.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "ALAsset+WYCategory.h"
#import <WYFileManager.h>
#import "WYString.h"
#import "WYBase.h"

@implementation ALAsset (WYCategory)

NSString *const WYALAssetPropertyId = @"id=";
NSString *const WYALAssetPropertyExt = @"ext=";
NSString *const WYALAssetPropertySplit = @"&";
//ALAsset - Type:Photo, URLs:assets-library://asset/asset.JPG?id=9C5EF6C3-0E1C-4F05-B592-CED2203EFE0F&ext=JPG

+ (NSString *)getAssetId:(NSURL *)assetURL
{
    if(!assetURL) return nil;
    
    NSString *strUrl = [assetURL absoluteString];
    if(!strUrl) return nil;
    
    NSString *name = [WYString subString:strUrl from:WYALAssetPropertyId to:WYALAssetPropertySplit];
    NSString *ext = [WYString subString:strUrl from:WYALAssetPropertyExt to:nil];
    NSString *realurl  = [NSString stringWithFormat:@"%@.%@",name,ext];
    
    return realurl;
}

- (NSString *)getAssetId
{
    NSString *fullname = [self getAssetUrlString];
    //    NSLog(@"filename %@",[[self defaultRepresentation] filename]);
    if(fullname==nil)
    {
        return nil;
    }
    NSString *name = [WYString subString:fullname from:WYALAssetPropertyId to:WYALAssetPropertySplit];
    NSString *ext = [WYString subString:fullname from:WYALAssetPropertyExt to:nil];

    NSString *realurl  = [NSString stringWithFormat:@"%@.%@",name,ext];
    
    return realurl;
}

- (NSString *)getAssetExt
{
    NSString *fullname = [self getAssetUrlString];
    if(fullname==nil)
    {
        return nil;
    }
    NSString *ext = [WYString subString:fullname from:WYALAssetPropertyExt to:nil];
    return ext;
}

- (NSString *)getAssetUrlString
{
    
    id urls = [self valueForProperty:ALAssetPropertyURLs];
    if(urls==nil || urls==[NSNull null])
    {
        return nil;
    }
    
    NSArray *allKeys = [urls allKeys];
    if([allKeys count] == 0) return nil;
    
    id key = [allKeys objectAtIndex:0];
    NSURL *url = [urls valueForKey:key];
    NSString *fullname = [url absoluteString];
    return fullname;
}

- (BOOL)isPng
{
    id urls = [self valueForProperty:ALAssetPropertyURLs];
    if(urls==nil || urls==[NSNull null])
    {
        return NO;
    }
    
    NSArray *allKeys = [urls allKeys];
    if([allKeys count] == 0) return NO;
    
    id key = [allKeys objectAtIndex:0];
    
    return [key isEqualToString:@"public.png"];
}



- (BOOL)saveToFile:(NSString *)filename
{
    ALAsset *_asset = self;
    if (_asset == nil)
    {
        return NO;
    }
    
    @autoreleasepool {
        int offset = 0;
        int lengthParameter = 64 * WY_STORAGE_KB; //64KB every read op.
        ALAssetRepresentation *rep = [_asset defaultRepresentation];
        
        [[NSFileManager defaultManager] createFileAtPath:filename
                                                contents:nil
                                              attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
        
        while (1) {
            @autoreleasepool {
                Byte * buffer = (Byte*)malloc(lengthParameter);
                NSError* err;
                int read = [rep getBytes:buffer
                              fromOffset:offset
                                  length:lengthParameter
                                   error:&err];
                NSData* dataReturn = [NSData dataWithBytes:buffer length:read];
                offset += read;
                free(buffer);
                [fileHandle writeData:dataReturn];
                if (read < lengthParameter)
                    break;
            }
        }
        [fileHandle closeFile];
    }
    
    return YES;
}

- (BOOL)savePhotoFile:(NSString *)filename withQuality:(float)quality
{
    @autoreleasepool {
        [WYFileManager newFolder:[filename stringByDeletingLastPathComponent] force:NO];
        
        NSString *ext = [WYFileManager lowercaseExtensionForPath:filename];
        //不对png和原图执行压缩
        if(quality >= 1.0 || [ext isEqualToString:WYExtensionTypePNG])
        {
            return [self saveToFile:filename];
        }
        
        NSString *tmp = [filename stringByAppendingPathExtension:@"saving"];
        if(![self saveToFile:tmp])
        {
            return NO;
        }
        UIImage* originalImage = [UIImage imageWithContentsOfFile:tmp];
        
        NSData *data = nil;
        if([ext isEqualToString:WYExtensionTypePNG])
        {
            data = UIImagePNGRepresentation(originalImage);
        }
        else
        {
            data = UIImageJPEGRepresentation(originalImage,quality);
        }
        
        BOOL save = [data writeToFile:filename atomically:YES];
        
        [[NSFileManager defaultManager] removeItemAtPath:tmp error:nil];
        //#ifdef _DEBUG
        //        [self printFilesAtPath:[filename stringByDeletingLastPathComponent]];
        //#endif
        return save;
    }
}

//此处因为有异步操作，所以使用信号量等待结束。
+ (ALAsset *)assetForURL:(NSString *)strAsseturl
{
    __block ALAsset *_asset = nil;
    
    @autoreleasepool {
        
        
        //        ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init]autorelease];
        ALAssetsLibrary * library = [[ALAsset defaultLibrary]retain];
        NSURL *assetURL = [NSURL URLWithString:strAsseturl];
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                _asset = [asset retain];
                dispatch_semaphore_signal(sema);
            } failureBlock:^(NSError *error) {
                dispatch_semaphore_signal(sema);
            }];
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
        [library release];
    }
    
    return [_asset autorelease];
    
}

#pragma mark - single shared instance of ALAssetsLibrary
//tricky one from apple reference: The lifetimes of objects you get back from a library instance are tied to the lifetime of the library instance.
static dispatch_once_t WYALAsset_pred = 0;
static ALAssetsLibrary *library = nil;
+ (ALAssetsLibrary *)defaultLibrary
{
    dispatch_once(&WYALAsset_pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

+ (void)terminatedeDefaultLibrary
{
    [library release], library = nil;
    WYALAsset_pred = 0;
}

+ (void)enableCategory
{
    
}

@end
