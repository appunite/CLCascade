//
//  CLCascadeView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeView.h"

@interface CLCascadeView (Private)
- (void) setUpView;
- (void) updateDraggingDirecton;
- (void) addPanGestureRecognizer:(UIView*)page;
- (void) updateLocationOfPages:(CGFloat)transition;
- (BOOL) isLastPage:(UIView*)page;
- (BOOL) isFirstPage:(UIView*)page;
- (NSArray*) visiblePages;
- (CGFloat) transition;
- (UIView*) topLeftVisiblePage;
- (UIView*) topRightVisiblePage;
- (void) refreshPageHeight:(UIView*)page;
@end

@interface CLCascadeView (DelegateMethods)
- (void) didLoadPage:(UIView*)page;
- (void) didAddPage:(UIView*)page animated:(BOOL)animated;
- (void) didPopPageAtIndex:(NSInteger)index;
- (void) didUnloadPage:(UIView*)page;
- (void) pageWillAppearAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) pageDidAppearAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) pageWillDisappearAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) pageDidDisappearAtIndex:(NSInteger)index animated:(BOOL)animated;
@end

#define DEFAULT_PAGE_WIDTH 479.0f

@implementation CLCascadeView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize dragging = _dragging;
@synthesize decelerating = _decelerating;
@synthesize pageWidth = _pageWidth;

#pragma mark Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _dataSource = nil;
    _delegate = nil;
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) layoutSubviews {
    NSArray* visibleViews = [self visiblePages];

    for (UIView* view in visibleViews) {
        [self refreshPageHeight: view];
    }
    
}


static const CGFloat kResistance = 0.15;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)resist:(CGFloat)x1 to:(CGFloat)x2 max:(CGFloat)max {
    // The closer we get to the maximum, the less we are allowed to increment
    CGFloat rl = (1 - (fabs(x2) / max)) * kResistance;
    if (rl < 0) rl = 0;
    if (rl > 1) rl = 1;
    return x1 + ((x2 - x1) * rl);
}

#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setUpView {
    _pages = [[NSMutableArray alloc] init];
    
    [self setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin | 
     UIViewAutoresizingFlexibleTopMargin | 
     UIViewAutoresizingFlexibleWidth | 
     UIViewAutoresizingFlexibleHeight];

    _actualRightPageIndex = NSNotFound; 
    _actualLeftPageIndex = NSNotFound; 

    _pageWidth = DEFAULT_PAGE_WIDTH;
    
    _cascadeViewFlags.decelerating = NO;
    _cascadeViewFlags.dragging = NO;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addPanGestureRecognizer:(UIView*)view {
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] 
                                          initWithTarget:self 
                                          action:@selector(panGesture:)];
    [view addGestureRecognizer: panGesture];
    [panGesture release];    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) panGesture:(UIPanGestureRecognizer*)gesture {
    _touchedPage = gesture.view;

    switch(gesture.state) {
        case UIGestureRecognizerStateChanged:
            // get net touch point
            _newTouchPoint = [gesture locationInView: self];
            // update dragging direction
            [self updateDraggingDirecton];
            // update location of pages
            [self updateLocationOfPages: [self transition]];
            _lastTouchPoint = _newTouchPoint;
            
            break;
        case UIGestureRecognizerStateBegan:
            // set up points
            _startTouchPoint = [gesture locationInView: _touchedPage];
            _lastTouchPoint = [gesture locationInView: self];
            // set flags
            _cascadeViewFlags.dragging = YES;
            _cascadeViewFlags.decelerating = NO;
            
            break;
        case UIGestureRecognizerStateEnded:
            // reset points
            _startTouchPoint = CGPointZero;
            _newTouchPoint = CGPointZero;
            _lastTouchPoint = CGPointZero;
            // resete flags
            _directon = CLDraggingDirectionUnknow;
            _cascadeViewFlags.dragging = NO;
            _cascadeViewFlags.decelerating = YES;
            break;
        default:
            break;
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) transition {
    return _lastTouchPoint.x - _newTouchPoint.x;   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateDraggingDirecton {
    CGFloat dx = [self transition];
    
    if ((dx == 0) || (!_cascadeViewFlags.dragging)) {
        _directon = CLDraggingDirectionUnknow;
    } else {
        _directon = (dx > 0) ? CLDraggingDirectionLeft : CLDraggingDirectionRight;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateLocationOfPages:(CGFloat)transition {

    if (_directon == CLDraggingDirectionUnknow) return;

    NSArray* array = [self visiblePages];

    NSInteger newOriginX = 0;
    CGRect lastFrame = CGRectNull;
    NSEnumerator* enumerator;
    UIView* view;    

    if (_directon == CLDraggingDirectionLeft) {
        enumerator = [array reverseObjectEnumerator];
    }
    if (_directon == CLDraggingDirectionRight) {
        enumerator = [array objectEnumerator];
    }
    
    while ((view = [enumerator nextObject])) {
        
        if (_directon == CLDraggingDirectionLeft) { //get new one on right
            if (!(view.frame.origin.x <= 0)) {
                CGRect newFrame = view.frame;
                
                if (CGRectEqualToRect(lastFrame, CGRectNull)) {
                    newOriginX = newFrame.origin.x - transition;
                } else {
                    newOriginX = lastFrame.origin.x + lastFrame.size.width;
                }
                
                newFrame.origin.x = MAX(0, newOriginX);
                [view setFrame: newFrame];
                lastFrame = newFrame;
            }
        }        
        
        if (_directon == CLDraggingDirectionRight) { //get new one on left
            CGRect newFrame = view.frame;
            
            if (!CGRectIntersectsRect(lastFrame, view.frame) || [self isLastPage:view]) {
                newOriginX = newFrame.origin.x - transition;
                newFrame.origin.x = MAX(0, newOriginX);
                [view setFrame: newFrame];
            }
            
            lastFrame = newFrame;
        }
    }
    
    [self setNeedsLayout];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*) visiblePages {

    // get top visible left page
    UIView* topPage = [self topRightVisiblePage];
    
    // if page exists (so, if _pages has any object)
    if (topPage) {

        // top index of top page
        NSUInteger topPageIndex = [_pages indexOfObject: topPage];
        
        // calcule how many other pagas can be visible
        NSInteger count = ceil( topPage.frame.origin.x / _pageWidth );
        
        // create array
        NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];

        // add top right visible page
        [array addObject:topPage];
        
        // load other pages if exists
        for (NSInteger i=1; i<=count; i++) {
            // load page at index
            UIView* page = [self loadPageAtIndex:topPageIndex-i];
            // if page exist, add page to array
            if (page) {
                [array addObject: page];
            }
        }
        
        // return array of pages
        return array;
    }
    
    // if top page don't exist, return nil
    return nil;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isLastPage:(UIView*)page {
    return ([_pages indexOfObject: page] == [_pages count] - 1);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isFirstPage:(UIView*)page {
    return ([_pages indexOfObject: page] == 0);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) refreshPageHeight:(UIView*)page {
    CGFloat height = self.bounds.size.height;
    CGRect frame = page.frame;
    
    if (frame.size.height != height) {
        frame.size.height = height;
        [page setFrame: frame];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) topRightVisiblePage {
    
    NSEnumerator* enumerator = [_pages reverseObjectEnumerator];
    NSInteger index = [_pages count] - 1;
    id item;
    
    while ((item = [enumerator nextObject])) {
        
        // find first loaded view
        if (item != [NSNull null]) {
            UIView* page = (UIView*)item;

            // if page intersect with content
            if (page.frame.origin.x < self.bounds.size.width) {
            
                // if view don't stick right band
                if (page.frame.origin.x + page.frame.size.width < self.bounds.size.width) {
                    // load previous page if neede and if can
                    UIView* nextPage = [self loadPageAtIndex: index + 1];
                    // if prev page exist, that page is top page
                    if (nextPage != nil) {
                        CGRect frame = CGRectMake(page.frame.origin.x + page.frame.size.width, 0.0, _pageWidth, self.bounds.size.height);
                        [nextPage setFrame: frame];
                        return nextPage;
                    }
                }
                // else, page is top page
                return page;
            }
        }
        
        // dec index
        index--;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) topLeftVisiblePage {
    // get all visible pages, starting from top right view
    NSArray* visiblePages = [self visiblePages];
    
    // if has any views
    if ([visiblePages count] > 0) {
        // last view in array is top left visible view
        return [visiblePages lastObject];
    }
    
    return nil;
}


#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushPage:(UIView*)newPage fromPage:(UIView*)fromPage animated:(BOOL)animated {
    
    CGRect newPageFrame = CGRectMake(0.0, 0.0, _pageWidth, self.bounds.size.height);
    CGRect fromPageFrame = CGRectMake(0.0, 0.0, _pageWidth, self.bounds.size.height);
    
    if (fromPage == nil) {
        [self popAllPagesAnimated: animated];
    } else {
        NSUInteger index = [_pages indexOfObject: fromPage];
        NSAssert(index != NSNotFound, @"fromView == NSNotFound");
        newPageFrame = fromPage.frame;
        newPageFrame.origin.x = fromPageFrame.origin.x + fromPageFrame.size.width;
    }
    
    // if not animated then just set frame
    if (!animated) {
        [newPage setFrame: newPageFrame];
        [fromPage setFrame:fromPageFrame];
        
    } else { // set animaton
        [newPage setAlpha: 0.0];
        
        CGRect newPageAnimationFrame = newPageFrame;
        newPageAnimationFrame.origin.x += 150.0;
        [newPage setFrame: newPageAnimationFrame];
        
        [UIView animateWithDuration:0.3 animations:^ {
            [newPage setFrame: newPageFrame];
            [newPage setAlpha:1.0];
            
            [fromPage setFrame:fromPageFrame];
        }];
    }
    // add page to array of pages
    [_pages addObject: newPage];
    // send message to delegate
    [self didAddPage:newPage animated:animated];
    
    // get new page index, (is last)
    NSUInteger index = [_pages count]-1;
    //send message to delegate
    [self pageWillAppearAtIndex:index animated:animated];
    // add subview
    [self addSubview: newPage];
    //send message to delegate
    [self pageDidAppearAtIndex: index animated:animated];
    
    
    _actualRightPageIndex = [_pages count] - 1;
    _actualLeftPageIndex = (_actualRightPageIndex == 0) ? NSNotFound : _actualRightPageIndex - 1;     
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) loadPageAtIndex:(NSInteger)index {
    // check if index exist
    if ((index >= 0) && (index <= [_pages count]-1)) {
        id item = [_pages objectAtIndex:index];

        // if item at index is null
        if (item == [NSNull null]) {
            // get page from dataSource
            UIView* view = [_dataSource cascadeView:self pageAtIndex:index];

            // if got view from dataSorce
            if (view != nil) {
                //preventive, set frame
                CGRect pageFrame = CGRectMake(0.0, 0.0, _pageWidth, self.bounds.size.height);
                [view setFrame: pageFrame];
                
                // replace in array of pages
                [_pages replaceObjectAtIndex:index withObject:view];
                
                // add subview
                [self insertSubview:view atIndex:index];
                
                // send delegate
                [self didLoadPage:view];
                
                return view;
            }
        }
        
        return item;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unloadPageIfNeeded:(NSInteger)index {

    // get page at index
    id item = [_pages objectAtIndex: index];
    
    // if page is unloaded, do nothing
    if (item == [NSNull null]) return;
    
    // load all visible pages
    NSArray* visiblePages = [self visiblePages];
    BOOL pageIsVisible = NO;
    
    // check if page contain in array of visible pages
    for (UIView* page in visiblePages) {
        NSUInteger pageIndex = [_pages indexOfObject: page];
        if (pageIndex != NSNotFound) {
            pageIsVisible = YES; break;
        }
    }
    
    // if page don't contain in array of visible pages, then unloadPage
    if (!pageIsVisible) {
        [self unloadPage: item];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popPageAtIndex:(NSInteger)index animated:(BOOL)animated {

    // get item at index
    id item = [_pages objectAtIndex:index];
    
    // remove page from array of pages
    [_pages removeObjectAtIndex: index];

    if (item != [NSNull null]) {
    
        // get index of page in array of subviews
        NSUInteger viewIndex = [self.subviews indexOfObject: item];
        if (viewIndex != NSNotFound) {
        
            // remove view from superview
            [[self.subviews objectAtIndex: viewIndex] removeFromSuperview];
        }
    }
    
    // send delegate message
    [self didPopPageAtIndex: index];

}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popAllPagesAnimated:(BOOL)animated {
    
    id item;
    NSUInteger index = [_pages count] - 1;
    // pop page from back
    NSEnumerator* enumerator = [_pages reverseObjectEnumerator];

    while ((item = [enumerator nextObject])) {
        // pop page at index
        [self popPageAtIndex:index animated:animated];
        index--;
    }    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unloadInvisiblePages {

    BOOL canUnload = YES;

    // temp array with pages to unload
    NSMutableArray* pagesToUnload = [[NSMutableArray alloc] init];
    
    // get array of visible pages
    NSArray* visiblePages = [self visiblePages];

    // if visible page exist in array of pages then can't ubload
    for (id item in _pages) {
        
        for (UIView* visiblePage in visiblePages) {
        
            if (item == visiblePage) {
                canUnload = NO; break;
            }
        }
        
        // if can, add to array - pages to unlaod
        if (canUnload) {
            [pagesToUnload addObject: item];
        } 
        
        // set flag to YES
        canUnload = YES;
    }

    // unload pages
    for (UIView* view in pagesToUnload) {
        [self unloadPage: view];
    }
    
    [pagesToUnload release];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unloadPage:(UIView*)page {

    // get index of page
    NSUInteger index = [_pages indexOfObject: page];

    // if page exist
    if (index != NSNotFound) {
        // replace with null
        [_pages replaceObjectAtIndex:index withObject:[NSNull null]];
        
        // remove from superview
        [page removeFromSuperview];

        // send message to delegate
        [self didUnloadPage:page];

    }    
}


#pragma mark Delegate methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didLoadPage:(UIView*)page {
    // add pan gesture recognizer to new view
    [self addPanGestureRecognizer: page];

    if ([_delegate respondsToSelector:@selector(cascadeView:didLoadPage:)]) {
        [_delegate cascadeView:self didLoadPage:page];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didAddPage:(UIView*)page animated:(BOOL)animated {
    // add pan gesture recognizer to new view
    [self addPanGestureRecognizer: page];

    if ([_delegate respondsToSelector:@selector(cascadeView:didAddPage:animated:)]) {
        [_delegate cascadeView:self didAddPage:page animated:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didPopPageAtIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(cascadeView:didPopPageAtIndex:)]) {
        [_delegate cascadeView:self didPopPageAtIndex:index];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didUnloadPage:(UIView*)page {
    if ([_delegate respondsToSelector:@selector(cascadeView:didUnloadPage:)]) {
        [_delegate cascadeView:self didUnloadPage:page];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageWillAppearAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(cascadeView:pageWillAppearAtIndex:animated:)]) {
        [_delegate cascadeView:self pageWillAppearAtIndex:index animated:animated];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidAppearAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(cascadeView:pageDidAppearAtIndex:animated:)]) {
        [_delegate cascadeView:self pageDidAppearAtIndex:index animated:animated];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageWillDisappearAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(cascadeView:pageWillDisappearAtIndex:animated:)]) {
        [_delegate cascadeView:self pageWillDisappearAtIndex:index animated:animated];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidDisappearAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([_delegate respondsToSelector:@selector(cascadeView:pageDidDisappearAtIndex:animated:)]) {
        [_delegate cascadeView:self pageDidDisappearAtIndex:index animated:animated];
    }
}


#pragma mark Getters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) dragging {
    return _cascadeViewFlags.dragging;   
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) decelerating {
    return _cascadeViewFlags.decelerating;   
}

@end
