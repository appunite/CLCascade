//
//  CLContainerView.m
//  Cascade
//
//  Created by Marian Paul on 02/11/11.
//  Copyright (c) 2011 iPuP SARL. All rights reserved.
//

#import "CLContainerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLContainerView
@synthesize shadowWidth = _shadowWidth;
@synthesize shadowOffset = _shadowOffset;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addLeftBorderShadowView:(UIView *)view withWidth:(CGFloat)width {
    
    [self setClipsToBounds: NO];
    
    if (_shadowWidth != width) {
        _shadowWidth = width;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    
    if (view != _shadowView) {
        _shadowView = view;
        
        [self insertSubview:_shadowView atIndex:0];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) removeLeftBorderShadowView {
    
    [self setClipsToBounds: YES];
    
    _shadowView = nil;
    [self setNeedsLayout];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;

    if (_shadowView) {
        CGRect shadowFrame = CGRectMake(0 - _shadowWidth + _shadowOffset, 0.0, _shadowWidth, rect.size.height);
        _shadowView.frame = shadowFrame;
    }
    
    /*if (self.subviews.count > 1) {
        UIView *firstView = [self.subviews objectAtIndex:1];
        firstView.layer.shouldRasterize = YES;
        firstView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
                                                   byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(6.0f, 6.0f)];
        [shapeLayer setPath:[path CGPath]];
        firstView.layer.mask = shapeLayer;
    }*/
    // Removed because performances are really bad ...
    // TODO : create a method to add / remove the mask
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-  (void) dealloc {
    _shadowView = nil;
}

@end
