//
//  CLSegmentedView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLSegmentedView.h"
#import <QuartzCore/QuartzCore.h>

@interface CLSegmentedView (Private)
- (void) setupViews;
@end

@implementation CLSegmentedView

@synthesize footerView = _footerView;
@synthesize headerView = _headerView;
@synthesize contentView = _contentView;
@synthesize shadow = _shadow;
@synthesize shadowWidth = _shadowWidth;

#pragma mark - Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    if (self) {
		_headerView = nil;
		_footerView = nil;
		_contentView = nil;
		_shadow = nil;
//        [self setupViews];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		_headerView = nil;
		_footerView = nil;
		_contentView = nil;
		_shadow = nil;

//        [self setupViews];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
//        [self setupViews];
    }
    return self;
}


#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setupViews {
    
//    [self.layer setCornerRadius: 40.0];
//    [self.layer setMasksToBounds:YES];
    
//    if (!_contentView) {
//        _contentView = [[UIView alloc] initWithFrame: self.bounds];
//        [self addSubview: _contentView];
//    }
    
    [_headerView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleTopMargin];
    
    [_footerView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin];
    
    [_contentView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin | 
     UIViewAutoresizingFlexibleTopMargin | 
     UIViewAutoresizingFlexibleWidth | 
     UIViewAutoresizingFlexibleHeight];
}


#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setContentView:(UIView*)contentView {
    if (_contentView != contentView) {
		if (_contentView) {
			[_contentView removeFromSuperview];
			[_contentView release];
		}

        _contentView = [contentView retain];

        if (_contentView) {
            [_contentView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | 
             UIViewAutoresizingFlexibleRightMargin | 
             UIViewAutoresizingFlexibleBottomMargin | 
             UIViewAutoresizingFlexibleTopMargin | 
             UIViewAutoresizingFlexibleWidth | 
             UIViewAutoresizingFlexibleHeight];
            
            [self addSubview: _contentView];
            [self setNeedsLayout];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView*)headerView {
    
    if (_headerView != headerView) {
		if (_headerView) {
			[_headerView removeFromSuperview];
			[_headerView release];
		}
        
        _headerView = [headerView retain];

        if (_headerView) {
            [_headerView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | 
             UIViewAutoresizingFlexibleRightMargin | 
             UIViewAutoresizingFlexibleTopMargin];
            
            [self addSubview: _headerView];
            [self setNeedsLayout];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView*)footerView {
    
    if (_footerView != footerView) {
		if (_footerView) {
			[_footerView removeFromSuperview];
			[_footerView release];
		}
        
        _footerView = [footerView retain];
        if (_footerView) {
            [_footerView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin | 
             UIViewAutoresizingFlexibleRightMargin | 
             UIViewAutoresizingFlexibleBottomMargin];
            
            [self addSubview: _footerView];
            [self setNeedsLayout];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setShadow:(CAGradientLayer*)shadow {
    
    if (_shadow != shadow) {
		if (_shadow) {
			[_shadow removeFromSuperlayer];
			[_shadow release];
		}
		
        _shadow = [shadow retain];
        
        [self setClipsToBounds: NO];
        
		[self.layer insertSublayer:_shadow atIndex:0];
        [self setNeedsLayout];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setShadow:(CAGradientLayer*)newShadow withWidth:(CGFloat)with {
    _shadowWidth = with;
    self.shadow = newShadow;
}


#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    CGRect rect = self.bounds;
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    CGFloat headerHeight = 0.0;
    CGFloat footerHeight = 0.0;
    
    if (_headerView) {
        headerHeight = _headerView.frame.size.height;
        
        CGRect newHeaderViewFrame = CGRectMake(0.0, 0.0, viewWidth, headerHeight);
        [_headerView setFrame: newHeaderViewFrame];
    }
    
    if (_footerView) {
        footerHeight = _footerView.frame.size.height;
        CGFloat footerY = viewHeight - footerHeight;
        
        CGRect newFooterViewFrame = CGRectMake(0.0, footerY, viewWidth, footerHeight);
        [_footerView setFrame: newFooterViewFrame];
    }
    
    [_contentView setFrame: CGRectMake(0.0, headerHeight, viewWidth, viewHeight - headerHeight - footerHeight)];

    if (_shadow) {

        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        
        CGRect shadowFrame = CGRectMake(0 - _shadowWidth, 0.0, _shadowWidth, rect.size.height);
        _shadow.frame = shadowFrame;
        
        [CATransaction commit];

    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    if (_footerView) {
		[_footerView removeFromSuperview];
		[_footerView release], _footerView = nil;
	}
    if (_headerView) {
		[_headerView removeFromSuperview];
		[_headerView release], _headerView = nil;
	}
    if (_contentView) {
		[_contentView removeFromSuperview];
		[_contentView release], _contentView = nil;
	}
	if (_shadow) {
		[_shadow removeFromSuperlayer];
		[_shadow release], _shadow = nil;
	}
    [super dealloc];
}

@end
