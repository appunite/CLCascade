//
//  CLCascadeNavigationView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationView.h"
#import "CLCascadeNavigationController.h"
#import "CLSplitCascadeViewController.h"

#import "CLCascadeViewController.h"

@implementation CLCascadeNavigationView

#define kCascadeViewWidth 479

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    
    static UIViewController* __viewController;
    
    if (__viewController == nil) {
        
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                __viewController = (UIViewController*)nextResponder;
                return __viewController;
            }
        }
    }
    
    return __viewController;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

//    NSLog(@"---");

    CLSplitCascadeViewController *viewController = (CLSplitCascadeViewController*)[self viewController];
    CLCascadeNavigationController* navigationController = viewController.cascadeNavigationController; 
    NSArray* viewControllers = navigationController.viewControllers;
    
    for (NSUInteger i = [viewControllers count]; i>0; i--) {

        CLCascadeViewController* cascadeViewController = [viewControllers objectAtIndex: i-1];
        
        UIView* view = [cascadeViewController view];
        CGRect covertRect = [self convertRect:view.frame fromView:view];

//        NSLog(@"%@", [view description]);
        
        if (CGRectContainsPoint(covertRect, point)) {

            CGRect covertRect2 = [view convertRect:view.frame fromView:navigationController.view];
            CGPoint covertPoint = [view convertPoint:CGPointMake(point.x+covertRect2.origin.x , point.y) toView: view];
            
            if ([cascadeViewController parentCascadeViewController].scrollPosition == CLCascadeViewScrollDetailPosition) {
                if (i != [viewControllers count]) {
                    UIView* vii = [[viewControllers objectAtIndex: i] view]; 
                    return [vii hitTest:covertPoint withEvent:event];
                }
            }

            return [view hitTest:covertPoint withEvent:event];
        }
        
    }
    
    if ([navigationController.viewControllers count] > 0) {
        UIView* firstView = [[navigationController.viewControllers objectAtIndex: 0] view];
        return [firstView hitTest:point withEvent:event];
    }
    
    return [super hitTest:point withEvent:event];
}    

- (void)dealloc
{
    [super dealloc];
}

@end
