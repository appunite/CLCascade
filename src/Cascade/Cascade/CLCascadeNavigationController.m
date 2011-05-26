//
//  CLCascadeNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationController.h"

@interface CLCascadeNavigationController (Private)
@property (nonatomic, retain, readwrite) CLCascadeViewController* rootViewController;
@property (nonatomic, retain, readwrite) CLCascadeViewController* lastCascadeViewController;
@property (nonatomic, retain, readwrite) NSMutableArray* viewControllers;
@end

@implementation CLCascadeNavigationController

#define kCascadeViewWidth 479.0f

@synthesize rootViewController = _rootViewController;
@synthesize lastCascadeViewController = _lastCascadeViewController;
@synthesize viewControllers = _viewControllers;


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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // set background color
    [self.view setBackgroundColor: [UIColor clearColor]];
}

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
- (void) adjustFrameAndContentAfterRotation {
    // we need to set current interface orientation
    UIInterfaceOrientation newOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [_rootViewController adjustFrameAndContentToInterfaceOrientation: newOrientation];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLViewController*)viewControllerr animated:(BOOL)animated {
    
    // create and set root view controller
    CLCascadeViewController* cascadeViewController = [[CLCascadeViewController alloc] initWithMasterPositionViewController: viewControllerr];
    self.rootViewController = cascadeViewController;
    [cascadeViewController release];
    
    // update contentSize
    [(UIScrollView*)_rootViewController.view setContentSize: [self contentSizeRootViewController]];
    
    UIView* rootView = _rootViewController.view;

    // rootViewController is at center when added
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ([rootView isKindOfClass: [UIScrollView class]] && (UIInterfaceOrientationIsLandscape(interfaceOrientation))) {
        [(UIScrollView*)rootView setContentInset:UIEdgeInsetsMake(0.0, -([self singleCascadeContentSize].width/2) - 16, 0.0, 0.0)];
    }

    if (animated) {
        // prepare for animation
        CGRect stopAnimationViewFrame = [self frameRootViewController];
        CGRect startAnimationRootViewFrame = [self frameRootViewController];
        startAnimationRootViewFrame.origin.x = startAnimationRootViewFrame.size.width + (startAnimationRootViewFrame.size.width / 2);
        [rootView setAlpha: 0.0];
        [rootView setFrame: startAnimationRootViewFrame];
                
        // add view
        [self.view addSubview: rootView];
        
        // commit animation
        [UIView animateWithDuration:0.4 animations:^ {
            [rootView setAlpha: 1.0];
            [rootView setFrame: stopAnimationViewFrame];
        }];
        
    } else {
        // set frame
        [rootView setFrame: [self frameRootViewController]];
        [rootView setAlpha: 1.0];
        // add view
        [self.view addSubview: rootView];

    }

}

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

#pragma mark -
#pragma mark Getters & setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*) viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return _viewControllers;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLCascadeViewController*)viewController {
    if (_rootViewController != viewController) {
        [_rootViewController release];
        _rootViewController = [viewController retain];
        // set up content navigator
        [_rootViewController setCascadeNavigationController: self];
        // root view hasn't parentCascadeViewController
        [_rootViewController setParentCascadeViewController: nil];
        // set last CascadeViewController
        self.lastCascadeViewController = _rootViewController;
        
        //clean up
        self.lastCascadeViewController = nil;
        for (CLViewController* viewController in _viewControllers) {
            CLCascadeViewController* cc = [viewController parentCascadeViewController];
            
            [cc.masterPositionViewController setParentCascadeViewController: nil];
            
        }

        // add View controllers to stock array
        [self addViewController: self.rootViewController.masterPositionViewController];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setLastCascadeViewController:(CLCascadeViewController*)viewController {
    if (_lastCascadeViewController != viewController) {
        [_lastCascadeViewController release];
        _lastCascadeViewController = [viewController retain];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setViewControllers:(NSMutableArray*)array {
    if (_viewControllers != array) {
        [_viewControllers release];
        _viewControllers = [array retain];
    }
}

#pragma mark -
#pragma mark CLCascadeViewControllerDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewController:(CLCascadeViewController*)cascadeViewController didChangeScrollPosition:(CLCascadeViewScrollPositions)scrollPosition {
//    if (cascadeViewController == _rootViewController) {
//        
//        if (scrollPosition == CLCascadeViewScrollMasterPosition) {
//            if ([_delegate respondsToSelector:@selector(rootViewControllerMoveToMasterPosition)]) {
//                [_delegate rootViewControllerMoveToMasterPosition];
//            }
//        }
//        if (scrollPosition == CLCascadeViewScrollDetailPosition) {
//            if ([_delegate respondsToSelector:@selector(rootViewControllerMoveToDetailPosition)]) {
//                [_delegate rootViewControllerMoveToDetailPosition];
//            }
//        }
//    }
}



@end
