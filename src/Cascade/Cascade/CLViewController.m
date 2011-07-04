//
//  CLViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLViewController.h"
#import "CLCascadeNavigationController.h"

@implementation CLViewController

@synthesize cascadeNavigationController = _cascadeNavigationController;
@dynamic segmentedView;
@dynamic headerView;
@dynamic footerView;
@dynamic contentView;

- (id)init
{
	if ((self = [super init])) {
		_originShadow = nil;
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    if (_originShadow)
		[_originShadow release], _originShadow = nil;    

	self.cascadeNavigationController = nil;
	
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.        
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	
    if (_originShadow)
		[_originShadow release], _originShadow = nil;    
	
	self.cascadeNavigationController = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark CLSegmentedView methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadView {
    NSString *nib = self.nibName;
	
    if (nib) {
        NSBundle *bundle = self.nibBundle;
        if(!bundle) bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:nib ofType:@"nib"];
        
        if(path) {
            self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
            return;
        }
    }

	// If there isn't a nib for this view controller, we're assuming it's for a segmented view
    CLSegmentedView* view_ = [[CLSegmentedView alloc] init];
    self.view = view_;
    [view_ release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLSegmentedView*) segmentedView {
    return (CLSegmentedView*)self.view;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) headerView {
	
    if (![self.view isKindOfClass:[CLSegmentedView class]]) return nil;
    
    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.headerView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) footerView {
	
    if (![self.view isKindOfClass:[CLSegmentedView class]]) return nil;
    
    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.footerView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) contentView {
    if (![self.view isKindOfClass:[CLSegmentedView class]]) return self.view;
	
    CLSegmentedView* view_ = (CLSegmentedView*)self.view;
    return view_.contentView;
}

#pragma mark -
#pragma mark Class methods


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha animated:(BOOL)animated {
    
    if (!_originShadow) {
        _originShadow = [[CAGradientLayer alloc] init];
    }
    
    _originShadow.startPoint = CGPointMake(0, 0.5);
    _originShadow.endPoint = CGPointMake(1.0, 0.5);
    CGRect newShadowFrame = CGRectMake(0, 0, width, self.view.frame.size.height);
    
    _originShadow.frame = newShadowFrame;
    _originShadow.colors = [NSArray arrayWithObjects: 
                            (id)([[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor), 
                            (id)([shadowColor colorWithAlphaComponent: alpha].CGColor), 
                            nil];
    _originShadow.opacity = 0.0;
	if ([self.view isKindOfClass:[CLSegmentedView class]])
		[(CLSegmentedView*)self.view setShadow:_originShadow withWidth:width];
    
    [self showShadow: animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) showShadow:(BOOL)animated {
//    if (![_originShadow isHidden]) return;
    
    if (!animated) {
        [_originShadow setHidden: NO];
    } else {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:0.0];
        animation.toValue = [NSNumber numberWithFloat:1.0];
        animation.duration = 1.2;
        _originShadow.opacity = 1.0;
        [_originShadow addAnimation:animation forKey:@"opacityAnimation"];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) hideShadow:(BOOL)animated {
//    if ([_originShadow isHidden]) return;

    if (!animated) {
        [_originShadow setHidden: YES];
    } else {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.0];
        animation.duration = 0.7;
        _originShadow.opacity = 0.0;
        [_originShadow addAnimation:animation forKey:@"opacityAnimation"];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushDetailViewController:(CLViewController *)viewController animated:(BOOL)animated {
    [self.cascadeNavigationController addViewController:viewController sender:self animated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isOnStack {
    return [_cascadeNavigationController isOnStack: self];
}

#pragma mark CLViewControllerDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidAppear {
    /*
     * Called when page (view of this controller) will be unveiled by 
     * another page or will slide in CascadeView bounds
     */
    
    
    [self showShadow: NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidDisappear {
    /*
     * Called when page (view of this controller) will be shadowed by 
     * another page or will slide out CascadeView bounds
     */

    [self hideShadow: NO];
//    if ([self isOnStack]) {
//        UIViewController* parentViewController = [self parentViewController];
//        
//        if ([parentViewController isKindOfClass:[CLViewController class]]) {
//            [(CLViewController*)parentViewController hideShadow: NO];
//        }
//    }
}

@end
