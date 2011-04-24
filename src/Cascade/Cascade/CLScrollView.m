//
//  CLScrollView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-22.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLScrollView.h"

@interface CLScrollView (Private)
- (void) setUpView;
@end

@implementation CLScrollView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setUpView {
    self.clipsToBounds = NO;
    self.bounces = YES;
    self.directionalLockEnabled = YES;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
}

@end
