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

@interface CLCascadeView : UIView <UIScrollViewDelegate> {
    // delegate and dataSource
    id<CLCascadeViewDelegate> _delegate;
    id<CLCascadeViewDataSource> _dataSource;

    // scroll view
    UIScrollView* _scrollView;
    
    // contain all pages, if page is unloaded then page is respresented as [NSNull null]
    NSMutableArray* _pages;
    
    //sizes
    CGFloat _leftInset;
    CGFloat _pageWidth;
    CGFloat _widerPageWidth;

    BOOL _pullToDetachPages;

@private
    struct {
        unsigned int willDetachPages:1;
        unsigned int isDetachPages:1;
    } _flags;

}

@property(nonatomic, assign) id<CLCascadeViewDelegate> delegate;
@property(nonatomic, assign) id<CLCascadeViewDataSource> dataSource;

/*
 * Left inset of pages from left boarder. Default 58.0f
 */
@property(nonatomic) CGFloat leftInset;

/*
 * You can change page width, default (1024.0 - leftInset) / 2.0, so
 * in landscape mode two pages fit properly
 */
@property(nonatomic, readonly) CGFloat pageWidth;

@property(nonatomic, assign) CGFloat widerPageWidth;
@property(nonatomic, assign) BOOL pullToDetachPages;

- (void) pushPage:(UIView*)newPage fromPage:(UIView*)fromPage animated:(BOOL)animated;

- (void) popPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) popAllPagesAnimated:(BOOL)animated;

- (UIView*) loadPageAtIndex:(NSInteger)index;

// unload page if is loaded (replabe by)
- (void) unloadPageIfNeeded:(NSInteger)index;
// unload page, by remove from superView and replace by [NSNull null]
- (void) unloadPage:(UIView*)page;
// unload pages which are not visible
- (void) unloadInvisiblePages;

- (NSInteger) indexOfFirstVisibleView:(BOOL)loadIfNeeded;

- (void) updateContentLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;
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

/*
 */
- (void) cascadeViewDidStartPullingToDetachPages:(CLCascadeView*)cascadeView;
- (void) cascadeViewDidPullToDetachPages:(CLCascadeView*)cascadeView;
- (void) cascadeViewDidCancelPullToDetachPages:(CLCascadeView*)cascadeView;

@end
