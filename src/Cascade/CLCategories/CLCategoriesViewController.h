//
//  CLCategoriesViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Cascade/CLCustomViewControllers/CLTableViewController.h>
#import <Cascade/CLCategories/CLCategoriesView.h>
#import <Cascade/CLCascadeNavigationController/CLCascadeNavigationController.h>

@interface CLCategoriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableViewStyle _tableViewStyle;

}
@property (nonatomic, strong) UITableView *tableView;

- (id) initWithNavigationController:(CLCascadeNavigationController*)viewController;
- (id) initWithTableViewStyle:(UITableViewStyle)style;
- (id) initWithTableViewStyle:(UITableViewStyle)style size:(CLViewSize)size;

@end
