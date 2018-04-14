//
//  WYAsset.m
//  WYCore
//
//  Created by wanglidong on 13-6-5.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYAsset.h"
#import "WYString.h"
#import "WYBase.h"
#import "WYFileManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "WYDigest.h"
#import "WYNSObjectCategory.h"

NSString *const WYAssetPropertyId = @"id=";
NSString *const WYAssetPropertyExt = @"ext=";
NSString *const WYAssetPropertySplit = @"&";

@implementation WYAsset

+ (NSString *)persistentId:(ALAsset *)asset
{
    NSString *fullname = [self urlString:asset];
    //    NSLog(@"filename %@",[[self defaultRepresentation] filename]);
    if(fullname)
    {
        NSString *name = [WYString subString:fullname from:WYAssetPropertyId to:WYAssetPropertySplit];
        NSString *ext = [WYString subString:fullname from:WYAssetPropertyExt to:nil];

        return [NSString stringWithFormat:@"%@.%@",name,ext];
    }

    return nil;
}

+ (NSString *)persistentIdWithURL:(NSURL *)assetURL
{
    if(!assetURL) return nil;
    
    NSString *strUrl = [assetURL absoluteString];
    if(!strUrl) return nil;
    
    NSString *name = [WYString subString:strUrl from:WYAssetPropertyId to:WYAssetPropertySplit];
    NSString *ext = [WYString subString:strUrl from:WYAssetPropertyExt to:nil];
    
    return [NSString stringWithFormat:@"%@.%@",name,ext];
}

+ (NSString *)ext:(ALAsset *)asset
{
    NSString *fullname = [self urlString:asset];
    if(fullname)
    {
        return [WYString subString:fullname from:WYAssetPropertyExt to:nil];
    }

    return nil;
}

+ (NSString *)urlString:(ALAsset *)asset
{
    id urls = [asset valueForProperty:ALAssetPropertyURLs];
    if(urls == nil || urls == [NSNull null])
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

+ (BOOL)isPNG:(ALAsset *)asset
{
    id urls = [asset valueForProperty:ALAssetPropertyURLs];
    if(urls==nil || urls==[NSNull null])
    {
        return NO;
    }
    
    NSArray *allKeys = [urls allKeys];
    if([allKeys count] == 0) return NO;
    
    id key = [allKeys objectAtIndex:0];
    
    return [key isEqualToString:@"public.png"];
}

+ (BOOL)saveAsset:(ALAsset *)asset toFile:(NSString *)filename
{
    if (asset == nil)
    {
        return NO;
    }
    
    @autoreleasepool {
        int offset = 0;
        int lengthParameter = 64 * WY_STORAGE_KB; //64KB every read op.
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        
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

+ (BOOL)saveImageAsset:(ALAsset *)asset toFile:(NSString *)filename withQuality:(float)quality
{
    
    @autoreleasepool {
        [WYFileManager newFolder:[filename stringByDeletingLastPathComponent] force:NO];
        
        NSString *ext = [WYFileManager lowercaseExtensionForPath:filename];
        //不对png和原图执行压缩
        if(quality >= 1.0 || [WYExtensionTypePNG isEqualToString:ext])
        {
            return [self saveAsset:asset toFile:filename];
        }
        
        NSString *tmp = [filename stringByAppendingPathExtension:@"saving"];
        if(![self saveAsset:asset toFile:tmp])
        {
            return NO;
        }
        UIImage *originalImage = [UIImage imageWithContentsOfFile:tmp];
        
        NSData *data = nil;
        if([WYExtensionTypePNG isEqualToString:ext])
        {
            data = UIImagePNGRepresentation(originalImage);
        }
        else
        {
            data = UIImageJPEGRepresentation(originalImage,quality);
        }
        
        BOOL save = [data writeToFile:filename atomically:YES];
        
        [[NSFileManager defaultManager] removeItemAtPath:tmp error:nil];
     
        return save;
    }
}

//此处因为有异步操作，所以使用信号量等待结束。
+ (ALAsset *)assetForURL:(NSString *)strAsseturl
{
    __block ALAsset *_asset = nil;
    
    @autoreleasepool {

        ALAssetsLibrary * library = [[self defaultLibrary]retain];
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

+ (NSDictionary *)calcBlocksOfAsset:(ALAsset *)asset withBlockSize:(NSInteger)blockSize
{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    if (!rep)
        return nil;

    return [WYFileManager calcBlocksWithSize:blockSize usingReadBlock:^(uint8_t *buf, long long offset, NSUInteger length, int *realReadLength) {
        *realReadLength = [rep getBytes:buf fromOffset:offset length:length error:NULL];
    }];
}

+ (NSData *)readDataOfAsset:(ALAsset *)asset fromOffset:(long long)offset size:(int)size
{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    if (!rep)
        return nil;
    return [WYFileManager readDataFromOffset:offset size:size usingReadBlock:^(uint8_t *buf, long long offset, NSUInteger length, int *realReadLength) {
        *realReadLength = [rep getBytes:buf fromOffset:offset length:length error:NULL];
    }];
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

#pragma mark method of ALAssetsLibrary
+ (void)saveImageDataToPhotosAlbum:(NSData *)data completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
{
    ALAssetsLibrary *library = [WYAsset defaultLibrary];
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        completionBlock(assetURL,error);
    }];
}
+ (void)saveImageDataToPhotosAlbum:(NSData *)data metadata:(NSDictionary *)metadata completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock
{
    [self saveImageDataToPhotosAlbum:data completionBlock:completionBlock];
}

@end


