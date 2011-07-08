//
//  CLWebViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-07-08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLViewController.h"

@interface CLWebViewController : CLViewController {
    UIWebView* _webView;
}

@property (nonatomic, retain) UIWebView* webView;

@end
