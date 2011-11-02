//
//  CLSegmentedView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CLGlobal.h"

@interface CLSegmentedView : UIView {
    CLViewSize _viewSize;

    UIView* _headerView;
    UIView* _footerView;
    UIView* _contentView;
    UIView* _roundedCornersView;
    
    BOOL _showRoundedCorners;
    UIRectCorner _rectCorner;
}

/*
 * Header view - located on the top of view
 */
@property (nonatomic, strong) IBOutlet UIView* headerView;

/*
 * Footer view - located on the bottom of view
 */
@property (nonatomic, strong) IBOutlet UIView* footerView;

/*
 * Content view - located between header and footer view 
 */
@property (nonatomic, strong) IBOutlet UIView* contentView;


/*
 * Set YES if you want rounded corners. Default NO.
 */
@property (nonatomic, assign) BOOL showRoundedCorners;

/*
 * Type of rect corners. Default UIRectCornerAllCorners.
 */

@property (nonatomic, assign) UIRectCorner rectCorner;

/*
 * Size of view
 */
@property (nonatomic, assign, readonly) CLViewSize viewSize;

- (id) initWithSize:(CLViewSize)size;

@end
