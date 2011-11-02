//
//  CLContainerView.h
//  Cascade
//
//  Created by Marian Paul on 02/11/11.
//  Copyright (c) 2011 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLContainerView : UIView
{
    UIView* _shadowView;
}

/*
 * The width of the shadow
 */
@property (nonatomic, assign) CGFloat shadowWidth;

/*
 * The offset of the shadow in X-axis. Default 0.0
 */
@property (nonatomic, assign) CGFloat shadowOffset;

/* 
 * This methoad add left outer shadow view with proper width
 */
- (void) addLeftBorderShadowView:(UIView *)view withWidth:(CGFloat)width;

/* 
 * This methoad remove left outer shadow
 */
- (void) removeLeftBorderShadowView;

@end
