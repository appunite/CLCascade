//
//  ExampleTableViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "ExampleWebViewController.h"
#import "ExampleXIBViewController.h"
#import "ExampleUITableViewController.h"

@implementation ExampleTableViewController
@synthesize tableView = _tableView;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadView {
    CLSegmentedView *view_ = [[CLSegmentedView alloc] initWithSize:CLViewSizeWider];
    self.view = view_;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:_tableViewStyle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [view_ setContentView:_tableView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithTableViewStyle:(UITableViewStyle)style size:(CLViewSize)size;
{
    self = [super initWithSize: size];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    // add shadow
    [self addLeftBorderShadowWithWidth:140.0 andOffset:0.0f];
    
    // add header view
    UIImageView* header = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45.0)];
    [header setImage: [UIImage imageNamed:@"ToolBar_479x45.png"]];
    [self.segmentedView setHeaderView: header];
    
    // show rounded corners
    [self setShowRoundedCorners: NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 8;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if (indexPath.row%4 == 0) {
        cell.textLabel.text = @"New Table View with CLSegmentedView";
    } else
        if (indexPath.row%4 == 1)  {
            cell.textLabel.text = @"New Web View";
        } else
            if (indexPath.row%4 == 2)  {
                cell.textLabel.text = @"New UITableViewController";
            }
            else
            {
                cell.textLabel.text = @"New View from XIB";
            }
    return cell;
}


#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* viewController = nil;
    
    if (indexPath.row%4 == 0) {
        viewController = [[ExampleTableViewController alloc] initWithTableViewStyle:UITableViewStylePlain size:CLViewSizeNormal];
    } else 
    if (indexPath.row%4 == 1) {
        viewController = [[ExampleWebViewController alloc] init];
    } else 
        if (indexPath.row%4 == 2) {
            viewController = [[ExampleUITableViewController alloc] initWithStyle:UITableViewStylePlain];
        } else
            viewController = [[ExampleXIBViewController alloc] initWithNibName:@"ExampleXIBViewController" bundle:nil size:CLViewSizeNormal];
    
    
    [self pushDetailViewController:viewController animated:YES];
}

@end
