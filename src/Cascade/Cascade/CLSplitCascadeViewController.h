//
//  CLSplitCascadeViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCascadeContentNavigator.h"
#import "CLTableViewController.h"
#import "CLCascadeViewController.h"
#import "CLCategoriesView.h"

@interface CLSplitCascadeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    CLCategoriesView* _categoriesView;
    CLCascadeContentNavigator* _cascadeNavigator;
}

@property (nonatomic, retain) IBOutlet CLCategoriesView* categoriesView;
@property (nonatomic, retain) IBOutlet CLCascadeContentNavigator* cascadeNavigator;

@end
