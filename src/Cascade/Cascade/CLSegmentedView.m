//
//  CLSegmentedView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLSegmentedView.h"

@interface CLSegmentedView (Private)
- (void) setupViews;
- (void) updateRoundedCorners;
- (CGFloat) multiplePagesEffectWidth;
@end

@implementation CLSegmentedView

@synthesize footerView = _footerView;
@synthesize headerView = _headerView;
@synthesize contentView = _contentView;
@synthesize shadowWidth = _shadowWidth;
@synthesize viewSize = _viewSize;
@synthesize showRoundedCorners = _showRoundedCorners;
@synthesize rectCorner = _rectCorner;
@synthesize shadowOffset = _shadowOffset;

#pragma mark - Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {

        _roundedCornersView = [[UIView alloc] init];
        [_roundedCornersView setBackgroundColor: [UIColor clearColor]];
        [self addSubview: _roundedCornersView];
        
        _viewSize = CLViewSizeNormal;
        _rectCorner = UIRectCornerAllCorners;
        _showRoundedCorners = NO;
        
//        _evenColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
//        _oddColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];

    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithSize:(CLViewSize)size {
    self = [self init];
    if (self) {
        _viewSize = size;
    }
    return self;
}

#pragma mark -
#pragma mark Drawing

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) drawRect:(CGRect)rect {
//    [super drawRect:rect];
    
    if (_drawMultiplePagesEffect) {
//        _multiplePagesEffectLevel
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, rect);
        CGContextSetBlendMode(context, kCGBlendModeNormal);

        CGContextSetRGBFillColor(context, 195.0f/255.0f, 195.0f/255.0f, 195.0f/255.0f, 1.0f);
        CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 1.0f, rect.size.height));
        
        CGContextSetRGBFillColor(context, 154.0f/255.0f, 154.0f/255.0f, 154.0f/255.0f, 1.0f);
        CGContextFillRect(context, CGRectMake(1.0f, 0.0f, 1.0f, rect.size.height));
        
        CGContextSetRGBFillColor(context, 197.0f/255.0f, 197.0f/255.0f, 197.0f/255.0f, 1.0f);
        CGContextFillRect(context, CGRectMake(2.0f, 0.0f, 1.0f, rect.size.height));
        
        CGContextSetRGBFillColor(context, 154.0f/255.0f, 154.0f/255.0f, 154.0f/255.0f, 1.0f);
        CGContextFillRect(context, CGRectMake(3.0f, 0.0f, 1.0f, rect.size.height));

    }
}


#pragma mark -
#pragma mark Multiple pages effect

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) drawMultiplePagesEffectAtLevel:(NSUInteger)level {
    _drawMultiplePagesEffect = YES;
    _multiplePagesEffectLevel = level;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) eraseMultiplePagesEffect {
    _drawMultiplePagesEffect = NO;
    _multiplePagesEffectLevel = 0;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark Left boarder shadow

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addLeftBorderShadowView:(UIView *)view withWidth:(CGFloat)width {
    
    [self setClipsToBounds: NO];
    
    if (_shadowWidth != width) {
        _shadowWidth = width;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    
    if (view != _shadowView) {
        [_shadowView release];
        _shadowView = [view retain];
        
//        [self insertSubview:_shadowView atIndex:0];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeLeftBorderShadowView {
    
    [self setClipsToBounds: YES];
    
    [_shadowView release], _shadowView = nil;
    [self setNeedsLayout];
    
}


#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setContentView:(UIView*)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        [_contentView release];

        _contentView = [contentView retain];

        if (_contentView) {
            [_contentView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | 
             UIViewAutoresizingFlexibleRightMargin | 
             UIViewAutoresizingFlexibleBottomMargin | 
             UIViewAutoresizingFlexibleTopMargin | 
             UIViewAutoresizingFlexibleWidth | 
             UIViewAutoresizingFlexibleHeight];
            
            [_roundedCornersView addSubview: _contentView];
            [self setNeedsLayout];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView*)headerView {
    
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        [_headerView release];
        
        _headerView = [headerView retain];

        if (_headerView) {
            [_headerView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | 
             UIViewAutoresizingFlexibleRightMargin | 
             UIViewAutoresizingFlexibleTopMargin];
            
            [_roundedCornersView addSubview: _headerView];
            [self setNeedsLayout];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView*)footerView {
    
    if (_footerView != footerView) {
        [_footerView removeFromSuperview];
        [_footerView release];
        
        _footerView = [footerView retain];
        if (_footerView) {
            [_footerView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | 
             UIViewAutoresizingFlexibleRightMargin | 
             UIViewAutoresizingFlexibleBottomMargin];
            
            [_roundedCornersView addSubview: _footerView];
            [self setNeedsLayout];
        }
    }
}


#pragma mark -
#pragma mark Private

- (CGFloat) multiplePagesEffectWidth {

    if (_drawMultiplePagesEffect) {
        if (_multiplePagesEffectLevel == 1) return 2.0f;
        if (_multiplePagesEffectLevel >= 2) return 4.0f;
    }

    return 0.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateRoundedCorners {
    
    if (_showRoundedCorners) {
        CGRect toolbarBounds = self.bounds;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: toolbarBounds
                                                   byRoundingCorners:_rectCorner
                                                         cornerRadii:CGSizeMake(6.0f, 6.0f)];
        [maskLayer setPath:[path CGPath]];
        
        _roundedCornersView.layer.masksToBounds = YES;
        _roundedCornersView.layer.mask = maskLayer;
    } 
    else {
        _roundedCornersView.layer.masksToBounds = NO;
        [_roundedCornersView.layer setMask: nil];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {

    CGRect rect = self.bounds;
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    CGFloat headerHeight = 0.0;
    CGFloat footerHeight = 0.0;
    CGFloat pagesEffectWidth = [self multiplePagesEffectWidth];
    
    _roundedCornersView.frame = rect;
    
    if (_headerView) {
        headerHeight = _headerView.frame.size.height;
        
        CGRect newHeaderViewFrame = CGRectMake(pagesEffectWidth, 0.0, viewWidth - pagesEffectWidth, headerHeight);
        [_headerView setFrame: newHeaderViewFrame];
    }
    
    if (_footerView) {
        footerHeight = _footerView.frame.size.height;
        CGFloat footerY = viewHeight - footerHeight;
        
        CGRect newFooterViewFrame = CGRectMake(pagesEffectWidth, footerY, viewWidth - pagesEffectWidth, footerHeight);
        [_footerView setFrame: newFooterViewFrame];
    }
    
    [_contentView setFrame: CGRectMake(pagesEffectWidth, headerHeight, viewWidth - pagesEffectWidth, viewHeight - headerHeight - footerHeight)];

    if (_shadowView) {
        CGRect shadowFrame = CGRectMake(pagesEffectWidth - _shadowWidth + _shadowOffset, 0.0, _shadowWidth, rect.size.height);
        _shadowView.frame = shadowFrame;
    }

    [self updateRoundedCorners];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_footerView release], _footerView = nil;
    [_headerView release], _headerView = nil;
    [_contentView release], _contentView = nil;
    [_roundedCornersView release], _roundedCornersView = nil;
    [_shadowView release], _shadowView = nil;

    [super dealloc];
}

#pragma mark
#pragma mark Setters

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRectCorner:(UIRectCorner)corners {
    if (corners != _rectCorner) {
        _rectCorner = corners;
        [self setNeedsLayout];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setShowRoundedCorners:(BOOL)show {
    if (show != _showRoundedCorners) {
        _showRoundedCorners = show;
        [self setNeedsLayout];
    }
}


@end
