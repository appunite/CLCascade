//
//  CLCascadeView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLCascadeViewDataSource;
@protocol CLCascadeViewDelegate;

typedef enum {
    CLDraggingDirectionLeft,
    CLDraggingDirectionRight,
    CLDraggingDirectionUnknow
} CLDraggingDirection;

@interface CLCascadeView : UIView {
    id<CLCascadeViewDelegate> _delegate;
    id<CLCascadeViewDataSource> _dataSource;

    NSMutableArray* _pages;
    
    CGFloat _pageWidth;
    
    NSInteger _actualRightPageIndex; 
    NSInteger _actualLeftPageIndex; 

    // dragging
    CGPoint _startTouchPoint;
    CGPoint _newTouchPoint;
    CGPoint _lastTouchPoint;
    
    UIView* _touchedPage;
    
    CLDraggingDirection _directon;
    
}

@property (nonatomic, assign) id<CLCascadeViewDelegate> delegate;
@property (nonatomic, assign) id<CLCascadeViewDataSource> dataSource;

- (void) pushPage:(UIView*)newPage fromPage:(UIView*)fromPage animated:(BOOL)animated;

- (void) popPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) popAllPagesAnimated:(BOOL)animated;

- (UIView*) loadPageAtIndex:(NSInteger)index;

- (void) unloadPageIfNeeded:(NSInteger)index;
- (void) unloadPage:(UIView*)page;
- (void) unloadInvisiblePages;

@end

@protocol CLCascadeViewDataSource <NSObject>
@required
- (UIView*) cascadeView:(CLCascadeView*)cascadeView pageAtIndex:(NSInteger)index;
- (NSInteger) numberOfPagesInCascadeView:(CLCascadeView*)cascadeView;
@end

@protocol CLCascadeViewDelegate <NSObject>
@optional
- (void) cascadeView:(CLCascadeView*)cascadeView didLoadPage:(UIView*)page;
- (void) cascadeView:(CLCascadeView*)cascadeView didUnloadPage:(UIView*)page;

- (void) cascadeView:(CLCascadeView*)cascadeView didAddPage:(UIView*)page animated:(BOOL)animated;
- (void) cascadeView:(CLCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index;

- (void) cascadeView:(CLCascadeView*)cascadeView pageWillAppearAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) cascadeView:(CLCascadeView*)cascadeView pageWillDisappearAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
