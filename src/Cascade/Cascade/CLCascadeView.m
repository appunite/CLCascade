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
- (void) sendDelegateMessageToHidingPages:(NSArray*)pages;
- (void) sendDelegateMessageToShowUpPages:(NSArray*)pages;
- (void)orderViews:(BOOL)animated;
- (UIView*)pageOnLeftFromView:(UIView*)view;
- (UIView*)pageOnRightFromView:(UIView*)view;
@end

@interface CLCascadeView (DelegateMethods)
- (void) didLoadPage:(UIView*)page;
- (void) didAddPage:(UIView*)page animated:(BOOL)animated;
- (void) didPopPageAtIndex:(NSInteger)index;
- (void) didUnloadPage:(UIView*)page;
- (void) pageDidAppearAtIndex:(NSInteger)index;
- (void) pageDidDisappearAtIndex:(NSInteger)index;
@end

#define DEFAULT_PAGE_WIDTH 479.0f
#define DEFAULT_OFFSET 66.0f
#define OVERLOAD 0.0f

@implementation CLCascadeView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize dragging = _dragging;
@synthesize decelerating = _decelerating;
@synthesize pageWidth = _pageWidth;
@synthesize offset = _offset;

#pragma mark Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _dataSource = nil;
    _delegate = nil;
    [_visiblePages release], _visiblePages = nil;
    [_pages release], _pages = nil;

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

    for (UIView* view in _visiblePages) {
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
    _visiblePages = [[NSMutableArray alloc] init];
    
    [self setAutoresizingMask:
     UIViewAutoresizingFlexibleLeftMargin | 
     UIViewAutoresizingFlexibleRightMargin | 
     UIViewAutoresizingFlexibleBottomMargin | 
     UIViewAutoresizingFlexibleTopMargin | 
     UIViewAutoresizingFlexibleWidth | 
     UIViewAutoresizingFlexibleHeight];

    _offset = DEFAULT_OFFSET;
    _pageWidth = (1024.0 - _offset) / 2.0;
    
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
            
            [self orderViews: YES];
            
            // reset points
            _startTouchPoint = CGPointZero;
            _newTouchPoint = CGPointZero;
            _lastTouchPoint = CGPointZero;
            // resete flags
            _direction = CLDraggingDirectionUnknow;
            _cascadeViewFlags.dragging = NO;
            _cascadeViewFlags.decelerating = YES;
            
            break;
        default:
            break;
    }
    
}

- (void) orderViews:(BOOL)animated {

    if (_direction == CLDraggingDirectionUnknow) {
        _direction = CLDraggingDirectionLeft;
    }
    
    UIView* topView = [self topRightVisiblePage];
    UIView* leftView = [self pageOnLeftFromView: topView];
    
    if (_direction == CLDraggingDirectionLeft) { //get new one on right
       
        if (topView.frame.origin.x + topView.frame.size.width < self.frame.size.width) {
            
            // cofnij
            CGRect topRect = topView.frame;
            topRect.origin.x += (self.frame.size.width - topView.frame.origin.x - _pageWidth);

            if ([_pages count] == 1) {
                topRect.origin.x = 289.0f;
            }
            
            
            [UIView animateWithDuration:0.8 delay:0.0 
                                options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionOverrideInheritedCurve
                             animations:^ {
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            // idz dalj i pociagnij nowa po prawej
            CGRect leftRect = leftView.frame;
            leftRect.origin.x = _offset;
            
            [UIView animateWithDuration:0.5 delay:0.01 
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 leftView.frame = leftRect;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            CGRect topRect = topView.frame;
            topRect.origin.x = leftRect.origin.x + leftRect.size.width;
            
            [UIView animateWithDuration:0.5 delay:0.0 
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
                                 [self visiblePages];
                             }];
            
        }
    } 

    if (_direction == CLDraggingDirectionRight) { //get new one on left
        if (([self isFirstPage: topView]) && ([_pages count] == 1)) {
            CGRect topRect = topView.frame;
            topRect.origin.x = self.frame.size.width - _pageWidth;
            
            if ([_pages count] == 1) {
                topRect.origin.x = 289.0f;
            }

            [UIView animateWithDuration:0.5 delay:0.0 
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            
            CGRect topRect = topView.frame;
            topRect.origin.x = self.frame.size.width;
            
            
            if ([self isFirstPage:topView]) {

                UIView* rightView = [self pageOnRightFromView: topView];
                
                if (rightView) {
                    leftView = topView;
                    topView = rightView;
                }
                
                topRect.origin.x = 289.0f + _pageWidth;
            }

            if ([self isFirstPage:leftView]) {
                topRect.origin.x = 289.0f + _pageWidth;
            }
            
            [UIView animateWithDuration:0.5 delay:0.0
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            CGRect leftRect = leftView.frame;
            leftRect.origin.x = topRect.origin.x - _pageWidth;
            
            [UIView animateWithDuration:0.5 delay:0.0
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 leftView.frame = leftRect;
                             }
                             completion:^(BOOL finished) {
                                 [self visiblePages];
                             }];
            
        }
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
        _direction = CLDraggingDirectionUnknow;
    } else {
        _direction = (dx > 0) ? CLDraggingDirectionLeft : CLDraggingDirectionRight;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateLocationOfPages:(CGFloat)transition {

    if (_direction == CLDraggingDirectionUnknow) return;

    NSArray* array = [self visiblePages];

    NSInteger newOriginX = 0;
    CGRect lastFrame = CGRectNull;
    NSEnumerator* enumerator;
    UIView* view;    

    if (_direction == CLDraggingDirectionLeft) {
        enumerator = [array reverseObjectEnumerator];
    }
    if (_direction == CLDraggingDirectionRight) {
        enumerator = [array objectEnumerator];
    }
    
    while ((view = [enumerator nextObject])) {
        
        if (_direction == CLDraggingDirectionLeft) { //get new one on right
            if (!(view.frame.origin.x <= _offset)) {
                CGRect newFrame = view.frame;
                
                if (CGRectEqualToRect(lastFrame, CGRectNull)) {
                    newOriginX = newFrame.origin.x - transition;
                } else {
                    newOriginX = lastFrame.origin.x + lastFrame.size.width;
                }
                
                newFrame.origin.x = MAX(_offset, newOriginX);
                [view setFrame: newFrame];
                lastFrame = newFrame;
            }
        }        
        
        if (_direction == CLDraggingDirectionRight) { //get new one on left
            CGRect newFrame = view.frame;
            
            if (!CGRectIntersectsRect(lastFrame, view.frame) || [self isLastPage:view]) {
                newOriginX = newFrame.origin.x - transition;
                newFrame.origin.x = MAX(_offset, newOriginX);
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
        NSInteger count = ceil( (topPage.frame.origin.x - _offset) / _pageWidth );
        
        // create array
        NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];

        // add top right visible page
        [array addObject:topPage];

        // get index of topPage in array of subviews
        NSInteger subviewIndex = [self.subviews indexOfObject:topPage] - 1;
        
        // load other pages if exists
        for (NSInteger i=1; i<=count; i++) {
            // page index
            NSInteger index = topPageIndex-i;
            // load page at index
            UIView* page = [self loadPageAtIndex:index];
            // if page exist, add page to array
            if (page) {
                // if the array of subviews don't reflect 
                // the array of pages, send subview to back
                if  (index > subviewIndex) {
                    // set proper index of view
                    [self sendSubviewToBack: page];
                }
                // add page to array of visible pages
                [array addObject: page];
            }
            subviewIndex--;
        }
        // if there is no any changes return _visiblePages
        if ([_visiblePages isEqualToArray: array]) {
            return _visiblePages;
        }
        
        // send delegate message to pages that will appear or disappear
        [self sendDelegateMessageToHidingPages: array];
        [self sendDelegateMessageToShowUpPages: array];
        
        // if there are changes remove array and add visible pages to array
        [_visiblePages removeAllObjects];
        [_visiblePages addObjectsFromArray: array];
        
        // return array of pages
        return _visiblePages;
    }
    
    // there is no visible pages
    [_visiblePages removeAllObjects];
    // if top page don't exist, return nil
    return _visiblePages;
    
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) sendDelegateMessageToHidingPages:(NSArray*)pages {
    BOOL exisnt = NO;
    // array of last visible pages
    for (UIView* viewA in _visiblePages) {
        
        // array of current visible pages
        for (UIView* viewB in pages) {
            if ([viewA isEqual: viewB]) {
                exisnt = YES; break;
            }
        }
        
        if (!exisnt) {
            NSInteger index = [_pages indexOfObject: viewA];
            [self pageDidDisappearAtIndex:index];
        }
        
        exisnt = NO;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) sendDelegateMessageToShowUpPages:(NSArray*)pages {
    BOOL exisnt = NO;
    // array of current visible pages
    for (UIView* viewB in pages) {
        
        // array of last visible pages
        for (UIView* viewA in _visiblePages) {
            if ([viewA isEqual: viewB]) {
                exisnt = YES; break;
            }
        }
        
        if (!exisnt) {
            NSInteger index = [_pages indexOfObject: viewB];
            [self pageDidAppearAtIndex:index];
        }
        
        exisnt = NO;
    }    
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
                    if (nextPage) {
                        // set new frame, next to the right edge of previos page
                        CGRect frame = CGRectMake(page.frame.origin.x + page.frame.size.width, 0.0, _pageWidth, self.bounds.size.height);
                        [nextPage setFrame: frame];
                        //
                        [self bringSubviewToFront:nextPage];
                        //retunr next page
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
- (UIView*)pageOnLeftFromView:(UIView*)view {

    NSUInteger index = [_pages indexOfObject: view];
    
    if (index >= 1) {
        index--;
        id obj = [_pages objectAtIndex: index];

        if (obj == [NSNull null]) {
            obj = [self loadPageAtIndex: index];
        }

        return obj;
    }
    
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)pageOnRightFromView:(UIView*)view {

    NSUInteger index = [_pages indexOfObject: view];
    
    if ([_pages count] > index + 1) {
        index++;

        id obj = [_pages objectAtIndex: index];
        
        if (obj == [NSNull null]) {
            obj = [self loadPageAtIndex: index];
        }
        
        return obj;
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
    
    [self visiblePages];
    
    CGRect newPageFrame = CGRectMake(289.0f, 0.0, _pageWidth, self.bounds.size.height);
    CGRect fromPageFrame = CGRectMake(_offset, 0.0, _pageWidth, self.bounds.size.height);
    
    if (fromPage == nil) {
        [self popAllPagesAnimated: animated];
    } else {
        NSAssert([_pages indexOfObject: fromPage] != NSNotFound, @"fromView == NSNotFound");
        newPageFrame = fromPage.frame;
        newPageFrame.origin.x = fromPageFrame.origin.x + fromPageFrame.size.width;
    }

    // if not animated then just set frame
    if (!animated) {
        [newPage setFrame: newPageFrame];
        [fromPage setFrame:fromPageFrame];
        
    } else { // set animaton
        [newPage setAlpha: 0.7];
        
        CGRect newPageAnimationFrame = newPageFrame;
        newPageAnimationFrame.origin.x = self.frame.size.width;
        [newPage setFrame: newPageAnimationFrame];
        
        [UIView animateWithDuration:0.4 delay:(fromPage == nil) ? 0.15 : 0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^ {
                             
                             [newPage setFrame: newPageFrame];
                             [newPage setAlpha:1.0];
                             
                         } 
                         completion: ^(BOOL finished) {
                             [self visiblePages];
                         }
        ];

        [UIView animateWithDuration:0.4 delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^ {
                             
                             [fromPage setFrame:fromPageFrame];
                             
                         } 
                         completion: ^(BOOL finished) {
                             [self visiblePages];
                         }
        ];
    }
    // add page to array of pages
    [_pages addObject: newPage];
    // add subview
    [self addSubview: newPage];
    // send message to delegate
    [self didAddPage:newPage animated:animated];
    
    if (!animated) {
        [self visiblePages];
    }
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
                CGRect pageFrame = CGRectMake(_offset, 0.0, _pageWidth, self.bounds.size.height);
                [view setFrame: pageFrame];
                // replace in array of pages
                [_pages replaceObjectAtIndex:index withObject:view];
                // add subview
                [self addSubview: view];
                // send delegate
                [self didLoadPage:view];
                // return loaded page
                return view;
            }
        }
        // return page from array
        return item;
    }
    // nil, index out of range
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
        
        if (item != [NSNull null]) {

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
- (void) pageDidAppearAtIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(cascadeView:pageDidAppearAtIndex:)]) {
        [_delegate cascadeView:self pageDidAppearAtIndex:index];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidDisappearAtIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(cascadeView:pageDidDisappearAtIndex:)]) {
        [_delegate cascadeView:self pageDidDisappearAtIndex:index];
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
