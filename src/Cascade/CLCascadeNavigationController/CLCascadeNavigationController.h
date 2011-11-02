//
//  CLCascadeNavigationController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Cascade/CLCascadeNavigationController/CLCascadeView.h>
#import <Cascade/Other/CLGlobal.h>
#import <Cascade/CLCustomViewControllers/CLViewControllerDelegate.h>

@class CLContainerView;

@interface CLCascadeNavigationController : UIViewController <CLCascadeViewDataSource, CLCascadeViewDelegate> {
    // array of all view controllers
    // todo: in ios5 use childViewControllers
    NSMutableArray* _viewControllers;

    // view containing all views on stack
    CLCascadeView* _cascadeView;
}

/*
 List of CLViewControllers on stock.
 */
@property (nonatomic, strong, readonly) NSMutableArray* viewControllers;

/*
 * Left inset of normal size pages from left boarder
 */
@property(nonatomic) CGFloat leftInset;

/*
 * Left inset of wider size page from left boarder. Default 220.0f
 */
@property(nonatomic) CGFloat widerLeftInset;

/*
 * Set and push root view controller
 */
- (void) setRootViewController:(UIViewController*)viewController animated:(BOOL)animated;

/*
 * Push new view controller from sender.
 * If sender is not last, then controller pop next controller and push new view from sender
 */
- (void) addViewController:(UIViewController*)viewController sender:(UIViewController*)sender animated:(BOOL)animated;

/* 
 First in hierarchy CascadeViewController (opposite to lastCascadeViewController)
 */
- (UIViewController*) rootViewController;

/* 
 Last in hierarchy CascadeViewController (opposite to rootViewController)
 */
- (UIViewController*)  lastCascadeViewController;

/* 
 Return first visible view controller (load if needed)
 */
- (UIViewController*) firstVisibleViewController;


@end

@interface UIViewController (CLCascade) <CLViewControllerDelegate>

- (id) initWithSize:(CLViewSize)size;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil size:(CLViewSize)size;

@property (nonatomic, strong) IBOutlet CLCascadeNavigationController* cascadeNavigationController;
@property (nonatomic, strong) CLContainerView* clContainerView;

@property (nonatomic, assign) CLViewSize clViewSize;
@property (nonatomic, assign) BOOL showRoundedCorners; // TODO : check the utility ... !

// method used to push (animated) new UIViewController on Cascade stack
- (void) pushDetailViewController:(UIViewController *)viewController animated:(BOOL)animated;

// Outer left shadow methods
- (void) addLeftBorderShadowWithWidth:(CGFloat)width andOffset:(CGFloat)offset;
- (void) removeLeftBorderShadow;

/*
 Override this methods to return view which represent left border shadow.
 It could be UIImageView with gradient image or simle UIView, where you can overrider drawRect: method
 to draw gradient in Core Animation.
 */
- (UIView *) leftBorderShadowView;
@end