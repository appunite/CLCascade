//
//  CLViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CLCascadeContentNavigator.h"

@class CLCascadeViewController;

@interface CLViewController : UIViewController {
    CLCascadeViewController* _parentCascadeViewController;
    CAGradientLayer* _originShadow;
    CGFloat _shadowWidth;
}

@property (nonatomic, retain) CLCascadeViewController* parentCascadeViewController;

- (void) pushDetailViewController:(CLViewController *)viewController;
- (void) addOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha;
- (void) updateLayout;

@end
