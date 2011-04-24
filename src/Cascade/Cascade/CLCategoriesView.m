//
//  CLCategoriesView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-30.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLCategoriesView.h"

@implementation CLCategoriesView

@synthesize cascadeNavigator = _cascadeNavigator;

#pragma mark - 
#pragma mark dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_cascadeNavigator release], _cascadeNavigator = nil;
    [super dealloc];
}

@end
