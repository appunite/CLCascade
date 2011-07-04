//
//  CLSplitCascadeView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLSplitCascadeView.h"

@interface CLSplitCascadeView (Private)
- (void) setupView;
- (void) addDivierView;
@end

@implementation CLSplitCascadeView

@synthesize splitCascadeViewController = _splitCascadeViewController;

@synthesize categoriesView = _categoriesView;
@synthesize cascadeView = _cascadeView;
@synthesize backgroundView = _backgroundView;
@synthesize verticalDividerImage = _verticalDividerImage;

#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setupView {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addDivierView {
    
    if ((!_backgroundView) || (!_verticalDividerImage)) return;
    
    if (_dividerView) {
        [_dividerView removeFromSuperview];
        [_dividerView release], _dividerView = nil;
    }
        
    _dividerView = [[UIView alloc] init];
    _dividerWidth = _verticalDividerImage.size.width;
    [_dividerView setBackgroundColor:[UIColor colorWithPatternImage: _verticalDividerImage]];
    
    [_backgroundView addSubview: _dividerView];
    [self setNeedsLayout];   
    
}


#pragma mark -
#pragma mark Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_cascadeView release], _cascadeView = nil;
    [_categoriesView release], _categoriesView = nil;
    [_splitCascadeViewController release], _splitCascadeViewController = nil;
    [_cascadeNavigationController release], _cascadeNavigationController = nil;
    [_backgroundView release], _backgroundView = nil;
    [_verticalDividerImage release], _verticalDividerImage = nil;
    [_dividerView release], _dividerView = nil;

    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    CLCascadeNavigationController* cascadeNavigationController = _splitCascadeViewController.cascadeNavigationController;
    UIView* navigationView = [cascadeNavigationController view];

    if (CGRectContainsPoint(_categoriesView.frame, point)) {
        
        UIView* rootView = [[cascadeNavigationController rootViewController] view];
        CGRect rootViewRect = [rootView convertRect:rootView.bounds toView:self];

        if ((rootView) && (CGRectContainsPoint(rootViewRect, point))) {
            CGPoint newPoint = [self convertPoint:point toView:navigationView];
            return [navigationView hitTest:newPoint withEvent:event];
        } else {
            return [_categoriesView hitTest:point withEvent:event];
        }

    } else {
        CGPoint newPoint = [self convertPoint:point toView:navigationView];
        return [navigationView hitTest:newPoint withEvent:event];
    }
        
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    
    CGRect bounds = self.bounds;
    
    CGRect categoriesFrame = CGRectMake(0.0, 0.0, CATEGORIES_VIEW_WIDTH, bounds.size.height);
    _categoriesView.frame = categoriesFrame;
    
    CGRect cascadeNavigationFrame = bounds;
    _cascadeView.frame = cascadeNavigationFrame;

    CGRect backgroundViewFrame = CGRectMake(CATEGORIES_VIEW_WIDTH, 0.0, bounds.size.width - CATEGORIES_VIEW_WIDTH, bounds.size.height);
    _backgroundView.frame = backgroundViewFrame;

    CGRect dividerViewFrame = CGRectMake(0.0, 0.0, _dividerWidth, bounds.size.height);
    _dividerView.frame = dividerViewFrame;
}


#pragma mark -
#pragma mark Setter

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setCategoriesView:(UIView*) aView {
    if (_categoriesView != aView) {
        [_categoriesView release];
        _categoriesView = [aView retain];
        
        [self addSubview: _categoriesView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setCascadeView:(UIView*) aView {
    if (_cascadeView != aView) {
        [_cascadeView release];
        _cascadeView = [aView retain];
        
        [self addSubview: _cascadeView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setBackgroundView:(UIView*) aView {
    if (_backgroundView != aView) {
        [_backgroundView release];
        _backgroundView = [aView retain];
        
        [_dividerView removeFromSuperview];
        [_dividerView release], _dividerView = nil;
        
        if (_cascadeView == nil) {
            [self addSubview: _backgroundView];
        } else {
            NSUInteger index = [self.subviews indexOfObject: _cascadeView];
            [self insertSubview:_backgroundView atIndex:index];
        }

        [self addDivierView];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setVerticalDividerImage:(UIImage*) image {
    if (_verticalDividerImage != image) {
        [_verticalDividerImage release];
        _verticalDividerImage = [image retain];
        
        [self addDivierView];
    }
}

@end
