//
//  CLCategoriesView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-30.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLCategoriesView.h"
#import "CLTableViewController.h"
#import "CLCascadeViewController.h"
#import "CLCascadeContentNavigator.h"

@implementation CLCategoriesView

@synthesize footerView = _footerView;
@synthesize headerView = _headerView;
@synthesize tableView = _tableView;
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
    [_footerView release], _footerView = nil;
    [_cascadeNavigator release], _cascadeNavigator = nil;
    [_headerView release], _headerView = nil;
    [_tableView release], _tableView = nil;
    [super dealloc];
}

@end
