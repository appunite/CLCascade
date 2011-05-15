//
//  CLRetractableSectionAppDelegate.h
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLRetractableSectionViewController;

@interface CLRetractableSectionAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CLRetractableSectionViewController *viewController;

@end
