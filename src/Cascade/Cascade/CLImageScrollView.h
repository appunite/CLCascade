//
//  CLImageScrollView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-07.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CLImageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIView        *imageView;
    NSUInteger     index;
}
@property (assign) NSUInteger index;

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;

@end
