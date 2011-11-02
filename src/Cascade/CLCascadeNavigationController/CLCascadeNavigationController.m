//
//  CLCascadeNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationController.h"

#import "CLSegmentedView.h"
#import "CLBorderShadowView.h"

#import <objc/runtime.h>
#import "CLContainerView.h"

@interface CLCascadeNavigationController (Private)
- (void) addPagesRoundedCorners;
- (void) addRoundedCorner:(UIRectCorner)rectCorner toPageAtIndex:(NSInteger)index;
- (void) popPagesFromLastIndexTo:(NSInteger)index;
- (void) removeAllPageViewControllers;
@end

@implementation CLCascadeNavigationController

@synthesize viewControllers = _viewControllers;
@synthesize leftInset, widerLeftInset;

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
    _cascadeView = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // unload all invisible pages in cascadeView
    [_cascadeView unloadInvisiblePages];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set background color
    [self.view setBackgroundColor: [UIColor clearColor]];

    _viewControllers = [[NSMutableArray alloc] init];

    _cascadeView = [[CLCascadeView alloc] initWithFrame:self.view.bounds];
    _cascadeView.delegate = self;
    _cascadeView.dataSource = self;
    [self.view addSubview:_cascadeView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_cascadeView removeFromSuperview];
    _cascadeView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [_cascadeView updateContentLayoutToInterfaceOrientation:interfaceOrientation duration:duration];
}


#pragma mark -
#pragma mark Setters & getters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) widerLeftInset {
    return _cascadeView.widerLeftInset;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setWiderLeftInset:(CGFloat)inset {
    [_cascadeView setWiderLeftInset: inset];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) leftInset {
    return _cascadeView.leftInset;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setLeftInset:(CGFloat)inset {
    [_cascadeView setLeftInset: inset];
}


#pragma mark -
#pragma marl test

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*) rootViewController {
    if ([_viewControllers count] > 0) {
        return [_viewControllers objectAtIndex: 0];
    }
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*) lastCascadeViewController {
    if ([_viewControllers count] > 0) {
        NSUInteger index = [_viewControllers count] - 1;
        return [_viewControllers objectAtIndex: index];
    }
    
    return nil;
}


#pragma mark -
#pragma marl CLCascadeViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*) cascadeView:(CLCascadeView *)cascadeView pageAtIndex:(NSInteger)index {
    return [_viewControllers objectAtIndex:index];    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) numberOfPagesInCascadeView:(CLCascadeView*)cascadeView {
    return [_viewControllers count];
}


#pragma mark -
#pragma marl CLCascadeViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didLoadPage:(UIViewController*)page {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didUnloadPage:(UIViewController*)page {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didAddPage:(UIViewController*)page animated:(BOOL)animated {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index {
    if (index > [_viewControllers count] - 1) return;

    UIViewController<CLViewControllerDelegate>* controller = [_viewControllers objectAtIndex: index];
    if ([controller respondsToSelector:@selector(pageDidAppear)]) {
        [controller pageDidAppear];
    }
    
    [self addPagesRoundedCorners];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index {
    if (index > [_viewControllers count] - 1) return;
    
    UIViewController<CLViewControllerDelegate>* controller = [_viewControllers objectAtIndex: index];
    if ([controller respondsToSelector:@selector(pageDidAppear)]) {
        [controller pageDidDisappear];
    }

    [self addPagesRoundedCorners];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewDidStartPullingToDetachPages:(CLCascadeView*)cascadeView {
    /*
     Override this methods to implement own actions, animations
     */
    
    NSLog(@"cascadeViewDidStartPullingToDetachPages");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewDidPullToDetachPages:(CLCascadeView*)cascadeView {
    /*
     Override this methods to implement own actions, animations
     */
    NSLog(@"cascadeViewDidPullToDetachPages");

    // pop page from back
    [self popPagesFromLastIndexTo:0];
    //load first page
    [cascadeView loadPageAtIndex:0];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeViewDidCancelPullToDetachPages:(CLCascadeView*)cascadeView {
    /*
     Override this methods to implement own actions, animations
     */
    NSLog(@"cascadeViewDidCancelPullToDetachPages");
}

#pragma mark -
#pragma mark Calss methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(UIViewController*)viewController animated:(BOOL)animated {
    // pop all pages
    [_cascadeView popAllPagesAnimated: animated];
    // remove all controllers
    [self removeAllPageViewControllers];
    // add root view controller
    [self addViewController:viewController sender:nil animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addViewController:(UIViewController*)viewController sender:(UIViewController*)sender animated:(BOOL)animated {
    
    // if in not sent from categoirs view
    if (sender) {

        // get index of sender
        NSInteger indexOfSender = [_viewControllers indexOfObject:sender];
        
        // if sender is not last view controller
        if (indexOfSender != [_viewControllers count] - 1) {
            
            // pop views and remove from _viewControllers
            [self popPagesFromLastIndexTo:indexOfSender];
        }
    } 
    
    // set cascade navigator to view controller
    [viewController setCascadeNavigationController: self];
    // add controller to array
    [self.viewControllers addObject: viewController];

    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
    [self addChildViewController:viewController];
    #endif
    
    // push view
    [_cascadeView pushPage:viewController 
                  fromPage:sender 
                  animated:animated];

    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
    [viewController didMoveToParentViewController:self];
    #endif
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*) firstVisibleViewController {
    NSInteger index = [_cascadeView indexOfFirstVisibleView: YES];

    if (index != NSNotFound) {
        return [_viewControllers objectAtIndex: index];
    }
    
    return nil;
}


#pragma mark -
#pragma mark Private

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addRoundedCorner:(UIRectCorner)rectCorner toPageAtIndex:(NSInteger)index {
    
    if (index != NSNotFound) {
        UIViewController* viewController = [_viewControllers objectAtIndex: index];
        if ([viewController showRoundedCorners]) {
            CLSegmentedView* view = (CLSegmentedView*)viewController.view;
            [view setShowRoundedCorners: YES];
            [view setRectCorner: rectCorner];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addPagesRoundedCorners {
    
    // unload all rounded corners
    for (id item in [_cascadeView visiblePages]) {
        if (item != [NSNull null]) {
            if ([item isKindOfClass:[CLSegmentedView class]]) {
                CLSegmentedView* view = (CLSegmentedView*)item;
                
                if ([view showRoundedCorners]) {
                    [view setShowRoundedCorners: NO];
                }
            }
        }
    }

    // get index of first visible page
    NSInteger indexOfFirstVisiblePage = [_cascadeView indexOfFirstVisibleView: NO];
    
    // get index of last visible page
    NSInteger indexOfLastVisiblePage = [_cascadeView indexOfLastVisibleView: NO];

    if (indexOfLastVisiblePage == indexOfFirstVisiblePage) {
        [self addRoundedCorner:UIRectCornerAllCorners toPageAtIndex: indexOfFirstVisiblePage];
        
    } else {

        [self addRoundedCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft toPageAtIndex:indexOfFirstVisiblePage];
        
        if (indexOfLastVisiblePage == [_viewControllers count] -1) {
            [self addRoundedCorner:UIRectCornerTopRight | UIRectCornerBottomRight toPageAtIndex:indexOfLastVisiblePage];
        }    
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popPagesFromLastIndexTo:(NSInteger)toIndex {
    if (toIndex < 0) toIndex = 0;
    
    // index of last page
    NSUInteger index = [_viewControllers count] - 1;
    // pop page from back
    NSEnumerator* enumerator = [_viewControllers reverseObjectEnumerator];
    // enumarate pages
    while ([enumerator nextObject] && _viewControllers.count > toIndex+1) {

        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        UIViewController* viewController = [_viewControllers objectAtIndex:index];
        [viewController willMoveToParentViewController:nil];
        #endif

        // pop page at index
        [_cascadeView popPageAtIndex:index animated:NO];
        [_viewControllers removeLastObject];

        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        [viewController removeFromParentViewController];
        #endif
        
        index--;
    }
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeAllPageViewControllers {

    // pop page from back
    NSEnumerator* enumerator = [_viewControllers reverseObjectEnumerator];
    // enumarate pages
    while ([enumerator nextObject]) {
        
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        UIViewController* viewController = [_viewControllers lastObject];
        [viewController willMoveToParentViewController:nil];
        #endif
        
        [_viewControllers removeLastObject];
        
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        [viewController removeFromParentViewController];
        #endif
    }
}

@end

@implementation UIViewController (CLCascade)
static char cascadeNavigationControllerKey;
static char viewSizeKey;
static char showRoundedCornersKey;
static char containerViewKey;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setCascadeNavigationController:(CLCascadeNavigationController *)cascadeNavigationController {
    objc_setAssociatedObject( self, &cascadeNavigationControllerKey, cascadeNavigationController, OBJC_ASSOCIATION_RETAIN );
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLCascadeNavigationController*) cascadeNavigationController {
    return objc_getAssociatedObject( self, &cascadeNavigationControllerKey );
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setContainerView:(CLContainerView *)containerView {
    objc_setAssociatedObject( self, &containerViewKey, containerView, OBJC_ASSOCIATION_RETAIN );
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLContainerView*) containerView {
    return objc_getAssociatedObject( self, &containerViewKey );
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setViewSize:(CLViewSize)viewSize {
    objc_setAssociatedObject( self, &viewSizeKey, [NSNumber numberWithInt:viewSize], OBJC_ASSOCIATION_RETAIN );
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLViewSize) viewSize {
    NSNumber *numberViewSize = objc_getAssociatedObject( self, &viewSizeKey );
    return [numberViewSize intValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setShowRoundedCorners:(BOOL)showRoundedCorners {
    objc_setAssociatedObject( self, &showRoundedCornersKey, [NSNumber numberWithBool:showRoundedCorners], OBJC_ASSOCIATION_RETAIN );
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) showRoundedCorners {
    NSNumber *numberShowCorners = objc_getAssociatedObject( self, &showRoundedCornersKey );
    return [numberShowCorners intValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithSize:(CLViewSize)size {
    self = [self init];
    if (self) {
        NSLog(@"%d", size);
        self.viewSize = size;
        NSLog(@"after %d", self.viewSize);
        self.showRoundedCorners = NO;
    }
    return self;   
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil size:(CLViewSize)size {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewSize = size;
        self.showRoundedCorners = NO;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushDetailViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSAssert(self.viewSize != CLViewSizeWider, @"Assert: You can't push a new view from a view which size is CLViewSizeWider.");
    [self.cascadeNavigationController addViewController:viewController sender:self animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *) leftBorderShadowView {
    return [[CLBorderShadowView alloc] init];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addLeftBorderShadowWithWidth:(CGFloat)width andOffset:(CGFloat)offset {
    UIView* shadowView = [self leftBorderShadowView];
    
    if (!self.containerView) {
        // create a container view (for shadow stuff)
        CLContainerView *contV = [[CLContainerView alloc] initWithFrame:self.view.frame];
        contV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        // set the container
        self.containerView = contV;
    }
    
    [self.containerView addLeftBorderShadowView:shadowView 
                                               withWidth:width];    
    
    [self.containerView setShadowOffset:offset];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeLeftBorderShadow {
    [self.containerView removeLeftBorderShadowView];    
}

#pragma mark CLViewControllerDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidAppear {
    /*
     * Called when page (view of this controller) will be unveiled by 
     * another page or will slide in CascadeView bounds
     */
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidDisappear {
    /*
     * Called when page (view of this controller) will be shadowed by 
     * another page or will slide out CascadeView bounds
     */
    
}

@end

