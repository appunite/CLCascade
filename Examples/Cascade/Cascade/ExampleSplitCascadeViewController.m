//
//  
//  Cascade
//
//  Created by Emil Wojtaszek on 11-06-03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleSplitCascadeViewController.h"

@implementation ExampleSplitCascadeViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad {
    [super viewDidLoad];
    
    // add background
    UIView* backgroundView = [[UIView alloc] init];
    [backgroundView setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"brown_bg_128x128"]]];
    [self setBackgroundView:backgroundView];
    
    // add divider
    UIImage* divider = [UIImage imageNamed:@"divider_vertical.png"];
    [self setDividerImage: divider];
    
    // change offsets
    [self.cascadeNavigationController setLeftInset: 58.0f];
    [self.cascadeNavigationController setWiderLeftInset: 210.0f];
}


@end
