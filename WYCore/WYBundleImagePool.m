//
//  WYBundleImagePool.m
//  WYCore
//
//  Created by wanglidong on 13-4-1.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYBundleImagePool.h"
#import "WYImage.h"

#ifndef LOG_THIS_FILE
#define LOG_THIS_FILE 0
#endif

#pragma mark - 
@interface WYBundleImagePool ()
{
    NSMutableDictionary *_interval;
}
@end

@implementation WYBundleImagePool

- (void)dealloc
{
#if LOG_THIS_FILE
    NSLog(@"%s ",__func__);
#endif
    [_interval release], _interval = nil;
    [super dealloc];
}

- (id)init
{
#if LOG_THIS_FILE
    NSLog(@"%s TARGET_IPHONE_SIMULATOR = %d",__func__,TARGET_IPHONE_SIMULATOR);
#endif
    self = [super init];
    
    _interval = [[NSMutableDictionary alloc]init];
    
    return self;
}

- (UIImage *)loadWithKey:(NSString *)key
{
    // 由系统来cache就行了
#if 1
    UIImage *image = [UIImage imageNamed:key];
#if LOG_THIS_FILE
    NSLog(@"%s load image[%@] %@ ",__func__,key,image);
#endif
    return image;
#else
    if(nil == key) return nil;
    
    UIImage *image = [_interval objectForKey:key];
    if(image)
    {
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] in pool ",__func__,key);
#endif
        return image;
    }
    image = [UIImage imageNamed:key];
    if(nil == image)
    {
        NSLog(@"%s load image[%@] fail !!! ",__func__,key);
    }
    else
    {
        [_interval setObject:image forKey:key];
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] size[%0.0f,%0.0f] from file ",__func__,key,image.size.width,image.size.height);
#endif
    }
    return image;
#endif
}

- (UIImage *)loadWithKey:(NSString *)key leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
    if(nil == key) return nil;
    
    UIImage *image = [_interval objectForKey:key];
    if(image)
    {
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] in pool ",__func__,key);
#endif
        return image;
    }
    image = [[UIImage imageNamed:key] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    if(nil == image)
    {
        NSLog(@"%s load image[%@] fail !!! ",__func__,key);
    }
    else
    {
        [_interval setObject:image forKey:key];
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] size[%0.0f,%0.0f] from file ",__func__,key,image.size.width,image.size.height);
#endif
    }
    return image;
}

- (UIImage *)loadWithKey:(NSString *)key inRect:(CGRect)rect
{
#if LOG_THIS_FILE
    NSLog(@"%@",NSStringFromCGRect(rect));
#endif
    
    if(nil == key) return nil;
    
    UIImage *image = [_interval objectForKey:key];
    if(image)
    {
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] in pool ",__func__,key);
#endif
        return image;
    }

    image = [UIImage imageNamed:key];
    image = [WYImage fill:image inRect:rect];

    if(nil == image)
    {
        NSLog(@"%s load image[%@] fail !!! ",__func__,key);
    }
    else
    {
        [_interval setObject:image forKey:key];
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] size[%0.0f,%0.0f] from file ",__func__,key,image.size.width,image.size.height);
#endif
    }
    return image;
}

- (UIImage *)loadBigImageWithKey:(NSString *)key
{
    if(nil == key) return nil;

    UIImage *image = [_interval objectForKey:key];
    if(image)
    {
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] in pool ",__func__,key);
#endif
        return image;
    }
    
    // 首次加载
    image = [self loadBigImageWithName:key];
    if(nil == image)
    {
        NSLog(@"%s load image[%@] fail !!! ",__func__,key);
    }
    else
    {
        [_interval setObject:image forKey:key];
#if LOG_THIS_FILE
        NSLog(@"%s load image[%@] size[%0.0f,%0.0f] from file ",__func__,key,image.size.width,image.size.height);
#endif
    }
    return image;
}

- (void)releaseBigImageWithKey:(NSString *)key
{
#if LOG_THIS_FILE
        UIImage *img = [_interval objectForKey:key];
        if(key)
        {
            [_interval removeObjectForKey:key];
        }
        
        if(getenv("NSZombieEnabled"))
        {
            if(strstr(object_getClassName(img),"_NSZombie_"))
            {
                NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                printf("%s <%s> 0000000000000000000000000000\n",__func__, object_getClassName(img));
                NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
            }
            else
            {
                NSLog(@"%@ retainCount is [%d]",img,[img retainCount]);
            }
        }
        else
        {
            NSLog(@"set NSZombieEnabled first");
        }
        
#else
        if(key)
        {
            [_interval removeObjectForKey:key];
        }
#endif
}

- (void)releaseBigImageWithKeys:(NSArray *)keys
{
    for(id key in keys)
    {
        [self releaseBigImageWithKey:key];
    }
}

/*
 * 释放全部图片
 */
- (void)releaseAllImages
{
    [_interval removeAllObjects];
}

- (UIImage *)loadBigImageWithName:(NSString *)name
{
    if(nil == name) return nil;

    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:[[name stringByDeletingPathExtension] stringByAppendingString:@"@2x"] ofType:[name pathExtension]];
//        NSLog(@"%s %@",__func__,path);
        return [UIImage imageWithContentsOfFile:path];
        
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
//        NSLog(@"%s %@",__func__,path);
        return [UIImage imageWithContentsOfFile:path];
    }
}

@end



#if 0

@interface WYBundleImageItem : NSObject

@property(nonatomic,assign)NSInteger refCount;
@property(nonatomic,retain)UIImage *image;

@end

@implementation WYBundleImageItem
- (void)dealloc
{
    self.image = nil;
    [super dealloc];
}

@end


@interface WYImage : UIImage

+ (WYImage *)imageWithContentsOfFile:(NSString *)name;

@end

@implementation WYImage

- (void)dealloc
{
    
    [super dealloc];
}

+ (WYImage *)imageWithContentsOfFile:(NSString *)name
{
    if(nil == name) return nil;
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:[[name stringByDeletingPathExtension] stringByAppendingString:@"@2x"] ofType:[name pathExtension]];
        
        return (WYImage *)[UIImage imageWithContentsOfFile:path];
        
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:[name pathExtension]];
        
        return (WYImage *)[UIImage imageWithContentsOfFile:path];
    }
}

@end

#endif