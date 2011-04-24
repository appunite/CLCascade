//
//  CLSegmentedTableView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSegmentedView.h"

@interface CLSegmentedTableView : CLSegmentedView {
    UITableViewStyle _tableViewStyle;
    
    id<UITableViewDelegate> _delegate;
    id<UITableViewDataSource> _dataSource;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;

@property (nonatomic, assign) IBOutlet id<UITableViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<UITableViewDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
