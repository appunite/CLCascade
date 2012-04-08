//
//  ExampleWebViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleWebViewController.h"

@implementation ExampleWebViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    // add shadow
    [self addLeftBorderShadowWithWidth:40.0 andOffset:0.0f];
    
    // add header view
    UIImageView* header = [[UIImageView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.bounds.size.width, 45.0)];
    [header setImage: [UIImage imageNamed:@"ToolBar_479x45.png"]];
    [self.segmentedView setHeaderView: header];

    // show rounded corners
    [self setShowRoundedCorners: NO];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURLRequest*) request {
    NSURL* url = [NSURL URLWithString: @"https://github.com/appunite/CLCascade"];
    return [NSURLRequest requestWithURL:url 
                            cachePolicy:NSURLRequestUseProtocolCachePolicy 
                        timeoutInterval:30.0];
}

@end
