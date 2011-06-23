//
//  CLCascadeNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationController.h"

@interface UIViewController (ReadWrite)
@property(nonatomic, assign, readwrite) UIViewController *parentViewController;
@end

@implementation CLCascadeNavigationController

@synthesize viewControllers = _viewControllers;
@synthesize offset;

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
    [_viewControllers release], _viewControllers = nil;
    [_cascadeView release], _cascadeView = nil;
    [super dealloc];
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
    [_cascadeView release], _cascadeView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*) viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return _viewControllers;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) pageWidth {
    return _cascadeView.pageWidth;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) offset {
    return _cascadeView.offset;
}

#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setOffset:(CGFloat)newOffset {
    [_cascadeView setOffset: newOffset];
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
//    NSLog(@"didAddPage: %@", page);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index {

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index {
    UIViewController<CLViewControllerDelegate>* controller = [_viewControllers objectAtIndex: index];
    if ([controller respondsToSelector:@selector(pageDidAppear)]) {
        [controller pageDidAppear];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index {
    if (index > [_viewControllers count] - 1) return;
    
    UIViewController<CLViewControllerDelegate>* controller = [_viewControllers objectAtIndex: index];
    if ([controller respondsToSelector:@selector(pageDidAppear)]) {
        [controller pageDidDisappear];
    }
}


#pragma mark -
#pragma mark Calss methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLViewController*)viewController animated:(BOOL)animated {
    // pop all pages
    [_cascadeView popAllPagesAnimated: animated];
    // remove all controllers
    [self.viewControllers removeAllObjects];

    // add root view controller
    [self addViewController:viewController sender:nil animated:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addViewController:(CLViewController*)viewController sender:(CLViewController*)sender animated:(BOOL)animated {
    
    // if in not sent from categoirs view
    if (sender) {

        // get index of sender
        NSInteger indexOfSender = [_viewControllers indexOfObject:sender];
        
        // if sender is not last view controller
        if (indexOfSender != [_viewControllers count] - 1) {
            
            // count of views to pop
            NSInteger count = [_viewControllers count] - indexOfSender - 1;
            
            // pop views
            for (NSInteger i = count; i>0; i--) {
                NSInteger inx = indexOfSender + i;
                [_cascadeView popPageAtIndex:inx animated:animated];
            }
            
            
//            NSLog(@"QQ: %i %i", indexOfSender + 1, count);
//
//            for (NSInteger i = count; i>0; i--) {
//                NSInteger inx = indexOfSender + i;
//                UIViewController* ccv = [_viewControllers objectAtIndex:inx];
//                NSLog(@"%p %i", ccv, [ccv retainCount]);
//            }
            
            // remove controllers
            [_viewControllers removeObjectsInRange:NSMakeRange(indexOfSender + 1, count)];
        }
    } 
    
    // set cascade navigator to view controller
    [viewController setCascadeNavigationController: self];
    // set parrent view controller, if rootViewController, then nil
    [viewController setParentViewController: sender];
    // add controller to array
    [self.viewControllers addObject: viewController];

    // push view
    [_cascadeView pushPage:[viewController view] 
                  fromPage:[sender view] 
                  animated:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isOnStack:(UIViewController*)viewController {
    UIView* view = [viewController view];
    return [_cascadeView isOnStack: view];
}

@end
