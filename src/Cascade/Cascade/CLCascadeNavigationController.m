//
//  CLCascadeNavigationController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeNavigationController.h"

@interface CLCascadeNavigationController (Private)
@property (nonatomic, retain, readwrite) NSMutableArray* viewControllers;
@end

@implementation CLCascadeNavigationController

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
    NSLog(@"didLoadPage: %@", page);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didUnloadPage:(UIView*)page {
    NSLog(@"didUnloadPage: %@", page);
    //todo: unload page in controller, set message viewDidUnload
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didAddPage:(UIView*)page animated:(BOOL)animated {
    NSLog(@"didAddPage: %@", page);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index {
    NSLog(@"didAddPage: %i", index);
    // todo: delete controller
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageWillAppearAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSLog(@"pageWillAppearAtIndex: %i", index);
    [[_viewControllers objectAtIndex: index] viewWillAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSLog(@"pageDidAppearAtIndex: %i", index);
    [[_viewControllers objectAtIndex: index] viewDidAppear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageWillDisappearAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSLog(@"pageWillDisappearAtIndex: %i", index);
    [[_viewControllers objectAtIndex: index] viewWillDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index animated:(BOOL)animated {
    NSLog(@"pageDidDisappearAtIndex: %i", index);
    [[_viewControllers objectAtIndex: index] viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Calss methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRootViewController:(CLViewController*)viewController animated:(BOOL)animated {
    [self.viewControllers removeAllObjects];
    [_cascadeView popAllPagesAnimated: animated];

    [self.viewControllers addObject: viewController];
    [self addViewController:viewController sender:nil animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addViewController:(CLViewController*)viewController sender:(CLViewController*)sender animated:(BOOL)animated {
    
    [viewController setCascadeNavigationController: self];
    [self.viewControllers addObject: viewController];

    [_cascadeView pushPage:[viewController view] 
                  fromPage:[sender view] 
                  animated:animated];
}
@end
