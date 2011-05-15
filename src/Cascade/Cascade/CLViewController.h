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

@class CLCascadeViewController;
@class CLCascadeNavigationController;

@interface CLViewController : UIViewController {
    CLCascadeViewController* _parentCascadeViewController;
    CLCascadeNavigationController* _cascadeNavigationController;
    
    CAGradientLayer* _originShadow;
    CGFloat _shadowWidth;
}

@property (nonatomic, retain) CLCascadeViewController* parentCascadeViewController;
@property (nonatomic, retain) IBOutlet CLCascadeNavigationController* cascadeNavigationController;


- (void) pushDetailViewController:(CLViewController *)viewController;
- (void) setOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha;

@end
