//
//  CLSplitCascadeViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLSplitCascadeViewController.h"

@implementation CLSplitCascadeViewController

@synthesize categoriesView = _categoriesView;
@synthesize cascadeNavigator = _cascadeNavigator;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_categoriesView release], _categoriesView = nil;
    [_cascadeNavigator release], _cascadeNavigator = nil;
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

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.cascadeNavigator adjustFrameAndContentAfterRotation: UIInterfaceOrientationPortrait];        
//    [self.categoriesView.tableView setBackgroundColor:[UIColor redColor]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.categoriesView = nil;
    self.cascadeNavigator = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self.cascadeNavigator adjustFrameAndContentAfterRotation: interfaceOrientation];
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLTableViewController* rootTableViewController = [[CLTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
    CLCascadeViewController* rootCascadeViewController = [[CLCascadeViewController alloc] initWithMasterPositionViewController:rootTableViewController];
    
    [self.cascadeNavigator setRootViewController: rootCascadeViewController];
    
    [rootTableViewController release];
    [rootCascadeViewController release];
}

@end
