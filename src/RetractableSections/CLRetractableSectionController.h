//
//  CLRetractableSectionController.h
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLRetractableSectionHeaderView.h"
#import "CLRetractableSectionItem.h"

@class CLRetractableSectionHeaderView;

@interface CLRetractableSectionController : NSObject <SectionHeaderViewDelegate> {

    NSInteger _openSectionIndex;

    UITableView* _tableView;
    NSMutableArray* _sectionList;
    
    UITableViewRowAnimation _insertAnimation;
    UITableViewRowAnimation _deleteAnimation;

}

@property (nonatomic, assign, readonly) NSInteger openSectionIndex;

@property (nonatomic, assign) UITableViewRowAnimation insertAnimation;
@property (nonatomic, assign) UITableViewRowAnimation deleteAnimation;

- (id) initWithTableView:(UITableView*)tableView;
- (NSUInteger) numberOfRows:(NSUInteger)rows inSection:(NSUInteger)section;

- (void) reloadSectionsList:(NSUInteger)sectionsCount;

- (CLRetractableSectionItem*) sectionItemAtIndex:(NSUInteger)section;

//- (CLRetractableSectionHeaderView*) addHeaderViewToSection:(NSUInteger)section;
//- (CLRetractableSectionHeaderView*) headerView:(CLRetractableSectionHeaderView*)headerView forSection:(NSUInteger)section;

@end
