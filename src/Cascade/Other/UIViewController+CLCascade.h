//
//  UIViewController+CLCascade.h
//  Cascade
//
//  Created by Błażej Biesiada on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLCascadeNavigationController;
@class CLSplitCascadeViewController;

@interface UIViewController (CLCascade)

@property(nonatomic, readonly, retain) CLSplitCascadeViewController *splitCascadeViewController;
@property(nonatomic, readonly, retain) CLCascadeNavigationController *cascadeNavigationController;

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
