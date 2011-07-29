//
//  CLScrollView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 26.07.2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLScrollView.h"

@implementation CLScrollView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    NSLog(@"%@", NSStringFromCGRect(rect));
    // bug fix with auto scrolling when become first responder
    // do not overide it
}

@end
