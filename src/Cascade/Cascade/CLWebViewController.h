//
//  CLWebViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLViewController.h"

@interface CLWebViewController : CLViewController <UIWebViewDelegate> {
    UIActivityIndicatorView* _activityIndicatorView;
    BOOL _firstLoad;
}

@property (nonatomic, retain) UIWebView* webView;

/*
 * This method fire loadRequest in webView.
 */
- (void) loadRequest;

/*
 * Override this method to change webView load request URL
 */
- (NSURL*) requestURL;

@end
