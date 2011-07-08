//
//  CLWebViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLWebViewController.h"

@implementation CLWebViewController

@synthesize webView = _webView;

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


- (void)dealloc {
    [_webView release], _webView = nil;
    [super dealloc];
}


#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // create web view
    _webView = [[UIWebView alloc] init];
    // set up webView
    [_webView setScalesPageToFit: YES];
    [_webView setDataDetectorTypes: UIDataDetectorTypeAll];
    // set contentView of CLSegmentedView
    [(CLSegmentedView*)self.view setContentView: _webView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if is not loading then load www.google.com
    if (![_webView isLoading]) {
        //create default request
        NSURL* url = [NSURL URLWithString: @"http://www.google.com"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [_webView loadRequest: request];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
