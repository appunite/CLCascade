//
//  CLMultiplePageEffectView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 29.08.2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CLMultiPageEffectNone = 0,
    CLMultiPageEffectFirstLevel,
    CLMultiPageEffectSecondLevel,
} CLMultiPageEffectType;

@interface CLMultiplePageEffectView : UIView {
    CLMultiPageEffectType _type;
}

- (void) setMultiPageEffectType:(CLMultiPageEffectType)type;

@end
