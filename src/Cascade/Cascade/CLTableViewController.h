//
//  CLTableViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLViewController.h"
#import "CLSegmentedTableView.h"

@class CLViewController;

@interface CLTableViewController : CLViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableViewStyle _tableViewStyle;
}

@property (nonatomic, retain) CLSegmentedTableView* view;
@property (nonatomic, retain, readonly) UITableView* tableView;

- (id) initWithTableViewStyle:(UITableViewStyle)style;

@end
