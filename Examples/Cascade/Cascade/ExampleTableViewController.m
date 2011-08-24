//
//  ExampleTableViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "ExampleWebViewController.h"

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

#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CAGradientLayer*) outerLeftShadow {
    
    // generate default shadow
    CAGradientLayer* shadow = [CAGradientLayer layer];
    shadow.startPoint = CGPointMake(0, 0.5);
    shadow.endPoint = CGPointMake(1.0, 0.5);
    
    shadow.colors = [NSArray arrayWithObjects: 
                     (id)([[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor), 
                     (id)([[UIColor colorWithRed:0.208 green:0.165 blue:0.118 alpha:1.0] colorWithAlphaComponent: 0.35].CGColor), 
                     nil];
    
    return shadow;
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
    [header release];
    
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

    if (indexPath.row%2 == 0) {
        cell.textLabel.text = @"New Table View";
    } else {
        cell.textLabel.text = @"New Web View";
    }    
    return cell;
}


#pragma mark - Table view delegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLViewController* viewController = nil;
    
    if (indexPath.row%2 == 0) {
        viewController = [[ExampleTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
    } else {
        viewController = [[ExampleWebViewController alloc] init];
    } 
    
    [self pushDetailViewController:viewController animated:YES];
    [viewController release];
}

@end
