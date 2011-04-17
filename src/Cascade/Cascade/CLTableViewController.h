//
//  CLTableViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLViewController.h"
#import "CLTitleView.h"

@class CLViewController;

@interface CLTableViewController : CLViewController <UITableViewDataSource, UITableViewDelegate> {
    CLTitleView* _titleView;
    UITableView*    _tableView;
    UITableViewStyle _tableViewStyle;
}

@property (nonatomic, retain) CLTitleView*  titleView;
@property (nonatomic, retain) UITableView*  tableView;

- (id) initWithTableViewStyle:(UITableViewStyle)style;

@end
