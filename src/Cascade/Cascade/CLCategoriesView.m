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

@interface CLCategoriesView (Private)
- (void) setupViews;
@end

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
        [self setupViews];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setHeaderView:(UIView*)headerView {
    
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        [_headerView release];
        
        _headerView = [headerView retain];
        [_headerView setAutoresizingMask:
         UIViewAutoresizingFlexibleLeftMargin | 
         UIViewAutoresizingFlexibleRightMargin | 
         UIViewAutoresizingFlexibleTopMargin];
        
        [self addSubview: _headerView];
        [self setNeedsLayout];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setFooterView:(UIView*)footerView {
    
    if (_footerView != footerView) {
        [_footerView removeFromSuperview];
        [_footerView release];
        
        _footerView = [footerView retain];
        [_footerView setAutoresizingMask:
         UIViewAutoresizingFlexibleLeftMargin | 
         UIViewAutoresizingFlexibleRightMargin | 
         UIViewAutoresizingFlexibleBottomMargin];
        
        [self addSubview: _footerView];
        [self setNeedsLayout];
    }
}

#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    CGRect rect = self.bounds;
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    CGFloat headerHeight = 0.0;
    CGFloat footerHeight = 0.0;
    
    if (_headerView) {
        headerHeight = _headerView.frame.size.height;
        
        CGRect newHeaderViewFrame = CGRectMake(0.0, 0.0, viewWidth, headerHeight);
        [_headerView setFrame: newHeaderViewFrame];
    }
    
    if (_footerView) {
        footerHeight = _footerView.frame.size.height;
        CGFloat footerY = viewHeight - footerHeight;
        
        CGRect newFooterViewFrame = CGRectMake(0.0, footerY, viewWidth, footerHeight);
        [_footerView setFrame: newFooterViewFrame];
    }
    
    [_tableView setFrame: CGRectMake(0.0, headerHeight, viewWidth, viewHeight - headerHeight - footerHeight)];
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

#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setupViews {
    [_headerView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin];

    [_footerView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin];

    [_tableView setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin | 
     UIViewAutoresizingFlexibleTopMargin | 
     UIViewAutoresizingFlexibleWidth | 
     UIViewAutoresizingFlexibleHeight];
}

@end
