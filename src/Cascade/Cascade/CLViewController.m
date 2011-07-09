//
//  CLViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLViewController.h"
#import "CLCascadeNavigationController.h"

#define SHOW_SHADOW YES

@implementation CLViewController

@synthesize cascadeNavigationController = _cascadeNavigationController;
@synthesize viewSize = _viewSize;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
    self = [super init];
    if (self) {
        _viewSize = CLViewSizeNormal;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewSize = CLViewSizeNormal;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithSize:(CLViewSize)size {
    self = [super init];
    if (self) {
        _viewSize = size;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil size:(CLViewSize)size {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewSize = size;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_cascadeNavigationController release], _cascadeNavigationController = nil;
//    [_originShadow release], _originShadow = nil;    
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
    
    CLSegmentedView* view_ = [[CLSegmentedView alloc] initWithSize: _viewSize];
    self.view = view_;
    [view_ release];
    
    [view_ setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin | 
     UIViewAutoresizingFlexibleTopMargin |
     UIViewAutoresizingFlexibleWidth | 
     UIViewAutoresizingFlexibleHeight];
}


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
- (void) setOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha animated:(BOOL)animated {
    if (!SHOW_SHADOW) return;
    
    if (!_originShadow) {
        _originShadow = [[[CAGradientLayer alloc] init] autorelease];
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
    NSAssert(_viewSize != CLViewSizeWider, @"cant %p", self);
    [self.cascadeNavigationController addViewController:viewController sender:self animated:animated];
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
}

@end
