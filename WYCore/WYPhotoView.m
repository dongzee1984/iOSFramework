//
//  FGalleryPhotoView.m
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import "WYPhotoView.h"
#ifndef LOG_THIS_FILE
#define LOG_THIS_FILE 0
#endif

@interface WYPhotoView (Private)
- (UIImage*)createHighlightImageWithFrame:(CGRect)rect;
- (void)killActivityIndicator;
- (void)startTapTimer;
- (void)stopTapTimer;
@end



@implementation WYPhotoView
@synthesize photoDelegate;
@synthesize imageView;
@synthesize highLightedImageView;
@synthesize activity = _activity;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	self.userInteractionEnabled = YES;
	self.clipsToBounds = YES;
	self.delegate = self;
	self.contentMode = UIViewContentModeCenter;
	self.maximumZoomScale = 3.0;
	self.minimumZoomScale = 1.0;
	self.decelerationRate = .85;
	self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
#if LOG_THIS_FILE
    self.backgroundColor = [UIColor yellowColor];
#endif
	// create the image view
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:imageView];
    
    highLightedImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
	highLightedImageView.contentMode = UIViewContentModeScaleAspectFit;
    highLightedImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:highLightedImageView];
    highLightedImageView.hidden = YES;
	
	// create an activity inidicator
	_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[self addSubview:_activity];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetZoom) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	
	return self;
}

- (void)resetZoom
{
	_isZoomed = NO;
	[self stopTapTimer];
	[self setZoomScale:self.minimumZoomScale animated:NO];
	[self zoomToRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) animated:NO];
	self.contentSize = CGSizeMake(self.frame.size.width * self.zoomScale, self.frame.size.height * self.zoomScale );
}

- (void)setFrame:(CGRect)theFrame
{
	// store position of the image view if we're scaled or panned so we can stay at that point
	CGPoint imagePoint = imageView.frame.origin;
	
	[super setFrame:theFrame];
	
	// update content size
	self.contentSize = CGSizeMake(theFrame.size.width * self.zoomScale, theFrame.size.height * self.zoomScale );
	
	// resize image view and keep it proportional to the current zoom scale
	imageView.frame = CGRectMake( imagePoint.x, imagePoint.y, theFrame.size.width * self.zoomScale, theFrame.size.height * self.zoomScale);
	highLightedImageView.frame = imageView.frame;
	
	// center the activity indicator
	[_activity setCenter:CGPointMake(theFrame.size.width * .5, theFrame.size.height * .5)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	
	if (touch.tapCount == 2) {
		[self stopTapTimer];
		
		if( _isZoomed ) 
		{
			_isZoomed = NO;
			[self setZoomScale:self.minimumZoomScale animated:YES];
		}
		else {
			
			_isZoomed = YES;
			
			// define a rect to zoom to. 
			CGPoint touchCenter = [touch locationInView:self];
			CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale, self.frame.size.height / self.maximumZoomScale );
			CGRect zoomRect = CGRectMake( touchCenter.x - zoomRectSize.width * .5, touchCenter.y - zoomRectSize.height * .5, zoomRectSize.width, zoomRectSize.height );
			
			// correct too far left
			if( zoomRect.origin.x < 0 )
				zoomRect = CGRectMake(0, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far up
			if( zoomRect.origin.y < 0 )
				zoomRect = CGRectMake(zoomRect.origin.x, 0, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far right
			if( zoomRect.origin.x + zoomRect.size.width > self.frame.size.width )
				zoomRect = CGRectMake(self.frame.size.width - zoomRect.size.width, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far down
			if( zoomRect.origin.y + zoomRect.size.height > self.frame.size.height )
				zoomRect = CGRectMake( zoomRect.origin.x, self.frame.size.height - zoomRect.size.height, zoomRect.size.width, zoomRect.size.height );
			
			// zoom to it.
			[self zoomToRect:zoomRect animated:YES];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[event allTouches] count] == 1 ) {
		UITouch *touch = [[event allTouches] anyObject];
		if( touch.tapCount == 1 ) {
			
			if(_tapTimer ) [self stopTapTimer];
			[self startTapTimer];
		}
	}
}

- (void)startTapTimer
{
	_tapTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:.3] interval:.5 target:self selector:@selector(handleTap) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:_tapTimer forMode:NSDefaultRunLoopMode];
	
}
- (void)stopTapTimer
{
	if([_tapTimer isValid])
		[_tapTimer invalidate];
	
	[_tapTimer release];
	_tapTimer = nil;
}

- (void)handleTap
{
	// tell the controller
	if([photoDelegate respondsToSelector:@selector(didTapPhotoView:)])
		[photoDelegate didTapPhotoView:self];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	if( self.zoomScale == self.minimumZoomScale ) _isZoomed = NO;
	else _isZoomed = YES;
}


- (void)killActivityIndicator
{
	[_activity stopAnimating];
	[_activity removeFromSuperview];
	[_activity release];
	_activity = nil;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
	[self stopTapTimer];

	[self killActivityIndicator];
	
	[imageView release];
	imageView = nil;
    [highLightedImageView release];
	highLightedImageView = nil;
    [super dealloc];
}

- (UIImage *)image
{
    return imageView.image;
}
- (void)setImage:(UIImage *)image
{
    imageView.image = image;
}

- (UIImage *)highLightedImage
{
    return highLightedImageView.image;
}
- (void)setHighLightedImage:(UIImage *)image
{
    highLightedImageView.image = image;
}
- (void)hideHighLightedImageView:(BOOL)hidden
{
    highLightedImageView.hidden = hidden;
    
    if (hidden) {
        highLightedImageView.image = nil;
    }
}
@end
