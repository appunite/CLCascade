//
//  CLRetractableSectionViewController.h
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRetractableSectionHeaderView.h"
#import "CLRetractableSectionItem.h"
#import "CLRetractableSectionController.h"

@interface CLRetractableSectionViewController : UITableViewController {
    CLRetractableSectionController* _retractableSectionController;
}

@property (nonatomic, retain) CLRetractableSectionController* retractableSectionController;

@end
