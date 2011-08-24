//
//  ExampleWebViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExampleWebViewController.h"

@implementation ExampleWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CAGradientLayer*) outerLeftShadow {
    
    // generate default shadow
    CAGradientLayer* shadow = [CAGradientLayer layer];
    shadow.startPoint = CGPointMake(0, 0.5);
    shadow.endPoint = CGPointMake(1.0, 0.5);
    
    shadow.colors = [NSArray arrayWithObjects: 
                     (id)([[UIColor clearColor] colorWithAlphaComponent:0.0].CGColor), 
                     (id)([[UIColor colorWithRed:0.208 green:0.165 blue:0.118 alpha:1.0] colorWithAlphaComponent: 0.35].CGColor), 
                     nil];
    
    return shadow;
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
    [header release];

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
    NSURL* url = [NSURL URLWithString: @"https://github.com/creativelabs/CLCascade"];
    return [NSURLRequest requestWithURL:url 
                            cachePolicy:NSURLRequestUseProtocolCachePolicy 
                        timeoutInterval:30.0];
}

@end
