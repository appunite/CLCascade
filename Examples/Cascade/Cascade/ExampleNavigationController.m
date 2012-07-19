//
//  ExampleNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 13.09.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleNavigationController.h"

@implementation ExampleNavigationController

static CGFloat kImageWidth = 49.0f;
static CGFloat kImageHeight = 78.0f;

static CGFloat kLeftPadding = 320.0f;
static CGFloat kLeftOffset = 15.0f;
static CGFloat kTopOffset = 10.0f;

- (void)dealloc {
    _staticDetachImage = nil;
    _dynamicDetachImage = nil;
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* image = [UIImage imageNamed:@"detached_image.png"];
    CGRect rect = self.view.bounds;
    
    CGRect staticDetachImageRect = CGRectMake(kLeftPadding, rect.size.height/2 - image.size.height/2, kImageWidth, kImageHeight);
    _staticDetachImage = [[UIImageView alloc] initWithFrame:staticDetachImageRect];
    [_staticDetachImage setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
    [_staticDetachImage setImage:image];
    [self.view insertSubview:_staticDetachImage atIndex:0];
    [_staticDetachImage setHidden: YES];
    
    CGRect dynamicDetachImageRect = CGRectOffset(staticDetachImageRect, kLeftOffset, kTopOffset);
    _dynamicDetachImage = [[UIImageView alloc] initWithFrame:dynamicDetachImageRect];
    [_dynamicDetachImage setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
    [_dynamicDetachImage setImage:image];
    [self.view insertSubview:_dynamicDetachImage atIndex:1];
    [_dynamicDetachImage setHidden: YES];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    
    _staticDetachImage = nil;
    _dynamicDetachImage = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewDidStartPullingToDetachPages:(CLCascadeView*)cascadeView {
    [super cascadeViewDidStartPullingToDetachPages:cascadeView];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^ {
        CGRect rect = self.view.bounds;
        
        //set point of rotation
        _dynamicDetachImage.center = CGPointMake(65.0f + kLeftPadding + kImageWidth/2, 12.0f + rect.size.height/2);
        
        // The transform matrix
        CGAffineTransform transform = 
        CGAffineTransformMakeRotation(0.4f);
        //    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
        _dynamicDetachImage.transform = transform;
        _dynamicDetachImage.alpha = 0.5;
    }
                     completion:^(BOOL finish) {
                     }];
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewDidCancelPullToDetachPages:(CLCascadeView*)cascadeView {
    [super cascadeViewDidCancelPullToDetachPages:cascadeView];
    
    CGRect rect = self.view.bounds;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^ {
        //set point of rotation
        _dynamicDetachImage.center = CGPointMake(kLeftOffset + kLeftPadding + kImageWidth/2.0f, kTopOffset + rect.size.height/2);
        
        // The transform matrix
        CGAffineTransform transform = 
        CGAffineTransformMakeRotation(0.0);
        _dynamicDetachImage.transform = transform;
        _dynamicDetachImage.alpha = 1.0;
    }
     
                     completion:^(BOOL finish) {
                     }];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewDidPullToDetachPages:(CLCascadeView*)cascadeView {
    [super cascadeViewDidPullToDetachPages:cascadeView];
    
    id view = [[(UIViewController*)self.rootViewController segmentedView] contentView];
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView* tableView = (UITableView*)view;
        NSIndexPath* indexPath = [tableView indexPathForSelectedRow];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    CGRect rect = self.view.bounds;
    
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^ {
        
        //set point of rotation
        _dynamicDetachImage.center = CGPointMake(75.0f + kLeftPadding + kImageWidth/2, 130.0f + rect.size.height/2);
        
        // The transform matrix
        CGAffineTransform transform = 
        CGAffineTransformMakeRotation(1.4f);
        //    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
        _dynamicDetachImage.transform = transform;
    }
                     completion:^(BOOL finish) {
                         _dynamicDetachImage.hidden = YES;
                         _staticDetachImage.hidden = YES;
                         _dynamicDetachImage.alpha = 1.0;
                         CGAffineTransform transform = 
                         CGAffineTransformMakeRotation(0.0);
                         _dynamicDetachImage.transform = transform;
                         _dynamicDetachImage.center = CGPointMake(10.0f + kLeftPadding + kImageWidth/2.0f, 10.0f + rect.size.height/2);
                     }];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didAddPage:(UIView*)page animated:(BOOL)animated {
    _dynamicDetachImage.hidden = ([self.childViewControllers count] < 2) ? YES : NO;    
    _staticDetachImage.hidden = ([self.childViewControllers count] < 2) ? YES : NO;    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index {
    _dynamicDetachImage.hidden = ([self.childViewControllers count] < 2) ? YES : NO;    
    _staticDetachImage.hidden = ([self.childViewControllers count] < 2) ? YES : NO;    
}

@end
