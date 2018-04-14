//
//  WYImage.m
//  WYCore
//
//  Created by wanglidong on 13-5-10.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "WYImage.h"
#import "WYDevice.h"
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageDestination.h>

#define LOG_THIS_FILE 0

@implementation WYImage
+ (UIImage *)fill:(UIImage *)image inRect:(CGRect)rect
{
    if(IS_IOS_4_0_OR_GRATER())
    {
        UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(rect.size);
    }
    
    [image drawAsPatternInRect:rect];

    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return scaledImage;
}

+ (UIImage *)fill:(UIImage *)image withRect:(CGRect)rect
{
    if(IS_IOS_4_0_OR_GRATER())
    {
        UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(rect.size);
    }

    [image drawInRect:CGRectMake(rect.origin.x, rect.origin.y, image.size.width, image.size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return scaledImage;
}

+ (UIImage *)transparentImage:(UIImage *)image
{
    if(IS_IOS_4_0_OR_GRATER())
    {
        UIGraphicsBeginImageContextWithOptions(image.size,NO,0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(image.size);
    }
    CGContextClearRect(UIGraphicsGetCurrentContext(),CGRectMake(0, 0, image.size.width, image.size.height));
    CGContextSetAlpha(UIGraphicsGetCurrentContext(),0.0);
    UIImage *tpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tpImage;
}

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
	
    if(IS_IOS_4_0_OR_GRATER())
    {
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return scaledImage;
}

+ (UIImage *)scaleAspect:(UIImage *)image toSize:(CGSize)size
{
    CGSize oldSize = image.size;
	float scaleX = size.width / oldSize.width;
	float scaleY = size.height / oldSize.height;
	float scale = scaleX < scaleY ? scaleY : scaleX;
	CGSize newSize = CGSizeMake(oldSize.width * scale, oldSize.height * scale);
	
	return [WYImage scale:image toSize:newSize];
}

+ (UIImage *)rotationImage:(UIImage *)image orientation:(UIImageOrientation)orient
{
    // No-op if the orientation is already correct
    if (orient == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orient) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (orient) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(UIImage *)rotateImage:(UIImage *)image

{
    //    FSLog(@"%@", [NSDate date]);
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    //CGRect bounds = {0, 0, 0, 0};
    //CGFloat scaleRatio = 1;
    //CGFloat boundHeight = 0.0f;
    
    width = CGImageGetWidth(imgRef);
    height = CGImageGetHeight(imgRef);
    //bounds = CGRectMake(0, 0, width, height);
    //scaleRatio = 1;
    //boundHeight = bounds.size.height;
    
    
    UIImageOrientation orient = image.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformTranslate(transform, width / 2, height/ 2);
            transform = CGAffineTransformRotate(transform, M_PI);
            transform = CGAffineTransformTranslate(transform, -(width / 2), -(height/ 2));
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            break;
        case UIImageOrientationLeft: //EXIF = 6
            transform = CGAffineTransformTranslate(transform, 0, width);
            transform = CGAffineTransformRotate(transform, -(M_PI / 2));
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            break;
        case UIImageOrientationRight: //EXIF = 8
            transform = CGAffineTransformTranslate(transform, 0, width);
            transform = CGAffineTransformRotate(transform, -(M_PI / 2.0));
            break;
        default:
            
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    //CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imgRef);
    CGImageAlphaInfo alphaInfo = kCGImageAlphaNoneSkipLast;
    
	CGContextRef bitmap = nil;
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft || orient == UIImageOrientationLeftMirrored || orient == UIImageOrientationRightMirrored) {
        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imgRef), 4 * height, CGImageGetColorSpace(imgRef), alphaInfo);
        
        switch (orient) {
            case UIImageOrientationRight:
                break;
            case UIImageOrientationLeft:
                break;
            case UIImageOrientationRightMirrored:
                break;
            default:
                break;
        }
        
    }
    
    else {
        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imgRef), 4 * width, CGImageGetColorSpace(imgRef), alphaInfo);
        
        switch (orient) {
            case UIImageOrientationUp:
                break;
            case UIImageOrientationDown:
                break;
            default:
                break;
        }
        
    }
    
    CGContextConcatCTM(bitmap, transform);
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imgRef);
    
    //    FSLog(@"%@", [NSDate date]);
    
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [[UIImage alloc] initWithCGImage: ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return [result autorelease];
    //    return aImage;
    //    return imageCopy;  
}

+ (BOOL)saveImageData:(NSData *)data toFile:(NSString *)path withMeta:(NSDictionary *)meta
{
    @autoreleasepool {
        CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)data, NULL);
        
        CFStringRef UTI = CGImageSourceGetType(source); //this is the type of image (e.g., public.jpeg)
        
        NSMutableData *dest_data = [NSMutableData data];
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data,UTI,1,NULL);
        
        BOOL success = NO;
        if(!destination) {
#if LOG_THIS_FILE
            NSLog(@"***Could not create image destination ***");
#endif
        }
        else
        {
            //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
            CGImageDestinationAddImageFromSource(destination,source,0,(CFMutableDictionaryRef)meta);
            
            //tell the destination to write the image data and metadata into our data object.
            //It will return false if something goes wrong
            success = CGImageDestinationFinalize(destination);
            
            if(!success) {
#if LOG_THIS_FILE
                NSLog(@"***Could not create data from image destination ***");
#endif
            }
            else
            {
                //now we have the data ready to go, so do whatever you want with it
                //here we just write it to disk at the same path we were passed
                
                NSString *dataPath = [path stringByDeletingLastPathComponent];
                
                NSError *error;
                if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
                
                success = [dest_data writeToFile:path atomically:YES];
            }
        }
        
        //cleanup
        CFRelease(destination);
        CFRelease(source);
        
        return success;
    }
}

@end
