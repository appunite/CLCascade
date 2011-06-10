//
//  CascadeAppDelegate.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
// 

#import <UIKit/UIKit.h>

@class CLSplitCascadeViewController;

@interface CascadeAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CLSplitCascadeViewController *viewController;

@end
