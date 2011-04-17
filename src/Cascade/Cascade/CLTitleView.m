//
//  CLTitleView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-28.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLTitleView.h"

@interface CLTitleView (Private)
- (void) createAll;
@end

@implementation CLTitleView

@synthesize titleLabel = _titleLabel;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) createAll {
    
    [self setUserInteractionEnabled: YES];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setBackgroundColor: [UIColor whiteColor]];
    [_titleLabel setTextAlignment: UITextAlignmentCenter];
    [_titleLabel setLineBreakMode: UILineBreakModeTailTruncation];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize: 20.0]];
    [_titleLabel setText:@"Title"];
    [_titleLabel setTextColor: [UIColor blackColor]];
    [self addSubview:_titleLabel];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self createAll];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAll];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    _titleLabel.frame = self.frame;    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_titleLabel release], _titleLabel = nil;
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setTitleText:(NSString*)title {
    [self.titleLabel setText: title];
}

@end
