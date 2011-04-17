//
//  CLPhotoViewController.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-07.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLViewController.h"

@class CLImageScrollView;

@interface CLPhotoViewController : CLViewController <UIScrollViewDelegate> {
    
    UIScrollView *pagingScrollView;
    
    NSMutableSet *recycledPages;
    NSMutableSet *visiblePages;
}

@end
