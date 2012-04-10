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

@implementation ExampleTableViewController


///////////////////////////////////////////////////////////////////////////////////////////////////

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
    return 6;
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

    if (indexPath.row%3 == 0) {
        cell.textLabel.text = @"New Table View";
    } else
    if (indexPath.row%3 == 1)  {
        cell.textLabel.text = @"New Web View";
    } else
    {
        cell.textLabel.text = @"New View from XIB";
    }
    return cell;
}


#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLViewController* viewController = nil;
    
    if (indexPath.row%3 == 0) {
        viewController = [[ExampleTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
    } else 
    if (indexPath.row%3 == 1) {
        viewController = [[ExampleWebViewController alloc] init];
    } else 
    {
        viewController = [[ExampleXIBViewController alloc] initWithNibName:@"ExampleXIBViewController" bundle:nil size:CLViewSizeNormal];
    }
    
    [self pushDetailViewController:viewController animated:YES];
}

@end
