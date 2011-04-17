//
//  CLCascadeContentNavigator.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLCascadeContentNavigator.h"
#import "CLViewController.h"
#import "CLCascadeViewController.h"
//
@implementation CLCascadeContentNavigator

@synthesize rootViewController = _rootViewController;
@synthesize lastCascadeViewController = _lastCascadeViewController;
@synthesize cascadeViewWidth = _cascadeViewWidth;
@synthesize viewControllers = _viewControllers;
@synthesize orientation = _orientation;
@synthesize delegate = _delegate;
@synthesize backgroundView = _backgroundView;

#pragma -
#pragma mark Memory managment

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _delegate = nil;
    [_backgroundView release], _backgroundView = nil;
    [_rootViewController release], _rootViewController = nil;
    [_lastCascadeViewController release], _lastCascadeViewController = nil;
    [_viewControllers release], _viewControllers = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // this value determine cascade view width
        [self setCascadeViewWidth: 479.0];
//        _orientation = UIInterfaceOrientationLandscapeLeft;

    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    for (NSUInteger i = [_viewControllers count]; i>0; i--) {
        UIView* view = [[_viewControllers objectAtIndex: i-1] view];
                
        CGRect covertRect = [self convertRect:view.bounds fromView:view];
//        NSLog(@"self.bounds: %f %f %f %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
//        NSLog(@"coverRect: %f %f %f %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
//        NSLog(@"point: %f %f", point.x, point.y);
        if (CGRectContainsPoint(covertRect, point)) {
            
            int x = point.x;
            CGFloat b = x%479;
            
            CGPoint covertPoint = [view.superview convertPoint:CGPointMake(b, point.y) toView: view];
            
//            if (covertRect.origin.x == 0) {
//                
//                if ([_viewControllers count] >= i) {
//                    UIView* nextView = [[_viewControllers objectAtIndex: i] view];
//                    CGPoint pp2 = [nextView.superview convertPoint:CGPointMake(b, point.y) toView: nextView];
//                    return [nextView hitTest:pp2 withEvent:event];
//                }
//            } else {
//                
                return [view hitTest:covertPoint withEvent:event];
//            }
        }
        
    }
    
    if ([_viewControllers count] > 0) {
        UIView* firstView = [[_viewControllers objectAtIndex: 0] view];
        return [firstView hitTest:point withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
}    

#pragma mark -
#pragma mark Calss methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addViewController:(CLViewController*)viewController {
    [self.viewControllers addObject: viewController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeViewController:(CLViewController*)viewController {
    [self.viewControllers removeObject: viewController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeViewControllersStartingFrom:(CLViewController*)viewController {

    NSUInteger index = [_viewControllers indexOfObject: viewController];
    NSUInteger lenght = [_viewControllers count] - index;
    [_viewControllers removeObjectsInRange:NSMakeRange(index, lenght)];
    
}

- (CGRect) cascadeContentNavigatorBounds {
    return self.bounds;
}

- (CGSize) singleCascadeContentSize {
    NSAssert(_cascadeViewWidth > 0.0, @"cascadeViewWidth property should by grater than 0.0");

    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return  CGSizeMake(self.cascadeViewWidth, contentNavigatorFrame.size.height);
    }

    if (UIInterfaceOrientationIsPortrait(_orientation)) {

        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;

        return  CGSizeMake(detailViewWidth + offset, contentNavigatorFrame.size.height);
    }
    
    return CGSizeZero;
}

- (CGSize) doubleCascadeContentSize {
    NSAssert(_cascadeViewWidth > 0.0, @"cascadeViewWidth property should by grater than 0.0");
    
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return CGSizeMake(self.cascadeViewWidth*2, contentNavigatorFrame.size.height);
    }

    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return  CGSizeMake(detailViewWidth + rootScrollViewOriginX + offset, contentNavigatorFrame.size.height);
    }
    
    return CGSizeZero;
}

- (CGRect) masterCascadeFrame {
    NSAssert(_cascadeViewWidth > 0.0, @"cascadeViewWidth property should by grater than 0.0");
    
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return CGRectMake(0.0, 0.0, self.cascadeViewWidth, contentNavigatorFrame.size.height);
    }

    if (UIInterfaceOrientationIsPortrait(_orientation)) {
//        CGFloat detailViewWidth = 479.0;
//        CGFloat navigatorContainerWidth = 702.0;
//        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
//        CGFloat rootScrollViewWidth = 290;
//        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;

        return CGRectMake(0.0, 0.0, self.cascadeViewWidth, contentNavigatorFrame.size.height);
    }
    
    return CGRectZero;
}

- (CGRect) detailCascadeFrame {
    NSAssert(_cascadeViewWidth > 0.0, @"cascadeViewWidth property should by grater than 0.0");
    
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return CGRectMake(self.cascadeViewWidth, 0.0, self.cascadeViewWidth, contentNavigatorFrame.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;

        return CGRectMake(detailViewWidth, 0.0, rootScrollViewOriginX + offset, contentNavigatorFrame.size.height);
    }
    

    return CGRectZero;
}

- (CGPoint) masterContentOffsetLeadToDetailView {

    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return CGPointMake(self.cascadeViewWidth, 0.0);
    }
    
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return CGPointMake(rootScrollViewOriginX*2 + offset, 0.0);
    }
    
    return CGPointZero;
}

- (CGPoint) detailContentOffsetAtShow {
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return CGPointMake(0.0, 0.0);
    }
    
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;

        return CGPointMake(rootScrollViewOriginX + offset, 0.0);
    }
    
    return CGPointZero;
}

#pragma mark -
#pragma mark Private

- (CGSize) contentSizeRootViewController {

    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return  CGSizeMake(479.0, self.bounds.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;

        if ([_viewControllers count] > 1) {
            return  CGSizeMake(detailViewWidth + offset, self.bounds.size.height);
        } else {
            return  CGSizeMake(rootScrollViewWidth + 1, self.bounds.size.height);
        }
    }
    
    return CGSizeZero;
}

- (CGRect) frameRootViewController {

    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return  CGRectMake(479.0, 0.0, 479.0, self.bounds.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
                
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;

//        NSLog(@"%f %f %f %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        return  CGRectMake(rootScrollViewOriginX, 0.0, rootScrollViewWidth, self.bounds.size.height);
    }
    
    return CGRectZero;
}

- (CGRect) cascadeScrollableViewFrame {
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        return  CGRectMake(0.0, 0.0, 479.0, self.bounds.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(_orientation)) {
        
        CGFloat detailViewWidth = 479.0;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return  CGRectMake(detailViewWidth, 0.0, rootScrollViewOriginX + offset, self.bounds.size.height);
    }
    
    return CGRectZero;
}

- (void) adjustFrameAndContentAfterRotation:(UIInterfaceOrientation)newOrientation {
    // we need to set current interface orientation
    _orientation = newOrientation;
    
    [_rootViewController adjustFrameAndContentToInterfaceOrientation: newOrientation];
}

#pragma mark -
#pragma mark Getters & setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLCascadeViewController*) rootViewController {
    return _rootViewController;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLCascadeViewController*)viewController {
    if (viewController != _rootViewController) {
        
        // remove all details view controllers
        if (_rootViewController != nil) {
            [_rootViewController popDetailPositionViewController];
        }
        
        // remove rootViewController view from navigator
        [_rootViewController.view removeFromSuperview];
        [_rootViewController release];
        // set up new rootViewController
        _rootViewController = [viewController retain];
        
        // set up content navigator
        [_rootViewController setContentNavigator: self];
        // set delegate
        [_rootViewController setDelegate: self];
        // root view hasn't parentCascadeViewController
        [_rootViewController setParentCascadeViewController: nil];
        
        
        // set last CascadeViewController
        self.lastCascadeViewController = viewController;
        
        // add View controllers to stock array
        [self addViewController: viewController.masterPositionViewController];
        
        // set background color
        [self setBackgroundColor: [UIColor clearColor]];
        
        // update contentSize
        [(UIScrollView*)_rootViewController.view setContentSize: [self contentSizeRootViewController]];
                
        // prepare for animation
        UIView* rootView = _rootViewController.view;
        CGRect stopAnimationViewFrame = [self frameRootViewController];
        CGRect startAnimationRootViewFrame = [self frameRootViewController];
        startAnimationRootViewFrame.origin.x = startAnimationRootViewFrame.size.width / 2;
        [rootView setAlpha: 0.0];
        [rootView setFrame: startAnimationRootViewFrame];
        
        // rootViewController is at center when added
        if ([rootView isKindOfClass: [UIScrollView class]] && (UIInterfaceOrientationIsLandscape(_orientation))) {
            [(UIScrollView*)rootView setContentInset:UIEdgeInsetsMake(0.0, -([self singleCascadeContentSize].width/2) - 16, 0.0, 0.0)];
        }
        
        // add view
        [self addSubview: rootView];
        
        // commit animation
        [UIView animateWithDuration:0.4 animations:^ {
            [rootView setAlpha: 1.0];
            [rootView setFrame: stopAnimationViewFrame];
        }];
        
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*) viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return _viewControllers;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setViewControllers:(NSMutableArray*)array {
    if (array != _viewControllers) {
        [_viewControllers release];
        _viewControllers = [array retain];
    }
}

#pragma mark -
#pragma mark CLCascadeViewControllerDelegate

- (void) cascadeViewController:(CLCascadeViewController*)cascadeViewController didChangeScrollPosition:(CLCascadeViewScrollPositions)scrollPosition {
    if (cascadeViewController == _rootViewController) {

        if (scrollPosition == CLCascadeViewScrollMasterPosition) {
            if ([_delegate respondsToSelector:@selector(rootViewControllerMoveToMasterPosition)]) {
                [_delegate rootViewControllerMoveToMasterPosition];
            }
        }
        if (scrollPosition == CLCascadeViewScrollDetailPosition) {
            if ([_delegate respondsToSelector:@selector(rootViewControllerMoveToDetailPosition)]) {
                [_delegate rootViewControllerMoveToDetailPosition];
            }
        }
    }
}

@end
