//
//  CLTableViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLTableViewController.h"

@implementation CLTableViewController

@dynamic view;
@dynamic tableView;

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
    self.tableView = nil;
    self.view = nil;
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
- (void) loadView {
    NSString *nib = self.nibName;
    NSBundle *bundle = self.nibBundle;
    
    if(!nib) nib = NSStringFromClass([self class]);
    if(!bundle) bundle = [NSBundle mainBundle];
    
    NSString *path = [bundle pathForResource:nib ofType:@"nib"];
    
    if(path) {
        self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
        [self.view setBackgroundColor: [UIColor clearColor]];
        return;
    }
    
    // create SegmentedView
    CLSegmentedView* view_ = [[CLSegmentedView alloc] init];
    self.view = view_;
    [view_ release];
    
    UITableView* tableView_ = [[UITableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
    [tableView_ setDirectionalLockEnabled: YES];
    [tableView_ setDelegate: self];
    [tableView_ setDataSource: self];
    [view_ setContentView: tableView_];
    [tableView_ release];
    
    // set clear background color
    [view_ setBackgroundColor: [UIColor clearColor]];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // set new content view (tableView)
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
    CLTableViewController* viewController = [[CLTableViewController alloc] initWithTableViewStyle: UITableViewStylePlain];
    [self pushDetailViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark -
#pragma mark Getters

- (UITableView*) tableView {
    return (UITableView*)[self.segmentedView contentView];
}

- (void) setTableView:(UITableView *)newTableView {
    [self.segmentedView setContentView: newTableView];
}

//#pragma mark -
//#pragma mark Class methods
//
//- (CLSegmentedView*) segmentedView {
//    return (CLSegmentedView*)self.view;
//}

@end
