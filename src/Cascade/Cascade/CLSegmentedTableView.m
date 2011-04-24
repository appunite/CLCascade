//
//  CLSegmentedTableView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLSegmentedTableView.h"


@interface CLSegmentedTableView (Private)
- (void) setupViews;
@end

@implementation CLSegmentedTableView

@dynamic tableView;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _tableViewStyle = style;
        [self setupViews];
    }
    return self;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    [super layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setupViews {
        
    [self.headerView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin];
    
    [self.footerView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin];
    
    [self.tableView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin | 
     UIViewAutoresizingFlexibleTopMargin | 
     UIViewAutoresizingFlexibleWidth | 
     UIViewAutoresizingFlexibleHeight];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _dataSource = nil;
    _delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark  Setter

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setDataSource:(id<UITableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self.tableView setDataSource: dataSource];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setDelegate:(id<UITableViewDelegate>)delegate {
    _delegate = delegate;
    [self.tableView setDelegate:delegate];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setTableView:(UITableView *)tableView {
    if (_contentView != tableView) {
        [_contentView release];
        _contentView = [tableView retain];
    }
}

- (UITableView*) tableView {
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
        [self addSubview: _contentView];
    }
    
    return (UITableView*)_contentView;
}

@end
