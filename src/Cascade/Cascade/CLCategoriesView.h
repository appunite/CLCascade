//
//  CLCategoriesView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-30.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLCascadeContentNavigator.h"
#import "CLSegmentedTableView.h"

@class CLCascadeContentNavigator;

@interface CLCategoriesView : CLSegmentedTableView {
    CLCascadeContentNavigator*  _cascadeNavigator;
}

/*
 * Cascade navigator - correspondent content navigator
 */
@property (nonatomic, retain) IBOutlet CLCascadeContentNavigator*  cascadeNavigator;


@end
