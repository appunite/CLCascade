//
//  UIViewController+CLSegmentedView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLSegmentedView.h"

@interface UIViewController (UIViewController_CLSegmentedView)

@property (nonatomic, readonly) UIView* headerView;
@property (nonatomic, readonly) UIView* footerView;
@property (nonatomic, readonly) UIView* contentView;

@property (nonatomic, readonly) CLSegmentedView* segmentedView;

@end
