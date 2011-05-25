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
@synthesize horizontalDivider = _horizontalDivider;
@synthesize showDivider = _showDivider;

#define CATEGORIES_VIEW_WIDTH 289.0f
#define CASCADE_NAVIGATION_VIEW_OFFSET 66.0f
#define DEFAULT_DIVIDER_FILENAME @"divider_vertical.png"

#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setupView {
    _showDivider = NO;    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addDivierView {
    
    if (_dividerView) {
        [_dividerView removeFromSuperview];
        [_dividerView release], _dividerView = nil;
    }
    
    if (!_horizontalDivider) {
        _horizontalDividerImage = [UIImage imageNamed: DEFAULT_DIVIDER_FILENAME];
    }
    
    _dividerView = [[UIView alloc] init];
    _dividerWidth = _horizontalDividerImage.size.width;
    [_dividerView setBackgroundColor:[UIColor colorWithPatternImage: _horizontalDividerImage]];
    
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
- (void) awakeFromNib {

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_cascadeView release], _cascadeView = nil;
    [_categoriesView release], _categoriesView = nil;
    [_splitCascadeViewController release], _splitCascadeViewController = nil;
    [_cascadeNavigationController release], _cascadeNavigationController = nil;
    [_backgroundView release], _backgroundView = nil;
    [_horizontalDividerImage release], _horizontalDividerImage = nil;
    [_dividerView release], _dividerView = nil;

    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
//    CLSplitCascadeViewController* viewController = (CLSplitCascadeViewController*)[self viewController];
    CLCascadeViewController* rootViewController = [_splitCascadeViewController.cascadeNavigationController rootViewController];
    
    if ([rootViewController currentScrollPosition] == CLCascadeViewScrollMasterPosition) {

        if ((CGRectContainsPoint(_splitCascadeViewController.view.frame, point)) && (CGRectContainsPoint(_categoriesView.frame, point))) {
            return [_categoriesView hitTest:point withEvent:event];
        }
    }
    
    return [super hitTest:point withEvent:event];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    
    CGRect bounds = self.bounds;
    
    CGRect categoriesFrame = CGRectMake(0.0, 0.0, CATEGORIES_VIEW_WIDTH, bounds.size.height);
    _categoriesView.frame = categoriesFrame;
    
    CGRect cascadeNavigationFrame = CGRectMake(CASCADE_NAVIGATION_VIEW_OFFSET, 0.0, bounds.size.width - CASCADE_NAVIGATION_VIEW_OFFSET, bounds.size.height);
    _cascadeView.frame = cascadeNavigationFrame;

    CGRect backgroundViewFrame = CGRectMake(CATEGORIES_VIEW_WIDTH, 0.0, bounds.size.width - CATEGORIES_VIEW_WIDTH, bounds.size.height);
    _backgroundView.frame = backgroundViewFrame;

    CGRect dividerViewFrame = CGRectMake(0.0, 0.0, _dividerWidth, bounds.size.height);
    _dividerView.frame = dividerViewFrame;
}

#pragma mark -
#pragma mark CLCascadeContentNavigatorDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) rootViewControllerMoveToMasterPosition {
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) rootViewControllerMoveToDetailPosition {
    
}

#pragma mark -
#pragma mark Setter

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setShowDivider:(BOOL)flag {
    _showDivider = flag;

    if (_backgroundView) {
        if (flag) {            
            [self addDivierView];
        } else {
            [_dividerView removeFromSuperview];
            [_dividerView release], _dividerView = nil;
        }
    }
}

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
        
        if (_cascadeView == nil) {
            [self addSubview: _backgroundView];
        } else {
            NSUInteger index = [self.subviews indexOfObject: _cascadeView];
            [self insertSubview:_backgroundView atIndex:index];
        }

        if (_showDivider) {
            [self addDivierView];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    
    static UIViewController* __viewController;
    
    if (__viewController == nil) {
    
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                __viewController = (UIViewController*)nextResponder;
                return __viewController;
            }
        }
    }
    
    return __viewController;
}


@end
