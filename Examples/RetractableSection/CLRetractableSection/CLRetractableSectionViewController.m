//
//  CLRetractableSectionViewController.m
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLRetractableSectionViewController.h"

#define DEFAULT_ROW_HEIGHT 78
#define HEADER_HEIGHT 45

@implementation CLRetractableSectionViewController

@synthesize retractableSectionController = _retractableSectionController;

#pragma mark - View lifecycle

- (void)dealloc {
    [_retractableSectionController release], _retractableSectionController = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
    
    // create section controller
    _retractableSectionController = [[CLRetractableSectionController alloc] initWithTableView: self.tableView];
    
    // add section list
    NSUInteger sectionCount = [self numberOfSectionsInTableView:self.tableView];
    [_retractableSectionController reloadSectionsList: sectionCount];

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


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {

    // section view for section index
    
    CLRetractableSectionItem *sectionInfo = [_retractableSectionController sectionItemAtIndex:section];

    if (!sectionInfo.headerView) {
        sectionInfo.headerView = [[[CLRetractableSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_HEIGHT) title:@"sdfsdf" section:section] autorelease];
        [sectionInfo.headerView setDelegate: _retractableSectionController];
    }
    
    return sectionInfo.headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return DEFAULT_ROW_HEIGHT;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSInteger ilosc_rekordow_w_sekcji = 2;
    return [_retractableSectionController numberOfRows:ilosc_rekordow_w_sekcji inSection:section];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"sdfs";
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
