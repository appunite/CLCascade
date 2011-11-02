//
//  CLWebViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLWebViewController.h"
#import "CLGlobal.h"

#import "UIViewController+CLSegmentedView.h"

@implementation CLWebViewController

@dynamic webView;
@synthesize requestURL = _requestURL;

- (void) loadView {
    self.view = [[CLSegmentedView alloc] initWithSize:CLViewSizeWider];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) init {
    self = [super init];
    if (self) {
        self.viewSize = CLViewSizeWider;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewSize = CLViewSizeWider;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithURL:(NSURL*)url {
    self = [self init];
    if (self) {
        _requestURL = url;
        self.viewSize = CLViewSizeWider;
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

- (void)dealloc {
    _activityIndicatorView = nil;
    _requestURL = nil;
}
#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstLoad = YES;
    
    // create web view
    UIWebView* webView_ = [[UIWebView alloc] init];
    // set up webView
    [webView_ setDelegate:self];
    [webView_ setScalesPageToFit: YES];
    [webView_ setDataDetectorTypes: UIDataDetectorTypeAll];
    // set contentView of CLSegmentedView
    [self setWebView: webView_];
    
    // load request
    [self loadRequest];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadRequest {
    if ([self.webView isLoading]) {
        [self.webView stopLoading];    
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL: (_requestURL) ? _requestURL : [NSURL URLWithString: DEFAULT_URL]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:30.0];
    [self.webView loadRequest: request];    
}
 

#pragma mark -
#pragma mark WebViewDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (_firstLoad) {

        _firstLoad = NO;
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView setCenter: CGPointMake(self.webView.frame.size.width/2, self.webView.frame.size.height/2)];
        [_activityIndicatorView startAnimating];
        [self.webView addSubview: _activityIndicatorView];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (_activityIndicatorView) {
        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView = nil;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (_activityIndicatorView) {
        [_activityIndicatorView removeFromSuperview];
        _activityIndicatorView = nil;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setRequestURL:(NSURL*)url {
    if (_requestURL != url) {
        _requestURL = url;

        [self loadRequest];
    }
}

@end
