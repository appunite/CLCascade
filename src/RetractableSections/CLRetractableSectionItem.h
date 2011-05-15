//
//  CLRetractableSectionItem.h
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLRetractableSectionHeaderView;

@interface CLRetractableSectionItem : NSObject {
	
}

@property (nonatomic, assign) BOOL open;
@property (nonatomic, retain) CLRetractableSectionHeaderView* headerView;


@end
