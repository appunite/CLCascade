//
//  CLSegmentedView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CLSegmentedView : UIView {
    UIView* _headerView;
    UIView* _footerView;
    UIView* _contentView;

    CAGradientLayer* _shadow;
    CGFloat _shadowWidth;
}

/*
 * Header view - located on the top of view
 */
@property (nonatomic, assign) IBOutlet UIView* headerView;

/*
 * Footer view - located on the bottom of view
 */
@property (nonatomic, assign) IBOutlet UIView* footerView;

/*
 * Content view - located between header and footer view 
 */
@property (nonatomic, assign) IBOutlet UIView* contentView;

/*
 * Shadow on the left side of the view
 */
@property (nonatomic, retain) CAGradientLayer* shadow;

/*
 * The width of the shadow
 */
@property (nonatomic, assign) CGFloat shadowWidth;

/* 
 * This method adds the left outer shadow
 */
- (void) setShadow:(CAGradientLayer*)shadow withWidth:(CGFloat)with;

@end
