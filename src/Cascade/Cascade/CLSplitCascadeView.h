//
//  CLSplitCascadeView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCascadeNavigationController.h"
#import "CLCascadeEnums.h"
#import "CLSplitCascadeViewController.h"
#import "CLCascadeViewController.h"

@interface CLSplitCascadeView : UIView <CLCascadeNavigationControllerDelegate> {
    UIView* _categoriesView;
    UIView* _cascadeView;
 
    CLCascadeNavigationController* _cascadeNavigationController;
    CLSplitCascadeViewController* _splitCascadeViewController;
    
    UIView*     _backgroundView;
    
    UIView*     _dividerView;
    UIImage*    _horizontalDividerImage;
    
}

@property (nonatomic, retain) IBOutlet CLSplitCascadeViewController* splitCascadeViewController;

///*
// * Divider image - view between categories and cascade view
// */
//@property (nonatomic, retain) UIImage*  horizontalDivider;

/*
 * Background view - located under cascade view
 */
@property (nonatomic, retain) UIView* backgroundView;

/*
 * Categories view - located on the left, view containing table view
 */
@property (nonatomic, retain) UIView* categoriesView;

/*
 * Cascade content navigator - located on the right, view containing cascade view controllers
 */
@property (nonatomic, retain) UIView* cascadeView;

- (UIViewController*)viewController;

@end
