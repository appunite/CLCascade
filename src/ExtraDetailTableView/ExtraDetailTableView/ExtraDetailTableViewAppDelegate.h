//
//  ExtraDetailTableViewAppDelegate.h
//  ExtraDetailTableView
//
//  Created by Emil Wojtaszek on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtraDetailTableViewViewController;

@interface ExtraDetailTableViewAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ExtraDetailTableViewViewController *viewController;

@end
