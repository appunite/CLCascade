//
//  CLRetractableSectionHeaderView.m
//  CLRetractableSection
//
//  Created by Emil Wojtaszek on 11-05-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLRetractableSectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLRetractableSectionHeaderView


@synthesize delegate, section, titleLabel, isOpened;

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame section:(NSInteger)sectionNumber {

    self = [super initWithFrame:frame];
    
    if (self != nil) {

        section = sectionNumber;
        isOpened = NO;
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        self.userInteractionEnabled = YES;

        // Set the colors for the gradient layer.
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:0.82 green:0.84 blue:0.87 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.61 green:0.21 blue:0.59 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.61 green:0.21 blue:0.59 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];
        
        
    }
    
    return self;

}

- (id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber {
    
    self = [self initWithFrame:frame section:sectionNumber];
    
    if (self != nil) {
        
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];

    }
    
    return self;
}


- (IBAction)toggleOpen:(id)sender {
    
    if (!isOpened) {
        [self toggleOpenWithUserAction:YES];
    }
}


- (void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    isOpened = !isOpened;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (isOpened) {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [delegate sectionHeaderView:self sectionOpened:section];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [delegate sectionHeaderView:self sectionClosed:section];
            }
        }
    }
}


- (void)dealloc {

    [super dealloc];
}

@end

