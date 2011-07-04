//
//  UIViewController+CLSegmentedView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+CLSegmentedView.h"


@implementation UIViewController (UIViewController_CLSegmentedView)

@dynamic segmentedView;
@dynamic headerView;
@dynamic footerView;
@dynamic contentView;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLSegmentedView*) segmentedView {
    return (CLSegmentedView*)self.view;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) headerView {

    if (![self.view isKindOfClass:[CLSegmentedView class]]) return nil;
    
    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.headerView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) footerView {

    if (![self.view isKindOfClass:[CLSegmentedView class]]) return nil;
    
    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.footerView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) contentView {
    if (![self.view isKindOfClass:[CLSegmentedView class]]) return self.view;

    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.contentView;
}

@end
