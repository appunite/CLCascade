//
//  CLDetailTableViewController.m
//  ExtraDetailTableView
//
//  Created by Emil Wojtaszek on 11-05-04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLDetailTableViewController.h"

#define HEADER_HEIGHT 65.00f
#define MIN_DETAILVIEW_OFFSET 10.00f
#define SHADOW_ANIMATION_DURATION 0.20f
#define DETAILVIEW_ANIMATION_DURATION 0.15f

@implementation CLDetailTableViewController

@synthesize shadowAboveDetailView = _shadowAboveDetailView;
@synthesize shadowUnderDetailView = _shadowUnderDetailView;
@synthesize showShadows = _showShadows;
@synthesize delegate = _delegate;
@synthesize hideDetailViewWhenTouchEnd = _hideDetailViewWhenTouchEnd;

@synthesize detailView = _detailView;
@synthesize panIndexPath = _panIndexPath;

- (void)dealloc
{
    [_detailView release];
    [_panIndexPath release];
    [_shadowAboveDetailView release];
    [_shadowUnderDetailView release];
    _delegate = nil;
    
    [super dealloc];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}

#pragma mark - 
#pragma Pan Gesture

// add default gesture recognizer to show detail view (UIPanGestureRecognizer)
- (void) addDefaultGestureRecognizerToCell:(UITableViewCell*)cell {
    UIPanGestureRecognizer* gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [gestureRecognizer setMaximumNumberOfTouches: 2];
    [gestureRecognizer setMinimumNumberOfTouches: 2];
    [cell addGestureRecognizer: gestureRecognizer];
    [gestureRecognizer release];
}

// pan gesture action
- (void) panGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint panLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *newPanIndexPath = [self.tableView indexPathForRowAtPoint:panLocation];
		_panIndexPath = [newPanIndexPath retain];
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath: newPanIndexPath];
        
        _cellHeight = cell.bounds.size.height;
        
        if (_showShadows) {
            [self addShadowsToCell:cell withAnimation:YES];
        }
        
        _detailView = [_delegate detailViewAtIndexPath: _panIndexPath];
        
        [_detailView removeFromSuperview];
        [_detailView setFrame: cell.frame];
        [_detailView setAlpha: 1.0];

        if ([_delegate respondsToSelector:@selector(tableView:willShowDetailView:)]) {
            [_delegate tableView:self.tableView willShowDetailView:_detailView];
        }
                
        [self.tableView addSubview: _detailView];
        
        if ([_delegate respondsToSelector:@selector(tableView:didShowDetailView:)]) {
            [_delegate tableView:self.tableView didShowDetailView:_detailView];
        }
    }
    else {
        if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath: _panIndexPath];
            CGPoint panLocation = [gestureRecognizer locationInView:cell];
            
            CGRect frame = _detailView.frame;
            frame.size.height = MAX(panLocation.y, _cellHeight);
            
            [_detailView setFrame: frame];
            
            if ([_delegate respondsToSelector:@selector(tableView:didChangedSize:ofDetailView:)]) {
                [_delegate tableView:self.tableView didChangedSize:frame.size ofDetailView: _detailView];
            }
            
        }
        else if ((gestureRecognizer.state == UIGestureRecognizerStateCancelled) || (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
            CGRect detailViewFrame = _detailView.frame;
            
            if (_hideDetailViewWhenTouchEnd || ((detailViewFrame.size.height - _cellHeight) < MIN_DETAILVIEW_OFFSET)) {
                [self hideDetailViewWithAnimation: YES];
                [_panIndexPath release], _panIndexPath = nil;
            }
        }
    }
    
}

#pragma mark -
#pragma mark Detail View

- (void) hideDetailViewWithAnimation:(BOOL)animation {
    
    if (_detailView != nil) {
        if (animation) {
            
            if ([_delegate respondsToSelector:@selector(tableView:willHideDetailView:)]) {
                [_delegate tableView:self.tableView willHideDetailView:_detailView];
            }
            
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath: _panIndexPath];
            CGRect rect = cell.frame;
            [UIView animateWithDuration:DETAILVIEW_ANIMATION_DURATION 
                                  delay:0.0 
                                options:UIViewAnimationOptionAllowUserInteraction 
                             animations:^{
                                 [_detailView setFrame: rect];
                                 [_detailView setAlpha: 0.0];
                             } 
                             completion:^(BOOL finished) {
                                 [_detailView removeFromSuperview];
                                 _detailView = nil;
                                 
                                 if ([_delegate respondsToSelector:@selector(tableView:didHideDetailView:)]) {
                                     [_delegate tableView:self.tableView didHideDetailView:_detailView];
                                 }
                                 
                             }];
        } else {
            [_detailView removeFromSuperview];
        }
    }
    
    [self removeShadowsWithAnimation: animation];
}

#pragma mark -
#pragma mark Shadows

- (void) removeShadowsWithAnimation:(BOOL)animation {    
    
    // add animation
    if (animation) {
        
        CABasicAnimation *shadowAboveOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shadowAboveOpacityAnimation.duration = SHADOW_ANIMATION_DURATION;
        shadowAboveOpacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        shadowAboveOpacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
        shadowAboveOpacityAnimation.fillMode = kCAFillModeForwards;
        shadowAboveOpacityAnimation.delegate = self;
        shadowAboveOpacityAnimation.removedOnCompletion = YES;
        [_shadowAboveDetailView addAnimation:shadowAboveOpacityAnimation forKey:@"shadowAboveOpacityAnimation"];
        
        CABasicAnimation *shadowUnderOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shadowUnderOpacityAnimation.duration = SHADOW_ANIMATION_DURATION;
        shadowUnderOpacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        shadowUnderOpacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
        shadowUnderOpacityAnimation.fillMode = kCAFillModeForwards;
        shadowUnderOpacityAnimation.delegate = self;
        shadowUnderOpacityAnimation.removedOnCompletion = YES;
        [_shadowUnderDetailView addAnimation:shadowUnderOpacityAnimation forKey:@"shadowUnderOpacityAnimation"];
        
    } else {
        [_shadowAboveDetailView removeFromSuperlayer];
        _shadowAboveDetailView = nil;
        [_shadowUnderDetailView removeFromSuperlayer];
        _shadowUnderDetailView = nil;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *animation = (CABasicAnimation*)anim;
    
    if ([animation.keyPath isEqualToString:@"opacity"]) {
        [_shadowAboveDetailView removeFromSuperlayer];
        _shadowAboveDetailView = nil;
        [_shadowUnderDetailView removeFromSuperlayer];
        _shadowUnderDetailView = nil;
    }
}

- (void) addShadowsToCell:(UITableViewCell*)cell withAnimation:(BOOL)animation {
    
    [self removeShadowsWithAnimation: NO];
    
    // define shadow colors
    CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent: 0.50].CGColor;
    CGColorRef grayColor = [[UIColor blackColor] colorWithAlphaComponent: 0.35].CGColor;
    CGColorRef lightColor = [[UIColor blackColor] colorWithAlphaComponent:0.25].CGColor;
    
    
    // create layers if don't exist
    if (_shadowAboveDetailView == nil) {
        
        _shadowAboveDetailView = [CAGradientLayer layer];
        _shadowAboveDetailView.colors = [NSArray arrayWithObjects: 
                                         (id)(lightColor), 
                                         (id)(grayColor), 
                                         (id)(darkColor), 
                                         nil];
        
        _shadowAboveDetailView.locations = [NSArray arrayWithObjects: 
                                            [NSNumber numberWithFloat: 0.25], 
                                            [NSNumber numberWithFloat: 0.96], 
                                            [NSNumber numberWithFloat: 1.00], 
                                            nil];
        
        
    }
    
    if (_shadowUnderDetailView == nil) {
        
        _shadowUnderDetailView = [CAGradientLayer layer];
        _shadowUnderDetailView.colors = [NSArray arrayWithObjects: 
                                         (id)(darkColor), 
                                         (id)(grayColor), 
                                         (id)(lightColor), 
                                         nil];
        
        _shadowUnderDetailView.locations = [NSArray arrayWithObjects: 
                                            [NSNumber numberWithFloat: 0.00], 
                                            [NSNumber numberWithFloat: 0.04], 
                                            [NSNumber numberWithFloat: 0.75], 
                                            nil];
        
    }
    
    if (animation) {
        _shadowAboveDetailView.opacity = 0.0;
        _shadowUnderDetailView.opacity = 0.0;
    }
    
    // calculate cell postion
    CGFloat topSahdowHeight = cell.frame.origin.y - self.tableView.contentOffset.y;
    CGFloat bottomShadowHeight = self.tableView.bounds.size.height - topSahdowHeight - cell.frame.size.height;
    
    // calculate frames
    CGRect newShadowFrame1 = CGRectMake(0, self.tableView.contentOffset.y, self.tableView.bounds.size.width, topSahdowHeight);
    _shadowAboveDetailView.frame = newShadowFrame1;
    
    CGRect newShadowFrame2 = CGRectMake(0,  cell.frame.origin.y + cell.frame.size.height, self.tableView.bounds.size.width, bottomShadowHeight);
    _shadowUnderDetailView.frame = newShadowFrame2;
    
    // add layers
    [self.tableView.layer addSublayer:_shadowAboveDetailView];
    [self.tableView.layer addSublayer:_shadowUnderDetailView];
    
    // add animation
    if (animation) {
        
        CABasicAnimation *shadowAboveOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shadowAboveOpacityAnimation.duration = SHADOW_ANIMATION_DURATION;
        shadowAboveOpacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        shadowAboveOpacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
        shadowAboveOpacityAnimation.fillMode = kCAFillModeForwards;
        shadowAboveOpacityAnimation.removedOnCompletion = NO;
        [_shadowAboveDetailView addAnimation:shadowAboveOpacityAnimation forKey:@"shadowAboveOpacityAnimation"];
        
        CABasicAnimation *shadowUnderOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shadowUnderOpacityAnimation.duration = SHADOW_ANIMATION_DURATION;
        shadowUnderOpacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        shadowUnderOpacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
        shadowUnderOpacityAnimation.fillMode = kCAFillModeForwards;
        shadowUnderOpacityAnimation.removedOnCompletion = NO;
        [_shadowUnderDetailView addAnimation:shadowUnderOpacityAnimation forKey:@"shadowUnderOpacityAnimation"];
        
        
    }
}

@end