//
//  CLViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-26.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLViewController.h"
#import "CLCascadeViewController.h"

@implementation CLViewController
@synthesize parentCascadeViewController = _parentCascadeViewController;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_parentCascadeViewController release], _parentCascadeViewController = nil;
    [_originShadow release], _originShadow = nil;
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
    [self updateLayout];
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
	return NO;
}

#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateLayout {
    if (_originShadow) {

        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        
        CGRect originShadowFrame = CGRectMake(0 - _shadowWidth, 0.0, _shadowWidth, self.view.bounds.size.height);
        _originShadow.frame = originShadowFrame;
        
        [CATransaction commit];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addOuterLeftShadow:(UIColor*)shadowColor width:(CGFloat)width alpha:(CGFloat)alpha {
    
//    self.view.clipsToBounds = NO;
	//
	// Construct the origin shadow if needed
	//
    
    _shadowWidth = width;
    
	if (!_originShadow)
	{

        _originShadow = [[[CAGradientLayer alloc] init] autorelease];
        _originShadow.startPoint = CGPointMake(0, 0.5);
        _originShadow.endPoint = CGPointMake(1.0, 0.5);
        CGRect newShadowFrame = CGRectMake(0, 0, _shadowWidth, self.view.frame.size.height);
        
        _originShadow.frame = newShadowFrame;
        _originShadow.colors = [NSArray arrayWithObjects: 
                            (id)([[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor), 
                            (id)([shadowColor colorWithAlphaComponent: alpha].CGColor), 
                            nil];
        
        [self.view.layer insertSublayer:_originShadow atIndex:0];
	} else { //if (![[self.view.layer.sublayers objectAtIndex:0] isEqual:_originShadow])
        [_originShadow removeFromSuperlayer];
		[self.view.layer insertSublayer:_originShadow atIndex:0];
	}
    
	[self updateLayout];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushDetailViewController:(CLViewController *)viewController {
    if (_parentCascadeViewController != nil) {
        CLCascadeViewController* cascadeViewController = [[CLCascadeViewController alloc] 
                                                          initWithMasterPositionViewController:viewController];
        [_parentCascadeViewController pushCascadeViewController: cascadeViewController];
        [cascadeViewController release];
    }
}

@end
