//
//  ExtraDetailTableViewViewController.h
//  ExtraDetailTableView
//
//  Created by Emil Wojtaszek on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDetailTableViewController.h"

@interface ExtraDetailTableViewViewController : CLDetailTableViewController <CLDetailTableViewDelegate> {
    // my detial view (in this case tableView)
    UITableView* _detailTableView;
}

@end
