//
//  CLCascadeViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-24.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLCascadeViewController.h"
#import "CLScrollView.h"

@implementation CLCascadeViewController

@synthesize detailPositionViewController = _detailPositionViewController;
@synthesize masterPositionViewController = _masterPositionViewController;
@synthesize scrollPosition = _scrollPosition;
@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithMasterPositionViewController:(CLViewController*)masterPositionViewController;
{

    self = [super init];
    if (self) {
        _masterPositionViewController = [masterPositionViewController retain];
        [_masterPositionViewController setParentCascadeViewController: self];
    }
    return self;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _delegate = nil;
//    [_detailPositionViewController release], _detailPositionViewController = nil;
    [_masterPositionViewController release], _masterPositionViewController = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark Getters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setDetailPositionViewController:(CLCascadeViewController*)viewController {
    if (_detailPositionViewController != viewController) {
        [_detailPositionViewController release];
        _detailPositionViewController = [viewController retain];
    }        
}

#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadView {
    
    CGRect rect = CGRectZero;
    
    CLCascadeNavigationController* navigator = self.cascadeNavigationController;
    
    if (navigator == nil) {
        rect = [UIScreen mainScreen].bounds;
        
    } else {
        rect = [navigator cascadeScrollableViewFrame];        
    }
    
    //    CLScrollView* scrollView = [[CLScrollView alloc] initWithFrame: viewFrame];
    CLScrollView* scrollView = [[CLScrollView alloc] initWithFrame: rect];
    [scrollView setBackgroundColor: [UIColor clearColor]];
    [scrollView setContentSize: [navigator singleCascadeContentSize]];
    [scrollView setDelegate: self];
    self.view = scrollView;
    [scrollView release];
    
    if (_masterPositionViewController != nil) {
        
        UIView* view = [_masterPositionViewController view];
        [view setFrame: [navigator masterCascadeFrame]];
        
        [_masterPositionViewController viewWillAppear: YES];
        [self.view addSubview: view];
        [_masterPositionViewController viewDidAppear: YES];
    }    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_masterPositionViewController viewWillAppear: animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [_masterPositionViewController viewDidAppear: animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) adjustFrameAndContentToInterfaceOrientation:(UIInterfaceOrientation)newOrientation {

    CLCascadeNavigationController* navigator = self.cascadeNavigationController;
    
    if ([self isRootCascadeViewController]) {
        // get rootViewController view 
        UIView* rootView = self.view;
        
        // add proper content inset if interface is in landscape orientation
        if (UIInterfaceOrientationIsLandscape(newOrientation)) {
            [(UIScrollView*)rootView setContentInset:UIEdgeInsetsMake(0.0, -([navigator singleCascadeContentSize].width/2) - 16, 0.0, 0.0)];
        } else {
            [(UIScrollView*)rootView setContentInset:UIEdgeInsetsZero];
        }
        
        // set frame of rootView (is different in different orientations)
        [rootView setFrame: [navigator frameRootViewController]];
        
        // set contentSize of root cascade view
        [(UIScrollView*)rootView setContentSize: [navigator contentSizeRootViewController]];
        
        // set up master position view frame
        UIView* rootMasterView = _masterPositionViewController.view;
        [rootMasterView setFrame: [navigator masterCascadeFrame]];
                
    } else {
        UIView* view = [_masterPositionViewController view];
        [view setFrame: [navigator masterCascadeFrame]];

    }
    
    if (_detailPositionViewController != nil) {

        // set new detail frame
        CGRect detailRect = [navigator detailCascadeFrame];
        [_detailPositionViewController.view setFrame: detailRect];
        
        if ([self isRootCascadeViewController] && (UIInterfaceOrientationIsPortrait([self interfaceOrientation]))) {
            // update scrollview content size
            [(CLScrollView*)self.view setContentSize: [navigator contentSizeRootViewController]];
            // update scrollview content offset leading to detailview
            [(CLScrollView*)self.view setContentOffset: CGPointMake(223.0, 0.0) animated:YES];
        } else {
            // update scrollview content size
            [(CLScrollView*)self.view setContentSize: [navigator doubleCascadeContentSize]];
            // update scrollview content offset leading to detailview
            [(CLScrollView*)self.view setContentOffset: [navigator masterContentOffsetLeadToDetailView] animated:YES];
        }
        
        // update scrollview content offset leading to detailview
        [(CLScrollView*)_detailPositionViewController.view setContentOffset: [navigator detailContentOffsetAtShow] animated:YES];
        
        [_detailPositionViewController adjustFrameAndContentToInterfaceOrientation: newOrientation];
        
    } else {
        // update scrollview content size
        [(CLScrollView*)self.view setContentSize: [navigator singleCascadeContentSize]];
        // update scrollview content offset leading to detailview
//        [(CLScrollView*)self.view setContentOffset: CGPointMake(0.0, 0.0) animated:YES];
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isRootCascadeViewController {
    return (self == [self.cascadeNavigationController rootViewController]) ? YES : NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isLastCascadeViewController {
    return (self == [self.cascadeNavigationController lastCascadeViewController]) ? YES : NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) scrollPositionDidChange:(CLCascadeViewScrollPositions)newPosition {
    _scrollPosition = newPosition;
}   


/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popMasterAndDetailPositionViewController {
//    
//    if (_detailPositionViewController != nil) {
//        [_detailPositionViewController.view removeFromSuperview];
//        [_contentNavigator removeViewController: _detailPositionViewController.masterPositionViewController];
//        [_detailPositionViewController popMasterAndDetailPositionViewController];
//        [_detailPositionViewController release], _detailPositionViewController = nil;
//        
//        [(CLScrollView*)self.view setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
//        CGRect masterRect = self.view.bounds;        
//        [(CLScrollView*)self.view setContentSize: masterRect.size];
//        
//    }
//    
//    if (_masterPositionViewController != nil) {
//        [_masterPositionViewController.view removeFromSuperview];
//        [self.contentNavigator removeViewController: _masterPositionViewController];
//        [_masterPositionViewController retain], _masterPositionViewController = nil;
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popDetailPositionViewController {

//    if (_detailPositionViewController == nil) {
//        
//    }
    
//    [_detailPositionViewController popDetailPositionViewController];
//    NSLog(@"detail %i", [_detailPositionViewController retainCount]);
//    [_detailPositionViewController setParentCascadeViewController: nil];
//    
//    NSLog(@"master %i", [_detailPositionViewController retainCount]);
//    [_detailPositionViewController release];

//    if (_detailPositionViewController != nil) {
//        [_detailPositionViewController release];
//        NSLog(@"%i", [_detailPositionViewController retainCount]);
//        [_masterPositionViewController release];
//        
//    } else {
//
//        [_detailPositionViewController setParentCascadeViewController: nil];
//        [_detailPositionViewController release];
//        [_masterPositionViewController release];
//    }
    
    
    
//    if (_detailPositionViewController != nil) {
//        [_detailPositionViewController popDetailPositionViewController];
//
//        [_detailPositionViewController.view removeFromSuperview];
//        [_cascadeNavigationController removeViewControllersStartingFrom: _detailPositionViewController.masterPositionViewController];
//
//        [_detailPositionViewController release];//, _detailPositionViewController = nil;
//
//        
////        [(CLScrollView*)self.view setContentOffset: CGPointMake(0.0, 0.0) animated:YES];
//        [(CLScrollView*)self.view setContentSize: [_cascadeNavigationController singleCascadeContentSize]];
//    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushCascadeViewController:(CLCascadeViewController *)viewController {
    
    [self popDetailPositionViewController];
    
    CLCascadeNavigationController* navigator = self.cascadeNavigationController;
    
    // set content nvigator
    [viewController setCascadeNavigationController: navigator];
    // set delegate to navigator
    [viewController setDelegate: navigator];
    // set parent
    [viewController setParentCascadeViewController: self];
    // set detail position view
    [self setDetailPositionViewController: viewController];
    // udate last cascade view controller
    [navigator setLastCascadeViewController: viewController];
    
    // set new detail frame
    CGRect animationFinishRect = [navigator detailCascadeFrame];
    CGRect animationStartRect = animationFinishRect;
    animationStartRect.origin.x += 20;

    [_detailPositionViewController.view setFrame: animationStartRect];
    
    
    [UIView animateWithDuration:0.2 animations:^ {
        [_detailPositionViewController.view setFrame: animationFinishRect];
    }];
    
    // add view to controller stock
    [navigator addViewController: viewController.masterPositionViewController];

    if ([self isRootCascadeViewController] && (UIInterfaceOrientationIsPortrait([self interfaceOrientation]))) {
        // update scrollview content size
        [(CLScrollView*)self.view setContentSize: [navigator contentSizeRootViewController]];
        // update scrollview content offset leading to detailview
        [(CLScrollView*)self.view setContentOffset: CGPointMake(223.0, 0.0) animated:YES];
    } else {
        // update scrollview content size
        [(CLScrollView*)self.view setContentSize: [navigator doubleCascadeContentSize]];
        // update scrollview content offset leading to detailview
        [(CLScrollView*)self.view setContentOffset: [navigator masterContentOffsetLeadToDetailView] animated:YES];
    }
    

    // add view to super view
    [_detailPositionViewController viewWillAppear:YES];
    [self.view addSubview: _detailPositionViewController.view];
    [_detailPositionViewController viewDidAppear:YES];

    // update scrollview content offset leading to detailview
    [(CLScrollView*)_detailPositionViewController.view setContentOffset: [navigator detailContentOffsetAtShow] animated:YES];
        
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLCascadeViewScrollPositions) currentScrollPosition {

    CLCascadeViewScrollPositions position = CLCascadeViewScrollUnknowPosition;
    CLScrollView* scrollView = (CLScrollView*)self.view;

//    CGFloat pageWidth = scrollView.contentSize.width;
//    CGFloat contentOffset = scrollView.contentOffset.x + scrollView.contentInset.left;
//	NSUInteger pageIndex = floor((contentOffset - contetWidth / 2) / contetWidth);
//    NSLog(@"%f %f %i", contetWidth, contentOffset, pageIndex);
    
//    if (pageIndex == -1) {
//        if ([self isRootCascadeViewController]) {
//            [self popDetailPositionViewController];
//        }
//    }

//    if (pageIndex == 0) {
//        position = CLCascadeViewScrollMasterPosition;
//        NSLog(@"master %@", self.view);
//    }
//
//    if (pageIndex == 1) {
//        position = CLCascadeViewScrollDetailPosition;
//        NSLog(@"detail %@", self.view);
//    }

    CGFloat contentOffset = scrollView.contentOffset.x + scrollView.contentInset.left;

    if (contentOffset < 80.0) {
        position = CLCascadeViewScrollMasterPosition;
    } else if (contentOffset >= 80.0) {
        position = CLCascadeViewScrollDetailPosition;
    }
    
    return position;
}

#pragma mark -
#pragma mark UIScrollViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CLCascadeViewScrollPositions scrollPosition = [self currentScrollPosition];
    
    if (_scrollPosition != scrollPosition) {
        [self setScrollPosition: scrollPosition];
        if ([_delegate respondsToSelector:@selector(cascadeViewController:didChangeScrollPosition:)]) {
            [_delegate cascadeViewController:self didChangeScrollPosition: scrollPosition];
        }
    }
}     

#pragma mark -
#pragma mark Setters & getters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLCascadeViewScrollPositions) scrollPosition {
    return _scrollPosition;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setScrollPosition:(CLCascadeViewScrollPositions)newScrollPosition {
    [self scrollPositionDidChange: newScrollPosition];
}

@end
