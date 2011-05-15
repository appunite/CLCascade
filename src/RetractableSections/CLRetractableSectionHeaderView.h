//
//  CLRetractableSectionHeaderView.h
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderViewDelegate;


@interface CLRetractableSectionHeaderView : UIView {

}

@property (nonatomic, assign) id <SectionHeaderViewDelegate> delegate;

@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, retain) UILabel *titleLabel;


- (id)initWithFrame:(CGRect)frame 
            section:(NSInteger)sectionNumber;

- (id)initWithFrame:(CGRect)frame 
              title:(NSString*)title 
            section:(NSInteger)sectionNumber;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol SectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(CLRetractableSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(CLRetractableSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

@end