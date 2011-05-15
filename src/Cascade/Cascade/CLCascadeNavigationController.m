//
//  CLCascadeNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationController.h"

@implementation CLCascadeNavigationController

#define kCascadeViewWidth 479.0f

@synthesize rootViewController = _rootViewController;
@synthesize lastCascadeViewController = _lastCascadeViewController;
@synthesize viewControllers = _viewControllers;
@synthesize delegate = _delegate;
@synthesize backgroundView = _backgroundView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    [_backgroundView release], _backgroundView = nil;
    [_rootViewController release], _rootViewController = nil;
    [_lastCascadeViewController release], _lastCascadeViewController = nil;
    [_viewControllers release], _viewControllers = nil;

    [super dealloc];
}

- (void) loadView {
    NSString *nib = self.nibName;
    NSBundle *bundle = self.nibBundle;
 
    if(!nib) nib = NSStringFromClass([self class]);
    if(!bundle) bundle = [NSBundle mainBundle];
    
    NSString *path = [bundle pathForResource:nib ofType:@"nib"];
    
    if(path) {
        self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
        return;
    }
    
    CLCascadeNavigationView* view_ = [[CLCascadeNavigationView alloc] init]; 
    self.view = view_;
    [view_ release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}




#pragma mark -
#pragma mark Calss methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addViewController:(CLViewController*)viewController {
    [self.viewControllers addObject: viewController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeViewController:(CLViewController*)viewController {
    [self.viewControllers removeObject: viewController];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeViewControllersStartingFrom:(CLViewController*)viewController {
    
//    NSUInteger index = [_viewControllers indexOfObject: viewController];
//    NSUInteger lenght = [_viewControllers count] - index;
//    [_viewControllers removeObjectsInRange:NSMakeRange(index, lenght)];
    
}

- (CGRect) cascadeContentNavigatorBounds {
    CGRect bounds = self.view.bounds;
    return bounds;
}

- (CGSize) singleCascadeContentSize {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];

    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return  CGSizeMake(kCascadeViewWidth, contentNavigatorFrame.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return  CGSizeMake(detailViewWidth + offset, contentNavigatorFrame.size.height);
    }
    
    return CGSizeZero;
}

- (CGSize) doubleCascadeContentSize {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGSizeMake(kCascadeViewWidth*2, contentNavigatorFrame.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return  CGSizeMake(detailViewWidth + rootScrollViewOriginX + offset, contentNavigatorFrame.size.height);
    }
    
    return CGSizeZero;
}

- (CGRect) masterCascadeFrame {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGRectMake(0.0, 0.0, kCascadeViewWidth, contentNavigatorFrame.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        //        CGFloat detailViewWidth = kCascadeViewWidth;
        //        CGFloat navigatorContainerWidth = 702.0;
        //        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        //        CGFloat rootScrollViewWidth = 290;
        //        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return CGRectMake(0.0, 0.0, kCascadeViewWidth, contentNavigatorFrame.size.height);
    }
    
    return CGRectZero;
}

- (CGRect) detailCascadeFrame {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect contentNavigatorFrame = [self cascadeContentNavigatorBounds];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGRectMake(kCascadeViewWidth, 0.0, kCascadeViewWidth, contentNavigatorFrame.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return CGRectMake(detailViewWidth, 0.0, rootScrollViewOriginX + offset, contentNavigatorFrame.size.height);
    }
    
    
    return CGRectZero;
}

- (CGPoint) masterContentOffsetLeadToDetailView {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGPointMake(kCascadeViewWidth, 0.0);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return CGPointMake(rootScrollViewOriginX*2 + offset, 0.0);
    }
    
    return CGPointZero;
}

- (CGPoint) detailContentOffsetAtShow {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return CGPointMake(0.0, 0.0);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return CGPointMake(rootScrollViewOriginX + offset, 0.0);
    }
    
    return CGPointZero;
}

#pragma mark -
#pragma mark Private

- (CGSize) contentSizeRootViewController {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return  CGSizeMake(kCascadeViewWidth, self.view.bounds.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        if ([_viewControllers count] > 1) {
            return  CGSizeMake(detailViewWidth + offset, self.view.bounds.size.height);
        } else {
            return  CGSizeMake(rootScrollViewWidth + 1, self.view.bounds.size.height);
        }
    }
    
    return CGSizeZero;
}

- (CGRect) frameRootViewController {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return  CGRectMake(kCascadeViewWidth, 0.0, kCascadeViewWidth, self.view.bounds.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        
        //        NSLog(@"%f %f %f %f", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        return  CGRectMake(rootScrollViewOriginX, 0.0, rootScrollViewWidth, self.view.bounds.size.height);
    }
    
    return CGRectZero;
}

- (CGRect) cascadeScrollableViewFrame {
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return  CGRectMake(0.0, 0.0, kCascadeViewWidth, self.view.bounds.size.height);
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        
        CGFloat detailViewWidth = kCascadeViewWidth;
        CGFloat navigatorContainerWidth = 702.0;
        CGFloat rootScrollViewOriginX = navigatorContainerWidth - detailViewWidth;
        CGFloat rootScrollViewWidth = 290;
        CGFloat offset = rootScrollViewOriginX + rootScrollViewWidth - detailViewWidth;
        
        return  CGRectMake(detailViewWidth, 0.0, rootScrollViewOriginX + offset, self.view.bounds.size.height);
    }
    
    return CGRectZero;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) adjustFrameAndContentAfterRotation:(UIInterfaceOrientation)newOrientation {
    // we need to set current interface orientation
    [_rootViewController adjustFrameAndContentToInterfaceOrientation: newOrientation];
}

#pragma mark -
#pragma mark Getters & setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLCascadeViewController*) rootViewController {
    return _rootViewController;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLCascadeViewController*)viewController {
    if (viewController != _rootViewController) {

        self.lastCascadeViewController = nil;
        
        [_rootViewController setCascadeNavigationController: nil];
        // set delegate
        [_rootViewController setDelegate: nil];
        // root view hasn't parentCascadeViewController
        [_rootViewController setParentCascadeViewController: nil];
        
        
        for (CLViewController* viewController in _viewControllers) {
            CLCascadeViewController* cc = [viewController parentCascadeViewController];

            [cc.masterPositionViewController setParentCascadeViewController: nil];

//            [cc release];
//            [[viewController parentCascadeViewController] setDetailPositionViewController: nil];
//            [[viewController ] release];
//            [[viewController cascadeNavigationController] setParentViewController: nil];
        }
        
//        [_viewControllers removeAllObjects];
        
//        // remove all details view controllers
//        if (_rootViewController != nil) {
//            [_rootViewController popDetailPositionViewController];
//        }
//
//        [_viewControllers removeAllObjects];

        // remove rootViewController view from navigator
        [_rootViewController.view removeFromSuperview];
//        [_rootViewController release];
        // set up new rootViewController
        _rootViewController = [viewController retain];
        NSLog(@"_rootViewController: %i",  [_rootViewController retainCount]);
        
        // set up content navigator
        [_rootViewController setCascadeNavigationController: self];
        // set delegate
        [_rootViewController setDelegate: self];
        // root view hasn't parentCascadeViewController
        [_rootViewController setParentCascadeViewController: nil];
        
        
        // set last CascadeViewController
        self.lastCascadeViewController = viewController;
        
        // add View controllers to stock array
        [self addViewController: viewController.masterPositionViewController];
        
        // set background color
        [self.view setBackgroundColor: [UIColor clearColor]];
        
        // update contentSize
        [(UIScrollView*)_rootViewController.view setContentSize: [self contentSizeRootViewController]];
        
        // prepare for animation
        UIView* rootView = _rootViewController.view;
        CGRect stopAnimationViewFrame = [self frameRootViewController];
        CGRect startAnimationRootViewFrame = [self frameRootViewController];
        startAnimationRootViewFrame.origin.x = startAnimationRootViewFrame.size.width + (startAnimationRootViewFrame.size.width / 2);
        [rootView setAlpha: 0.0];
        [rootView setFrame: startAnimationRootViewFrame];
        
        // rootViewController is at center when added
        UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;

        if ([rootView isKindOfClass: [UIScrollView class]] && (UIInterfaceOrientationIsLandscape(interfaceOrientation))) {
            [(UIScrollView*)rootView setContentInset:UIEdgeInsetsMake(0.0, -([self singleCascadeContentSize].width/2) - 16, 0.0, 0.0)];
        }
        
        // add view
        [self.view addSubview: rootView];
        
        // commit animation
        [UIView animateWithDuration:0.4 animations:^ {
            [rootView setAlpha: 1.0];
            [rootView setFrame: stopAnimationViewFrame];
        }];
        NSLog(@"_rootViewController: %i",  [_rootViewController retainCount]);

    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*) viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return _viewControllers;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setViewControllers:(NSMutableArray*)array {
    if (array != _viewControllers) {
        [_viewControllers release];
        _viewControllers = [array retain];
    }
}

#pragma mark -
#pragma mark CLCascadeViewControllerDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewController:(CLCascadeViewController*)cascadeViewController didChangeScrollPosition:(CLCascadeViewScrollPositions)scrollPosition {
    if (cascadeViewController == _rootViewController) {
        
        if (scrollPosition == CLCascadeViewScrollMasterPosition) {
            if ([_delegate respondsToSelector:@selector(rootViewControllerMoveToMasterPosition)]) {
                [_delegate rootViewControllerMoveToMasterPosition];
            }
        }
        if (scrollPosition == CLCascadeViewScrollDetailPosition) {
            if ([_delegate respondsToSelector:@selector(rootViewControllerMoveToDetailPosition)]) {
                [_delegate rootViewControllerMoveToDetailPosition];
            }
        }
    }
}



@end
