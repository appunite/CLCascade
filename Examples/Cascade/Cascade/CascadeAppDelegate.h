//
//  CascadeAppDelegate.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
// 

#import <UIKit/UIKit.h>

@class ExampleSplitCascadeViewController;

@interface CascadeAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet ExampleSplitCascadeViewController *splitCascadeViewController;

@end
