//
//  CLCategoriesViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCategoriesViewController.h"
#import "UIViewController+CLSegmentedView.h"

@implementation CLCategoriesViewController
@synthesize tableView = _tableView;

- (id) initWithNavigationController:(CLCascadeNavigationController*)viewController {
    self = [super init];
    if (self) {
        self.cascadeNavigationController = viewController;
        self.showRoundedCorners = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithTableViewStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        self.viewSize = CLViewSizeNormal;
        _tableViewStyle = style;
    }
    return self;
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
    if (nib) {
        NSBundle *bundle = self.nibBundle;
        if(!bundle) bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:nib ofType:@"nib"];
        
        if(path) {
            self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
            [self.view setBackgroundColor: [UIColor clearColor]];
            return;
        }
    }
    
    // create SegmentedView
    CLSegmentedView* view_ = [[CLSegmentedView alloc] initWithSize: self.viewSize];
    self.view = view_;
    
    UITableView* tableView_ = [[UITableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
    [tableView_ setDelegate: self];
    [tableView_ setDataSource: self];
    [self setTableView: tableView_];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    // set clear background color
    [view_ setBackgroundColor: [UIColor clearColor]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set clear background color
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark Getters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableView*) tableView {
    return (UITableView*)[self.segmentedView contentView];
}

#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setTableView:(UITableView *)newTableView {
    [newTableView setDirectionalLockEnabled: YES];
    [(CLSegmentedView*)self.view setContentView: newTableView];
}

@end
