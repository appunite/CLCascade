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

@property (nonatomic, strong) IBOutlet CLCascadeNavigationController* cascadeNavigationController;
@property (nonatomic, assign, readonly) CLViewSize viewSize;
@property (nonatomic, assign) BOOL showRoundedCorners;

// method used to push (animated) new UIViewController on Cascade stack
- (void) pushDetailViewController:(CLViewController *)viewController animated:(BOOL)animated;

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
