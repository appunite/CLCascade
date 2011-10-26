//
//  CLViewControllerDelegate.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CLViewControllerDelegate <NSObject>

/*
 * Called when page (view of controller) will be unveiled by 
 * another page or will slide in CascadeView bounds
 */
- (void) pageDidAppear;

/*
 * Called when page (view of this controller) will be shadowed by 
 * another page or will slide out CascadeView bounds
 */
- (void) pageDidDisappear;

@end
