//
//  UIViewController+CLCascade.m
//  Cascade
//
//  Created by Błażej Biesiada on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+CLCascade.h"
#import <Cascade/CLSplitViewController/CLSplitCascadeViewController.h>
#import <Cascade/CLCascadeNavigationController/CLCascadeNavigationController.h>
#import <Cascade/Other/CLBorderShadowView.h>
#import <Cascade/Other/UIViewController+CLSegmentedView.h>

@implementation UIViewController (CLCascade)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLSplitCascadeViewController *)splitCascadeViewController {
    UIViewController *parent = self.parentViewController;
    
    if ([parent isKindOfClass:[CLSplitCascadeViewController class]]) {
        return (CLSplitCascadeViewController *)parent;
    }
    else {
        return parent.splitCascadeViewController;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLCascadeNavigationController *)cascadeNavigationController {
    UIViewController *parent = self.parentViewController;
    
    if ([parent isKindOfClass:[CLCascadeNavigationController class]]) {
        return (CLCascadeNavigationController *)parent;
    }
    else {
        return parent.cascadeNavigationController;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *) leftBorderShadowView {
    return [[CLBorderShadowView alloc] init];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addLeftBorderShadowWithWidth:(CGFloat)width andOffset:(CGFloat)offset {
    UIView* shadowView = [self leftBorderShadowView];
    [self.segmentedView addLeftBorderShadowView:shadowView
                                      withWidth:width];
    
    [self.segmentedView setShadowOffset:offset];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeLeftBorderShadow {
    [self.segmentedView removeLeftBorderShadowView];    
}

@end
