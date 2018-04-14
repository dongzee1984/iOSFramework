//
//  FGalleryPhotoView.h
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYPhotoViewDelegate;

@interface WYPhotoView : UIScrollView <UIScrollViewDelegate> {
	BOOL _isZoomed;
	NSTimer *_tapTimer;
}

@property (nonatomic,assign) id<WYPhotoViewDelegate> photoDelegate;
@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,readonly) UIImageView *highLightedImageView;
@property (nonatomic,readonly) UIActivityIndicatorView *activity;
@property (nonatomic,assign)UIImage *image;
@property (nonatomic,assign)UIImage *highLightedImage;

- (void)killActivityIndicator;

- (void)resetZoom;
- (void)hideHighLightedImageView:(BOOL)hidden;

@end



@protocol WYPhotoViewDelegate <NSObject>

// indicates single touch and allows controller repsond and go toggle fullscreen
- (void)didTapPhotoView:(WYPhotoView *)photoView;

@end

