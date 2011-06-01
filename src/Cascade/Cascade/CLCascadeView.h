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
    CLDraggingDirectionRight    = -1,
    CLDraggingDirectionUnknow   =  0,
    CLDraggingDirectionLeft     =  1
} CLDraggingDirection;

@interface CLCascadeView : UIView {
    id<CLCascadeViewDelegate> _delegate;
    id<CLCascadeViewDataSource> _dataSource;

    NSMutableArray* _pages;
    
    // you need call visiblePages to refresh this ivar
    NSMutableArray* _visiblePages;
    
    //
    CGFloat _pageWidth;
    CGFloat _offset;
    
    // dragging
    CGPoint _startTouchPoint;
    CGPoint _newTouchPoint;
    CGPoint _lastTouchPoint;
    
    UIView* _touchedPage;
    
    CLDraggingDirection _directon;
    
    struct {
        unsigned int dragging:1;
        unsigned int decelerating:1;
    } _cascadeViewFlags;
}

@property(nonatomic, assign) id<CLCascadeViewDelegate> delegate;
@property(nonatomic, assign) id<CLCascadeViewDataSource> dataSource;

@property(nonatomic,readonly,getter=isDragging) BOOL dragging;    
@property(nonatomic,readonly,getter=isDecelerating) BOOL decelerating;

/*
 * You can change page width, default is 479.0f
 */
@property(nonatomic) CGFloat pageWidth;

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

/*
 * Called when page will be unveiled by another page or will slide in CascadeView bounds
 */
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index;
/*
 * Called when page will be shadowed by another page or will slide out CascadeView bounds
 */
- (void) cascadeView:(CLCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index;

@end
