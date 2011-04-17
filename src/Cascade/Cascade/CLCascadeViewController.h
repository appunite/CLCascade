//
//  CLCascadeViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-24.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLViewController.h"
#import "CLCascadeContentNavigator.h"

@class CLViewController;


typedef enum {
	CLCascadeViewScrollUnknowPosition = NSNotFound,
	CLCascadeViewScrollMasterPosition = 0,
	CLCascadeViewScrollDetailPosition = 1
} CLCascadeViewScrollPositions;

@protocol CLCascadeViewControllerDelegate;

@interface CLCascadeViewController : CLViewController <UIScrollViewDelegate> {
    CLCascadeContentNavigator*  _contentNavigator;
    id<CLCascadeViewControllerDelegate> _delegate;

    CLViewController* _masterPositionViewController;
    CLCascadeViewController* _detailPositionViewController;
    CLCascadeViewScrollPositions _scrollPosition;
    
}

@property (nonatomic, retain) CLCascadeContentNavigator*  contentNavigator;
@property (nonatomic, assign) id<CLCascadeViewControllerDelegate> delegate;

@property (nonatomic, assign) CLCascadeViewScrollPositions scrollPosition;
@property (nonatomic, retain, readonly) CLViewController* masterPositionViewController;
@property (nonatomic, retain, readonly) CLCascadeViewController* detailPositionViewController;

- (id) initWithMasterPositionViewController:(CLViewController*)masterPositionViewController;
- (void) pushCascadeViewController:(CLCascadeViewController *)viewController;
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
