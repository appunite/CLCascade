//
//  CLSplitCascadeViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLCategoriesViewController.h"
#import "CLCascadeNavigationController.h"

@interface CLSplitCascadeViewController : UIViewController {
    CLCategoriesViewController*     _categoriesViewController;
    CLCascadeNavigationController*  _cascadeNavigationController;
}

@property (nonatomic, retain) IBOutlet CLCategoriesViewController* categoriesViewController;
@property (nonatomic, retain) IBOutlet CLCascadeNavigationController* cascadeNavigationController;

- (void) setBackgroundView:(UIView*)backgroundView;
- (void) setDividerImage:(UIImage*)image;

@end
