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

@interface CLCascadeNavigationController (Private)
@property (nonatomic, retain, readwrite) NSMutableArray* viewControllers;
@end

@implementation CLCascadeNavigationController

@synthesize viewControllers = _viewControllers;
@synthesize offset, pageWidth;

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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Getters & Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray*) viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    return _viewControllers;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setViewControllers:(NSMutableArray*)array {
    if (_viewControllers != array) {
        [_viewControllers release];
        _viewControllers = [array retain];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) offset {
    return _cascadeView.offset;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setOffset:(CGFloat)newOffset {
    [_cascadeView setOffset: newOffset];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) pageWidth {
    return _cascadeView.pageWidth;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setPageWidth:(CGFloat)newWidth {
    [_cascadeView setPageWidth:newWidth];
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
    if (controller && [controller respondsToSelector:@selector(pageDidAppear)]) {
        [controller pageDidAppear];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index {
    if (index > [_viewControllers count] - 1) return;
    
    UIViewController<CLViewControllerDelegate>* controller = [_viewControllers objectAtIndex: index];
    if (controller && [controller respondsToSelector:@selector(pageDidAppear)]) {
        [controller pageDidDisappear];
    }
}


#pragma mark -
#pragma mark Calss methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLViewController*)viewController animated:(BOOL)animated {
    // pop all pages
    [_cascadeView popAllPagesAnimated: animated];
	
#warning GREG
	// ---- Since we're setting the parentViewController for each of those controllers, illegally, should we set it to nil here???
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
            NSInteger count = ([_viewControllers count] - indexOfSender) - 1;
            
            // pop views
            for (NSInteger i = count; i>0; i--) {
                NSInteger inx = indexOfSender + i;
                [_cascadeView popPageAtIndex:inx animated:animated];
            }
            
			// Since we're setting the parentViewController of these on push, we need to set it to nil, otherwise crash on dealloc

			NSArray *toRemove = [_viewControllers subarrayWithRange:NSMakeRange(indexOfSender + 1, count)];
			for (UIViewController *controller in [toRemove reverseObjectEnumerator]) {
				[controller setParentViewController: nil];
				[_viewControllers removeObject:controller];
			}

        }
    } 
    
#warning GREG fix this for UINavigationController
    // set cascade navigator to view controller
	if ([viewController respondsToSelector:@selector(setCascadeNavigationController:)])
		[viewController setCascadeNavigationController: self];
	
	// ----- THIS IS INCREDIBLY DANGEROUS ------- 
	// UIViewController assumes that no one is screwing around with this property ... its a big issue during dealloc
	// Moreover, this will break when running iOS 5 .. where I think you tell the sender to addChildViewController, not the other way around
	// Shouldn't *this* controller be the parentViewController anyway???
	
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
