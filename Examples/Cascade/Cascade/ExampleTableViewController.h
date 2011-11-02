//
//  ExampleTableViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cascade/Cascade.h>

// We could also inherits from CLTableViewController
// This is just to show how to use a standard UIViewController and place a content view !

@interface ExampleTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableViewStyle _tableViewStyle;
}

@property (nonatomic, strong) UITableView *tableView;

- (id) initWithTableViewStyle:(UITableViewStyle)style size:(CLViewSize)size;

@end
