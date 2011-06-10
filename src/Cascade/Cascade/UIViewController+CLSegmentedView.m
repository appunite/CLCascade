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
- (void) loadView {
    NSString *nib = self.nibName;

    if (nib) {
        NSBundle *bundle = self.nibBundle;
        if(!bundle) bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:nib ofType:@"nib"];
        
        if(path) {
            self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
            return;
        }
    }
    
    CLSegmentedView* view_ = [[CLSegmentedView alloc] init];
    self.view = view_;
    [view_ release];
}


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
    if (![self.view isKindOfClass:[CLSegmentedView class]]) return nil;

    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.contentView;
}

@end
