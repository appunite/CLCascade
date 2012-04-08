//
//  CLCascadeNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationController.h"

#import "CLViewController.h"
#import "CLSegmentedView.h"

//#define NSDebugLog( ... ) NSLog( __VA_ARGS__ )
#define NSDebugLog( ... )

@interface CLCascadeNavigationController (Private)
- (void) addPagesRoundedCorners;
- (void) addRoundedCorner:(UIRectCorner)rectCorner toPageAtIndex:(NSInteger)index;
- (void) popPagesFromLastIndexTo:(NSInteger)index;
- (void) removeAllPageViewControllers;
@end

@implementation CLCascadeNavigationController

@synthesize viewControllers = _viewControllers;
@synthesize leftInset, widerLeftInset;


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

- (CLCascadeView*)cascadeView
{
   return _cascadeView;
}

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

-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )toInterfaceOrientation_
                               duration:( NSTimeInterval )duration_
{
   //dodikk - blocks are available since iOS4
   [ self.viewControllers enumerateObjectsUsingBlock: ^void(id obj_, NSUInteger idx_, BOOL *stop_)
   {
      UIViewController* controller_ = (UIViewController*)obj_;
      [ controller_ willRotateToInterfaceOrientation: toInterfaceOrientation_
                                            duration: duration_ ];

      *stop_ = NO;
   } ];
}

-(void)didRotateFromInterfaceOrientation:( UIInterfaceOrientation )fromInterfaceOrientation_
{
   //dodikk - blocks are available since iOS4
   [ self.viewControllers enumerateObjectsUsingBlock: ^void(id obj_, NSUInteger idx_, BOOL *stop_)
    {
       UIViewController* controller_ = (UIViewController*)obj_;
       [ controller_ didRotateFromInterfaceOrientation: fromInterfaceOrientation_ ];

       *stop_ = NO;
    } ];
}

- (void)willAnimateRotationToInterfaceOrientation:( UIInterfaceOrientation )interfaceOrientation_
                                         duration:( NSTimeInterval )duration_ 
{
   //dodikk - blocks are available since iOS4
   [ self.viewControllers enumerateObjectsUsingBlock: ^void(id obj_, NSUInteger idx_, BOOL *stop_)
    {
       UIViewController* controller_ = (UIViewController*)obj_;
       [ controller_ willAnimateRotationToInterfaceOrientation: interfaceOrientation_
                                                      duration: duration_ ];
       
       *stop_ = NO;
    } ];
   
   
    [_cascadeView updateContentLayoutToInterfaceOrientation: interfaceOrientation_
                                                   duration: duration_ ];
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
- (UIView*) cascadeView:(CLCascadeView *)cascadeView pageAtIndex:(NSInteger)index {
    return [[_viewControllers objectAtIndex:index] view];    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) numberOfPagesInCascadeView:(CLCascadeView*)cascadeView {
    return [_viewControllers count];
}


#pragma mark -
#pragma marl CLCascadeViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didLoadPage:(UIView*)page {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didUnloadPage:(UIView*)page {

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didAddPage:(UIView*)page animated:(BOOL)animated {

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
    if ([controller respondsToSelector:@selector(pageDidDisappear)]) {
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
- (void) setRootViewController:(CLViewController*)viewController animated:(BOOL)animated {
    // pop all pages
    [_cascadeView popAllPagesAnimated: NO];
    // remove all controllers
    [self removeAllPageViewControllers];
    // add root view controller
    [self addViewController:viewController sender:nil animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)addViewController:(CLViewController*)viewController 
                  sender:(CLViewController*)sender
                animated:(BOOL)animated 
{    
   // if in not sent from categoirs view
   if (sender) 
   {
      // get index of sender
      NSInteger indexOfSender = [_viewControllers indexOfObject:sender];
      
      // if sender is not last view controller
      if (indexOfSender != [_viewControllers count] - 1) 
      {
         // pop views and remove from _viewControllers
         [self popPagesFromLastIndexTo:indexOfSender];
      }
   } 
   
   UIView* sender_view_ = [ sender view ];
   UIView* view_to_push_ = [ viewController view ];
   
   NSDebugLog
   ( 
    @"CLCascadeNavigationController->addViewController: %@"
    @"\n \t\t\t " @"sender: %@"
    @"\n \t\t\t " @"animated: %d"
    @"\n"
    @"\n \t\t\t " @"self->_cascadeView: %@"
    @"\n \t\t\t " @"sender->view: %@"
    @"\n \t\t\t " @"viewController->view: %@"    
    , viewController         
    , sender
    , animated
    , _cascadeView 
    , sender_view_
    , view_to_push_
   );
   
   // set cascade navigator to view controller
   [viewController setCascadeNavigationController: self];
   // add controller to array
   [self.viewControllers addObject: viewController];
   
   {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
   [self addChildViewController:viewController];
#endif
   
   // push view
   [ _cascadeView pushPage: view_to_push_ 
                  fromPage: sender_view_ 
                  animated: animated ];
   
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
   [viewController didMoveToParentViewController:self];
#endif
   }
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
        
        if ([viewController isKindOfClass: [CLViewController class]]) {
            CLViewController* firstVisibleController = (CLViewController*)viewController;
            
            if ([firstVisibleController showRoundedCorners]) {
                CLSegmentedView* view = (CLSegmentedView*)firstVisibleController.view;
                [view setShowRoundedCorners: YES];
                [view setRectCorner: rectCorner];
            }
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
-(void)popPagesFromLastIndexTo:(NSInteger)toIndex 
{
   NSUInteger view_controllers_count_ = [_viewControllers count];
   if ( 0 == view_controllers_count_ )
   {
      return;
   }
   
    if (toIndex < 0) 
    {
       toIndex = 0;
    }
    
    // index of last page
    NSUInteger index = view_controllers_count_ - 1;
    // pop page from back
    NSEnumerator* enumerator = [_viewControllers reverseObjectEnumerator];
    // enumarate pages
    while ([enumerator nextObject] && _viewControllers.count > toIndex+1) 
    {
       if ( ![ _cascadeView canPopPageAtIndex: index ] )
       {
          //dodikk - maybe break fits better
          continue;
       }
       
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

