//
//  CLSplitCascadeView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLSplitCascadeView.h"
#import "CLCascadeViewController.h"

@implementation CLSplitCascadeView

@synthesize categoriesView = _categoriesView;
@synthesize cascadeNavigator = _cascadeNavigator;

#pragma mark - Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_categoriesView release], _categoriesView = nil;
    [_cascadeNavigator release], _cascadeNavigator = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    if ([_cascadeNavigator.rootViewController currentScrollPosition] == CLCascadeViewScrollMasterPosition) {

        if ((CGRectContainsPoint(_cascadeNavigator.frame, point)) && (CGRectContainsPoint(_categoriesView.frame, point))) {
            return [_categoriesView hitTest:point withEvent:event];
        }
    }
    
    return [super hitTest:point withEvent:event];
    
}

#pragma mark -
#pragma mark CLCascadeContentNavigatorDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) rootViewControllerMoveToMasterPosition {
    
}

- (void) rootViewControllerMoveToDetailPosition {
    
}

@end
