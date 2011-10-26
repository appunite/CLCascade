//
//  CLTableViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Cascade/CLCustomViewControllers/CLViewController.h>


@interface CLTableViewController : CLViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableViewStyle _tableViewStyle;
}

@property (nonatomic, strong) UITableView *tableView;

- (id) initWithTableViewStyle:(UITableViewStyle)style;
- (id) initWithTableViewStyle:(UITableViewStyle)style size:(CLViewSize)size;

@end
