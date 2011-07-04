//
//  ExampleTableViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "UIColor+Random.h"
#import "CascadeAppDelegate.h"

@implementation ExampleTableViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [super dealloc];
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
    [self setOuterLeftShadow:[UIColor colorWithRed:0.208 green:0.165 blue:0.118 alpha:1.0] width:40.0 alpha:0.35 animated:YES];
        
    // add header view
    UIImageView* header = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45.0)];
    [header setImage: [UIImage imageNamed:@"ToolBar_479x45.png"]];
    [self.segmentedView setHeaderView: header];
    [header release];
	
	// sets a random color for the background, to clarify which views we are dragging and pushing
	self.tableView.backgroundColor = [UIColor randomColor];

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
    ExampleTableViewController* viewController = [[ExampleTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
	
	// The following alternates the view width, creating a wide or a narrow view to test dragging and pushing
	CascadeAppDelegate *appDel = [[UIApplication sharedApplication] delegate];
	if (appDel.wideView) {
		CGRect viewSize = viewController.view.frame;
		viewSize.size.width = 600.f;
		viewSize.size.height = 600.f;
		viewController.view.frame = viewSize;
	}
	appDel.wideView = !appDel.wideView;
	
    [self pushDetailViewController:viewController animated:YES];
	viewController.tableView.backgroundColor = [UIColor randomColor];
	[viewController.view setNeedsDisplay];
    [viewController release];
}

@end
