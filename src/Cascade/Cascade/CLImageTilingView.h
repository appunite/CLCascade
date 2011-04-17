//
//  CLImageTilingView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-07.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CLImageTilingView : UIView {
    NSString *imageName;
    BOOL      annotates;
}
@property (assign) BOOL annotates;

- (id)initWithImageName:(NSString *)name size:(CGSize)size;
- (UIImage *)tileForScale:(CGFloat)scale row:(int)row col:(int)col;

@end
