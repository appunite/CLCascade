//
//  CLCategoriesView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-30.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLTableViewController.h"
#import "CLCascadeViewController.h"
#import "CLCascadeContentNavigator.h"

@class CLTableViewController;
@class CLCascadeViewController;
@class CLCascadeContentNavigator;

@interface CLCategoriesView : UIView {
    UIView* _headerView;
    UIView* _footerView;
    UITableView*    _tableView;
    CLCascadeContentNavigator*  _cascadeNavigator;
}

/*
 Header view - located on the top in categories view
 */
@property (nonatomic, retain, readonly) IBOutlet UIView* headerView;

/*
 Footer view - located on the bottom in categories view
 */
@property (nonatomic, retain, readonly) IBOutlet UIView* footerView;

/*
 Table view - located between header and footer view 
 */
@property (nonatomic, retain) IBOutlet UITableView* tableView;

/*
 Cascade navigator - correspondent content navigator
 */
@property (nonatomic, retain) IBOutlet CLCascadeContentNavigator*  cascadeNavigator;

/* 
 * If you want set header view (above tableView).
 * This methoad add headerView to view and layout all views
 */
- (void) setHeaderView:(UIView*)headerView;

/* 
 * If you want set footer view (belove tableView)
 * This methoad add footerView to view and layout all views
 */
- (void) setFooterView:(UIView*)footerView;


@end
