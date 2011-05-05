//
//  ExtraDetailTableViewViewController.m
//  ExtraDetailTableView
//
//  Created by Emil Wojtaszek on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtraDetailTableViewViewController.h"

#define HEADER_HEIGHT 78.0f

@implementation ExtraDetailTableViewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _detailTableView = [[UITableView alloc] init];
    
    [_detailTableView setBackgroundColor: [UIColor purpleColor]];
    [_detailTableView setAllowsSelection: NO];
    [_detailTableView setDataSource: self];
    [_detailTableView setDelegate: self];

    [self.tableView setAllowsSelection: NO];
    
    self.delegate = self;
    self.showShadows = YES;
    self.hideDetailViewWhenTouchEnd = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_detailTableView release], _detailTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return HEADER_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (tableView != _detailTableView) {
            
            // ad default gesture recognizser (UIPanGestureRecognizer)
            // you can implement here other recognizer, if you want
            [self addDefaultGestureRecognizerToCell: cell];
        }
    }
    
    // Configure the cell...
    cell.textLabel.text = @"text";
    
    NSUInteger index = indexPath.row % 6;
    cell.imageView.image = [UIImage imageNamed: [NSString stringWithFormat: @"%i.png", index]];
    
    return cell;
}

#pragma mark -
#pragma mark CLDetailTableViewDelegate

// return the detail view (in this case detail table view)
- (UIView *) detailViewAtIndexPath:(NSIndexPath*)indexPath {
    return _detailTableView;
}

- (void) tableView:(UITableView*)tableView willShowDetailView:(UIView *)detailView {
    [_detailTableView scrollRectToVisible: CGRectZero animated: NO];
}

- (void) tableView:(UITableView*)tableView didShowDetailView:(UIView*)detailView {
    [_detailTableView flashScrollIndicators];
}


#pragma mark -
#pragma mark UIScrollView delegate

// you can implement did delegate method if you want to hide detailView when table view did scroll
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (aScrollView != _detailTableView) {
        [self hideDetailViewWithAnimation: YES];
    }
}

@end
