//
//  ExampleCategoriesViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleCategoriesViewController.h"


@implementation ExampleCategoriesViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //disable tableview separator
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];

    // set background of tableview
    UIView* backgrounView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgrounView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"brown_bg_128x128.png"]]];
    [self.tableView setBackgroundView:backgrounView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - 
#pragma mark Table view data source - Categories

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
    return 10;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0]];
        [cell.textLabel setTextColor: [UIColor colorWithRed:0.894117 green:0.839215 blue:0.788235 alpha:1.0]];
        [cell.textLabel setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];

        UIImage *backgroundImage = [[UIImage imageNamed:@"LightBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cell.backgroundView.frame = cell.bounds;
        cell.backgroundView.alpha = 0.5;
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Category: %i", indexPath.row];
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if you select row, then create and push custom UIViewController
    ExampleTableViewController* rootTableViewController = [[ExampleTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
    [self.cascadeNavigationController setRootViewController:rootTableViewController animated:YES];
    
}

@end
