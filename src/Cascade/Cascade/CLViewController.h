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
#import "CLSegmentedView.h"

@class CLCascadeViewController;

@interface CLViewController : UIViewController {
    UIView* headerView;
    UIView* footerView;
    
    CLCascadeViewController* _parentCascadeViewController;
    CAGradientLayer* _originShadow;
    CGFloat _shadowWidth;
}

@property (nonatomic, retain) CLCascadeViewController* parentCascadeViewController;
//@property (nonatomic, retain) CLSegmentedView* view;
@property (nonatomic, retain, readonly) UIView* headerView;
@property (nonatomic, retain, readonly) UIView* footerView;

- (void) pushDetailViewController:(CLViewController *)viewController;
- (void) setOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha;

@end
