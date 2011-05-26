//
//  CLCascadeViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-24.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLViewController.h"
#import "CLCascadeNavigationController.h"
#import "CLCascadeEnums.h"

@class CLViewController;

@protocol CLCascadeViewControllerDelegate;

@interface CLCascadeViewController : CLViewController <UIScrollViewDelegate> {
    id<CLCascadeViewControllerDelegate> _delegate;

    CLViewController* _masterPositionViewController;
    CLCascadeViewController* _detailPositionViewController;
    CLCascadeViewScrollPositions _scrollPosition;
    
}

@property (nonatomic, assign) id<CLCascadeViewControllerDelegate> delegate;

@property (nonatomic, assign) CLCascadeViewScrollPositions scrollPosition;
@property (nonatomic, retain, readonly) CLViewController* masterPositionViewController;
@property (nonatomic, assign, readonly) CLCascadeViewController* detailPositionViewController;

- (id) initWithMasterPositionViewController:(CLViewController*)masterPositionViewController;
- (void) pushCascadeViewController:(CLCascadeViewController *)viewController animated:(BOOL)animated;
- (void) popDetailPositionViewController;
- (void) popMasterAndDetailPositionViewController;

- (CLCascadeViewScrollPositions) currentScrollPosition;

- (void) scrollPositionDidChange:(CLCascadeViewScrollPositions)newPosition;

- (BOOL) isRootCascadeViewController;
- (BOOL) isLastCascadeViewController;

- (void) adjustFrameAndContentToInterfaceOrientation:(UIInterfaceOrientation)newOrientation;

@end

@protocol CLCascadeViewControllerDelegate <NSObject>
- (void) cascadeViewController:(CLCascadeViewController*)cascadeViewController didChangeScrollPosition:(CLCascadeViewScrollPositions)scrollPosition;
@end
