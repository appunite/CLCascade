//
//  CLWebViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLWebViewController.h"

@implementation CLWebViewController

@dynamic webView;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    // create web view
    UIWebView* webView_ = [[UIWebView alloc] init];
    // set up webView
    [webView_ setScalesPageToFit: YES];
    [webView_ setDataDetectorTypes: UIDataDetectorTypeAll];
    // set contentView of CLSegmentedView
    [self setWebView: webView_];
    [webView_ release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if is not loading then load www.google.com
    if (![self.webView isLoading]) {
        //create default request
        NSURL* url = [NSURL URLWithString: @"http://www.google.com"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url 
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                             timeoutInterval:30.0];
        [self.webView loadRequest: request];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Getters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIWebView*) webView {
    return (UIWebView*)[self.segmentedView contentView];
}


#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setWebView:(UIWebView *)newWebView {
//    [newWebView setDirectionalLockEnabled: YES];
    [self.segmentedView setContentView: newWebView];
}


@end
