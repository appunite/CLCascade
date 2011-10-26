//
//  CLWebViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cascade/CLCustomViewControllers/CLViewController.h>

@interface CLWebViewController : CLViewController <UIWebViewDelegate> {
    UIActivityIndicatorView* _activityIndicatorView;
    BOOL _firstLoad;
    NSURL* _requestURL;
}

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) NSURL* requestURL;

- (id) initWithURL:(NSURL*)url;

/*
 * This method fire loadRequest in webView.
 */
- (void) loadRequest;
 
@end
