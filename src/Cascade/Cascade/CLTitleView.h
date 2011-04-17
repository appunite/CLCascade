//
//  CLTitleView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-28.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CLTitleView : UIImageView {
    UILabel*    _titleLabel;
}

@property (nonatomic, retain) UILabel*  titleLabel;

- (void) setTitleText:(NSString*)title;

@end
