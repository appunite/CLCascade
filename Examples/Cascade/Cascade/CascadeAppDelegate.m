//
//  CascadeAppDelegate.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
// 

#import "CascadeAppDelegate.h"

#import "ExampleNavigationController.h"
#import "ExampleCategoriesViewController.h"
#import "ExampleSplitCascadeViewController.h"

@implementation CascadeAppDelegate

@synthesize window = _window;
@synthesize splitCascadeViewController = _splitCascadeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // create cascade navigation controller
    ExampleNavigationController* cascadeNavigationController = [[ExampleNavigationController alloc] init];

    // create left categories controller
    ExampleCategoriesViewController* categoriesViewController = [[ExampleCategoriesViewController alloc] initWithNibName:@"ExampleCategoriesViewController" bundle:nil];
    
    
    // create split controller with cascade navigation controller
    _splitCascadeViewController = [[ExampleSplitCascadeViewController alloc] initWithNavigationController:cascadeNavigationController];

    // assign categories controller
    [_splitCascadeViewController setCategoriesViewController:categoriesViewController];
    
    // Override point for customization after application launch.
    self.window.rootViewController = _splitCascadeViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
