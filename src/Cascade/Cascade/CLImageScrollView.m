//
//  CLImageScrollView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-07.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLImageScrollView.h"
#import "CLImageTilingView.h"

@implementation CLImageScrollView
@synthesize index;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;        
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [imageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
    
    if ([imageView isKindOfClass:[CLImageTilingView class]]) {
        // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
        // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
        // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
        imageView.contentScaleFactor = 1.0;
    }
}

#pragma mark -
#pragma mark UIScrollView delegate methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)displayImage:(UIImage *)image
{
    // clear the previous imageView
    [imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    
    [self configureForImageSize:[image size]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)configureForImageSize:(CGSize)imageSize 
{
    CGSize boundsSize = [self bounds].size;
    
    // set up our content size and min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.contentSize = imageSize;
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;  // start out with the content fully visible
}

@end
