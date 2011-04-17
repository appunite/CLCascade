//
//  CLCascadeContentNavigator.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLScrollView.h"

@class CLViewController;
@class CLCascadeViewController;

@protocol CLCascadeContentNavigatorDelegate;

@interface CLCascadeContentNavigator : UIView {
    id<CLCascadeContentNavigatorDelegate> _delegate;
    
    CLCascadeViewController* _rootViewController;
    CLCascadeViewController* _lastCascadeViewController;
    
    CGFloat     _cascadeViewWidth;
    
    NSMutableArray* _viewControllers;
    
    UIInterfaceOrientation _orientation;
    
    UIView* _backgroundView;
}

@property (nonatomic, assign) IBOutlet id<CLCascadeContentNavigatorDelegate> delegate;

/* 
 First in hierarchy CascadeViewController (opposite to lastCascadeViewController)
 */
@property (nonatomic, retain) CLCascadeViewController* rootViewController;

/* 
 Last in hierarchy CascadeViewController (opposite to rootViewController)
 */
@property (nonatomic, retain) CLCascadeViewController* lastCascadeViewController;

/*
 This property determine cascade view width. Width of cascade 
 view is the same in landscape and portreit orientation, 
 only height is changing. It is recommended that the width 
 was a half-width of CascadeContentNavigator in landscape 
 orientation. This property is required.
 */
@property (nonatomic, assign) CGFloat   cascadeViewWidth;

/*
 List of CLViewControllers on stock.
 */
@property (nonatomic, retain) NSMutableArray* viewControllers;

/*
 Defining interface current interface orientation. Current interface orientation
 is set in method willAnimateFirstHalfOfRotationToInterfaceOrientation:duration: 
 by CLSplitCascadeViewController.
 */
@property (nonatomic, assign, readonly) UIInterfaceOrientation orientation;

@property (nonatomic, retain) IBOutlet UIView* backgroundView;

- (CGRect) cascadeScrollableViewFrame;
- (CGRect) cascadeContentNavigatorBounds;

- (CGSize) singleCascadeContentSize;
- (CGSize) doubleCascadeContentSize;

- (CGRect) masterCascadeFrame;
- (CGRect) detailCascadeFrame;

- (CGPoint) masterContentOffsetLeadToDetailView;
- (CGPoint) detailContentOffsetAtShow;

- (CGRect) frameRootViewController;
- (CGSize) contentSizeRootViewController;

- (void) addViewController:(CLViewController*)viewController;
- (void) removeViewController:(CLViewController*)viewController;
- (void) removeViewControllersStartingFrom:(CLViewController*)viewController;

- (void) adjustFrameAndContentAfterRotation:(UIInterfaceOrientation)newOrientation;

@end

@protocol CLCascadeContentNavigatorDelegate <NSObject>
- (void) rootViewControllerMoveToMasterPosition;
- (void) rootViewControllerMoveToDetailPosition;
@end
