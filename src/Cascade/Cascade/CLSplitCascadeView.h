//
//  CLSplitCascadeView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCascadeContentNavigator.h"
#import "CLCategoriesView.h"

@interface CLSplitCascadeView : UIView <CLCascadeContentNavigatorDelegate> {
    CLCategoriesView* _categoriesView;
    CLCascadeContentNavigator* _cascadeNavigator;
}

/*
 Categories view - located on the left, view containing table view
 */
@property (nonatomic, retain) IBOutlet CLCategoriesView* categoriesView;

/*
 Cascade content navigator - located on the right, view containing cascade view controllers
 */
@property (nonatomic, retain) IBOutlet CLCascadeContentNavigator* cascadeNavigator;

@end
