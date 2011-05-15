//
//  CLRetractableSectionController.m
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLRetractableSectionController.h"

@implementation CLRetractableSectionController

#define DEFAULT_HEADER_HEIGHT 45

@synthesize openSectionIndex = _openSectionIndex;;
@synthesize insertAnimation = _insertAnimation;
@synthesize deleteAnimation = _deleteAnimation;

#pragma mark -
#pragma mark Init & dealloc

- (id) initWithTableView:(UITableView*)tableView {
    self = [super init];
    if (self) {
        _tableView = [tableView retain];
        _insertAnimation = UITableViewRowAnimationFade;
        _deleteAnimation = UITableViewRowAnimationFade;
        _openSectionIndex = NSNotFound;
        
    }
    return self;
}

- (void)dealloc {
    [_tableView release], _tableView = nil;
    [_sectionList release], _sectionList = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Class methods

- (CLRetractableSectionItem*) sectionItemAtIndex:(NSUInteger)section {
    return [_sectionList objectAtIndex: section];
}

- (NSUInteger) numberOfRows:(NSUInteger)rows inSection:(NSUInteger)section {
	CLRetractableSectionItem *sectionInfo = [_sectionList objectAtIndex:section];
    return sectionInfo.open ? rows : 0;
}

- (void) reloadSectionsList:(NSUInteger)sectionsCount {

    if ((_sectionList == nil) || ([_sectionList count] != sectionsCount)) {
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        
        for (NSInteger i = 0; i<sectionsCount; i++) {
            CLRetractableSectionItem *sectionItem = [[CLRetractableSectionItem alloc] init];			
            
            sectionItem.open = NO;
            
            [array addObject:sectionItem];
            [sectionItem release];
        }
        
        _sectionList = array;
    }

}

#pragma mark -
#pragma mark Section header delegate

-(void)sectionHeaderView:(CLRetractableSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
	
	CLRetractableSectionItem *sectionInfo = [_sectionList objectAtIndex:sectionOpened];
	
	sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = 2;
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		
		CLRetractableSectionItem *previousOpenSection = [_sectionList objectAtIndex:previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = 2;//[previousOpenSection.play.quotations count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = _insertAnimation;
        deleteAnimation = _deleteAnimation;
    }
    else {
        insertAnimation = _deleteAnimation;
        deleteAnimation = _insertAnimation;
    }
    
    // Apply the updates.
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [_tableView endUpdates];

    _openSectionIndex = sectionOpened;
    
    [indexPathsToInsert release];
    [indexPathsToDelete release];
}


-(void)sectionHeaderView:(CLRetractableSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	CLRetractableSectionItem *sectionInfo = [_sectionList objectAtIndex:sectionClosed];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [_tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
        [indexPathsToDelete release];
    }
    
    _openSectionIndex = NSNotFound;
}

@end
