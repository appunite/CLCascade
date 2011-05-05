//
//  CLDetailTableViewController.h
//  ExtraDetailTableView
//
//  Created by Emil Wojtaszek on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol CLDetailTableViewDelegate;

@interface CLDetailTableViewController : UITableViewController {
    NSIndexPath* _panIndexPath;
    
    CAGradientLayer* _shadowAboveDetailView;
    CAGradientLayer* _shadowUnderDetailView;
    
    UIPanGestureRecognizer* _gestureRecognizer;
    
    UIView* _detailView;
    
    BOOL    _showShadows;
    BOOL    _hideDetailViewWhenTouchEnd;
    
    CGFloat _cellHeight;
    
    id<CLDetailTableViewDelegate> _delegate;
    
}

@property (nonatomic, assign) id<CLDetailTableViewDelegate> delegate;
@property (nonatomic, retain, readonly) UIView* detailView;
@property (nonatomic, retain, readonly) NSIndexPath* panIndexPath;


// you can define you own shadows
@property (nonatomic, retain) CAGradientLayer* shadowAboveDetailView;
@property (nonatomic, retain) CAGradientLayer* shadowUnderDetailView;

// if you want to show shadows, set YES
@property (nonatomic, assign) BOOL showShadows;

// if you want to hide detail view when touch end, set YES
@property (nonatomic, assign) BOOL hideDetailViewWhenTouchEnd;

// use this method, when you create cell
- (void) addDefaultGestureRecognizerToCell:(UITableViewCell*)cell;

- (void) addShadowsToCell:(UITableViewCell*)cell  withAnimation:(BOOL)animation;
- (void) removeShadowsWithAnimation:(BOOL)animation;

- (void) hideDetailViewWithAnimation:(BOOL)animation;

@end

@protocol CLDetailTableViewDelegate <NSObject>

@required
- (UIView *) detailViewAtIndexPath:(NSIndexPath*)indexPath; 

@optional
- (void) tableView:(UITableView*)tableView willShowDetailView:(UIView*)detailView;
- (void) tableView:(UITableView*)tableView didShowDetailView:(UIView*)detailView;

- (void) tableView:(UITableView*)tableView willHideDetailView:(UIView*)detailView;
- (void) tableView:(UITableView*)tableView didHideDetailView:(UIView*)detailView;

- (void) tableView:(UITableView*)tableView didChangedSize:(CGSize)newSize ofDetailView:(UIView*)detailView;

@end
