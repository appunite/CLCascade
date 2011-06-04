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

@class CLCascadeNavigationController;

@interface CLViewController : UIViewController <CLViewControllerDelegate> {
    CLCascadeNavigationController* _cascadeNavigationController;

    CAGradientLayer* _originShadow;
}

@property (nonatomic, retain) IBOutlet CLCascadeNavigationController* cascadeNavigationController;

// method used to push (animated) new UIViewController on Cascade stack
- (void) pushDetailViewController:(CLViewController *)viewController animated:(BOOL)animated;

// Outer left shadow methods
- (void) setOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha animated:(BOOL)animated;
- (void) showShadow:(BOOL)animated;
- (void) hideShadow:(BOOL)animated;

@end
