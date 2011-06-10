//
//  CLCascadeNavigationController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLViewController.h"
#import "CLCascadeView.h"
#import "CLViewControllerDelegate.h"

@interface CLCascadeNavigationController : UIViewController <CLCascadeViewDataSource, CLCascadeViewDelegate> {
    // array of all view controllers
    NSMutableArray* _viewControllers;

    // view containing all views on stack
    CLCascadeView* _cascadeView;
}

/*
 List of CLViewControllers on stock.
 */
@property (nonatomic, retain, readonly) NSMutableArray* viewControllers;

/*
 * Offset of pages from left boarder. Default 66.0f
 */
@property(nonatomic) CGFloat offset;

/*
 * You can change page width, default (1024.0 - offset) / 2.0, so
 * in landscape mode two pages fit properly
 */
@property(nonatomic) CGFloat pageWidth;


/*
 * Set and push root view controller
 */
- (void) setRootViewController:(CLViewController*)viewController animated:(BOOL)animated;


/*
 * Push new view controller from sender.
 * If sender is not last, then controller pop next controller and push new view from sender
 */

- (void) addViewController:(CLViewController*)viewController sender:(CLViewController*)sender animated:(BOOL)animated;


/* 
 First in hierarchy CascadeViewController (opposite to lastCascadeViewController)
 */
- (UIViewController*) rootViewController;


/* 
 Last in hierarchy CascadeViewController (opposite to rootViewController)
 */
- (UIViewController*)  lastCascadeViewController;

- (BOOL) isOnStack:(UIViewController*)viewController;

@end
