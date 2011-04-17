//
//  CLTableViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLTableViewController.h"
@interface CLTableViewController (Private)
- (void)titleViewTap:(UITapGestureRecognizer*)recognizer;
@end

@implementation CLTableViewController

#define DEF_TITLE_VIEW_HEIGHT 45

@synthesize tableView = _tableView;
@synthesize titleView = _titleView;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithTableViewStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_tableView release], _tableView = nil;
    [_titleView release], _titleView = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateLayout {

    [super updateLayout];

    CLCascadeContentNavigator* contentNavigator = [self.parentCascadeViewController contentNavigator];
    CGSize pageSize = [contentNavigator masterCascadeFrame].size;
    
    [_titleView setFrame: CGRectMake(0.0, 0.0, pageSize.width, DEF_TITLE_VIEW_HEIGHT)];
    [_tableView setFrame: CGRectMake(0.0, DEF_TITLE_VIEW_HEIGHT, pageSize.width, pageSize.height - DEF_TITLE_VIEW_HEIGHT)];
    //    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];

}

#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view setBackgroundColor: [UIColor clearColor]];
    
    _titleView = [[CLTitleView alloc] init];
    [self.view addSubview:_titleView];      
    
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewTap:)];
    [_titleView addGestureRecognizer: gestureRecognizer];
    [gestureRecognizer release];

    _tableView = [[UITableView alloc] initWithFrame: CGRectZero style:_tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setDirectionalLockEnabled: YES];
    [self.view addSubview:_tableView];

    [self updateLayout];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [_tableView release], _tableView = nil;
    [_titleView release], _titleView = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - Table view data source

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"text";
    return cell;
}


#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLTableViewController* viewController = [[CLTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
    [self pushDetailViewController: viewController];
    [viewController release];
}

#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)titleViewTap:(UITapGestureRecognizer*)recognizer {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];    
}


@end
