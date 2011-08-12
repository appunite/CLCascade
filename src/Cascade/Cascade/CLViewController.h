//
//  CLViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CLSegmentedView.h"
#import "UIViewController+CLSegmentedView.h"
#import "CLViewControllerDelegate.h"
#import "CLGlobal.h"

@class CLCascadeNavigationController;

@interface CLViewController : UIViewController <CLViewControllerDelegate> {
    CLCascadeNavigationController* _cascadeNavigationController;

    CLViewSize _viewSize;
    BOOL _roundedCorners;
}

- (id) initWithSize:(CLViewSize)size;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil size:(CLViewSize)size;

@property (nonatomic, retain) IBOutlet CLCascadeNavigationController* cascadeNavigationController;
@property (nonatomic, assign, readonly) CLViewSize viewSize;
@property (nonatomic, assign) BOOL showRoundedCorners;

// method used to push (animated) new UIViewController on Cascade stack
- (void) pushDetailViewController:(CLViewController *)viewController animated:(BOOL)animated;

// Outer left shadow methods
- (void) addShadowWithWidth:(CGFloat)width animated:(BOOL)animated;
- (void) removeShadow:(BOOL)animated;

- (CAGradientLayer*) outerLeftShadow;

@end
