//
//  CLMultiplePageEffectView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 29.08.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CLMultiplePageEffectView.h"

@implementation CLMultiplePageEffectView

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];

        [self setAutoresizingMask:
         UIViewAutoresizingFlexibleLeftMargin | 
         UIViewAutoresizingFlexibleRightMargin | 
         UIViewAutoresizingFlexibleBottomMargin | 
         UIViewAutoresizingFlexibleTopMargin | 
         UIViewAutoresizingFlexibleWidth | 
         UIViewAutoresizingFlexibleHeight];
        
        _type = CLMultiPageEffectNone;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];

        [self setAutoresizingMask:
         UIViewAutoresizingFlexibleLeftMargin | 
         UIViewAutoresizingFlexibleRightMargin | 
         UIViewAutoresizingFlexibleBottomMargin | 
         UIViewAutoresizingFlexibleTopMargin | 
         UIViewAutoresizingFlexibleWidth | 
         UIViewAutoresizingFlexibleHeight];

        _type = CLMultiPageEffectNone;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) drawRect:(CGRect)rect {
    
    if (_type != CLMultiPageEffectNone) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, rect);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        
        CGContextSetRGBFillColor(context, 197.0f/255.0f, 197.0f/255.0f, 197.0f/255.0f, 1.0f);
        CGContextFillRect(context, CGRectMake(2.0f, 0.0f, 1.0f, rect.size.height));
        
        CGContextSetRGBFillColor(context, 154.0f/255.0f, 154.0f/255.0f, 154.0f/255.0f, 1.0f);
        CGContextFillRect(context, CGRectMake(3.0f, 0.0f, 1.0f, rect.size.height));    

        if (_type == CLMultiPageEffectSecondLevel) {
            CGContextSetRGBFillColor(context, 195.0f/255.0f, 195.0f/255.0f, 195.0f/255.0f, 1.0f);
            CGContextFillRect(context, CGRectMake(0.0f, 0.0f, 1.0f, rect.size.height));
            
            CGContextSetRGBFillColor(context, 154.0f/255.0f, 154.0f/255.0f, 154.0f/255.0f, 1.0f);
            CGContextFillRect(context, CGRectMake(1.0f, 0.0f, 1.0f, rect.size.height));
        }
        
    }    
}

- (void) setMultiPageEffectType:(CLMultiPageEffectType)type {
    if (_type != type) {
        _type = type;
        [self setNeedsDisplay];
    }
}

@end
