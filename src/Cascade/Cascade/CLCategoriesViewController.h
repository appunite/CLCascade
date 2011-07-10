//
//  CLCategoriesViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTableViewController.h"
#import "CLCategoriesView.h"
#import "CLCascadeNavigationController.h"

@interface CLCategoriesViewController : CLTableViewController {

}

- (id) initWithNavigationController:(CLCascadeNavigationController*)viewController;

@end
