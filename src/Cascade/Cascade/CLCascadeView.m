//
//  CLCascadeView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeView.h"
#import "CLCascadeEnums.h"

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
	
	// this is necessary because layoutSubviews is called on rotation changes.
	[self visiblePages];
	
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

// This gets called after a gesture dragging motion ended
- (void) orderViews:(BOOL)animated {

    if (_direction == CLDraggingDirectionUnknow) {
        _direction = CLDraggingDirectionLeft;
    }
    
    UIView* topView = [self topRightVisiblePage];
    UIView* leftView = [self pageOnLeftFromView: topView];
    
	CGFloat height = CGRectGetHeight(self.bounds);

	//dragging a view to the left, get the new one on right
    if (_direction == CLDraggingDirectionLeft) { 
       
		// If the top right view fits entirely within our overall cascade view width
        if (topView.frame.origin.x + topView.frame.size.width < self.frame.size.width) {
            
            // cofnij
            CGRect topRect = topView.frame;
			topRect.size.height = height;

            if ([_pages count] == 1) {
                topRect.origin.x = CATEGORIES_VIEW_WIDTH;
            } else {
				topRect.origin.x += (self.frame.size.width - topView.frame.origin.x - CGRectGetWidth(topRect));
			}
			
            [UIView animateWithDuration:0.8 delay:0.0 
                                options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionOverrideInheritedCurve
                             animations:^ {
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
								 [self layoutSubviews];
                             }];
        } else { 
			// the top right view doesn't fit within our cascade view frame
			
            // idz dalj i pociagnij nowa po prawej
            CGRect leftRect = leftView.frame;
            leftRect.origin.x = _offset;
			leftRect.size.height = height;
                        
            CGRect topRect = topView.frame;
			topRect.size.height = height;
			
			// snap it to the right edge boundary of the LEFT view.
            topRect.origin.x = leftRect.origin.x + leftRect.size.width;
            
            [UIView animateWithDuration:0.5 delay:0.0 
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 leftView.frame = leftRect;
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
								 [self layoutSubviews];
                             }];
            
        }
    } 

	// we have dragged the view to the right, exposing the view underneath
    if (_direction == CLDraggingDirectionRight) { 
        if (([self isFirstPage: topView]) && ([_pages count] == 1)) {
            CGRect topRect = topView.frame;
			topRect.origin.x = CATEGORIES_VIEW_WIDTH;
			topRect.size.height = height;
			
            [UIView animateWithDuration:0.5 delay:0.0 
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
								 [self layoutSubviews];
                             }];
        } else {
			// if we're dragging "open" a view that's early in the stack, lets adjust our math to shift the views that come later on
            
            if ([self isFirstPage:topView]) {

                UIView* rightView = [self pageOnRightFromView: topView];
                
                if (rightView) {
                    leftView = topView;
                    topView = rightView;
                }
			}
			
			CGRect leftRect = leftView.frame;
			leftRect.size.height = height;
			
			CGRect topRect = topView.frame;
            topRect.origin.x = self.frame.size.width;	
			topRect.size.height = height;
			
			NSAssert(leftView, @"Left View is nil!");
			
			if ([self isFirstPage:leftView]) {
				leftRect.origin.x = CATEGORIES_VIEW_WIDTH;
            }
			else {
				// there's more views to the left of the left view
				UIView *veryLeft = [self pageOnLeftFromView:leftView];
				if (veryLeft) {
					leftRect.origin.x = veryLeft.frame.origin.x + CGRectGetWidth(veryLeft.frame);
					[self refreshPageHeight:veryLeft];
				}
				//leftRect.origin.x = topRect.origin.x - _pageWidth; // the old way of doing it
			}
			
			
			if (topView) {
				// We're fully exposing the "left" view, so move the "top" view to the edge of the "left" view boundary
				topRect.origin.x = leftRect.origin.x + CGRectGetWidth(leftView.frame);
				//topRect.origin.x = CATEGORIES_VIEW_WIDTH + _pageWidth; // the old way of doing it
			}
            
            
            [UIView animateWithDuration:0.5 delay:0.0
                                options:UIViewAnimationCurveEaseOut
                             animations:^ {
                                 leftView.frame = leftRect;
                                 topView.frame = topRect;
                             }
                             completion:^(BOOL finished) {
								 [self layoutSubviews];
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

// this gets called *during* the dragging motion
- (void) updateLocationOfPages:(CGFloat)transition {
    if (_direction == CLDraggingDirectionUnknow) return;
	
	//#warning GREG
	// *really* ??? we recalculate this array *while* animating????
    //NSArray* array = [self visiblePages];
	
	NSArray* array = _visiblePages;
	
    NSInteger newOriginX = 0;
    CGRect lastFrame = CGRectNull;
    NSEnumerator* enumerator;
    UIView* view = nil;    
	
    if (_direction == CLDraggingDirectionLeft) {
        enumerator = [array reverseObjectEnumerator];
    }
    if (_direction == CLDraggingDirectionRight) {
        enumerator = [array objectEnumerator];
    }
    
	CGFloat height = CGRectGetHeight(self.bounds);

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
				newFrame.size.height = height;
				
                [view setFrame: newFrame];
                lastFrame = newFrame;
            }
        }        
        
        if (_direction == CLDraggingDirectionRight) { //get new one on left
            CGRect newFrame = view.frame;
			newFrame.size.height = height;

            if (!CGRectIntersectsRect(lastFrame, view.frame) || [self isLastPage:view]) {
                newOriginX = newFrame.origin.x - transition;
                newFrame.origin.x = MAX(_offset, newOriginX);
            }
			[view setFrame: newFrame];
            
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

        // calculate the number of existing pages that can be visible at this time
        //NSInteger count = ceil( (topPage.frame.origin.x - _offset) / _pageWidth );	// the old way
				
		NSInteger count = 1; // we want at least one to show (the top page)
		
		BOOL landscape = CGRectGetWidth(self.bounds) > 800;
		if (landscape && [_pages count] > 1)
			count = 2;
		else
			count = 1;
		
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
			[self refreshPageHeight:viewB];
			
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
    CGFloat height = CGRectGetHeight(self.bounds);
    CGRect newFrame = page.frame;
    
    if (newFrame.size.height != height) {
        newFrame.size.height = height;
        [page setFrame: newFrame];
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
			
            // if page intersects with content
            if (page.frame.origin.x < CGRectGetWidth(self.bounds)) {
				
                // if view don't stick right band
                if ((page.frame.origin.x + CGRectGetWidth(page.frame)) < CGRectGetWidth(self.bounds)) {
					
                    // load previous page if needed and if we can
                    UIView* nextPage = [self loadPageAtIndex: index + 1];
					
                    // if prev page exist, that page is top page
                    if (nextPage) {
                        CGRect nextFrame = CGRectMake(page.frame.origin.x + CGRectGetWidth(page.frame), 0.0, _pageWidth, CGRectGetHeight(self.bounds));
						if (NO == CGRectIsEmpty(nextPage.frame)) {
							nextFrame.size.width = CGRectGetWidth(nextPage.frame);
						}
                        // set new frame, next to the right edge of previous page
                        [nextPage setFrame: nextFrame];
                        //
                        [self bringSubviewToFront:nextPage];

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
	
	CGFloat height = CGRectGetHeight(self.bounds);
		
    CGRect fromPageFrame = CGRectMake(_offset, 0.0, _pageWidth, height);
	
	if (fromPage && NO == CGRectIsEmpty(fromPage.frame)) {
		fromPageFrame.size.width = CGRectGetWidth(fromPage.frame);
	}
	
	CGRect newPageFrame = CGRectMake(CATEGORIES_VIEW_WIDTH, 0.0, _pageWidth, height);
	
	if (newPage && NO == CGRectIsEmpty(newPage.frame)) {
		newPageFrame.size.width = CGRectGetWidth(newPage.frame);
	}
	
	
    if (fromPage == nil) {
        [self popAllPagesAnimated: animated];
    } else {
        NSAssert([_pages indexOfObject: fromPage] != NSNotFound, @"fromView == NSNotFound");
		
		CGFloat maxX = CGRectGetWidth(self.frame);
		CGFloat fromWidthX = fromPageFrame.origin.x + CGRectGetWidth(fromPageFrame);
		
		// if we have room for both views in this orientation ...
		if ((fromWidthX + CGRectGetWidth(newPageFrame)) < maxX) {
			newPageFrame.origin.x = fromPageFrame.origin.x + CGRectGetWidth(fromPageFrame);
		} else {
			// if we don't have room for both
			newPageFrame.origin.x = fromPageFrame.origin.x + _offset;
		}
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
                             [self layoutSubviews];
                         }
		 ];
		
        [UIView animateWithDuration:0.4 delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^ {
							 
                             [fromPage setFrame:fromPageFrame];
							 
                         } 
                         completion: ^(BOOL finished) {
                             [self layoutSubviews];
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
                CGRect pageFrame = CGRectMake(_offset, 0.0, _pageWidth, CGRectGetHeight(self.bounds));
				if (NO == CGRectIsEmpty(view.frame)) {
					pageFrame.size.width = view.frame.size.width;
				}
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
    
    NSUInteger index = [_pages count] - 1;
    // pop page from back
    NSEnumerator* enumerator = [_pages reverseObjectEnumerator];

    while ([enumerator nextObject]) {
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) isOnStack:(UIView*)view {
    return (view.frame.origin.x <= _offset);
}

#pragma mark Delegate methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didLoadPage:(UIView*)page {
    // add pan gesture recognizer to new view
    [self addPanGestureRecognizer: page];

    if (_delegate && [_delegate respondsToSelector:@selector(cascadeView:didLoadPage:)]) {
        [_delegate cascadeView:self didLoadPage:page];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didAddPage:(UIView*)page animated:(BOOL)animated {
    // add pan gesture recognizer to new view
    [self addPanGestureRecognizer: page];

    if (_delegate && [_delegate respondsToSelector:@selector(cascadeView:didAddPage:animated:)]) {
        [_delegate cascadeView:self didAddPage:page animated:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didPopPageAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(cascadeView:didPopPageAtIndex:)]) {
        [_delegate cascadeView:self didPopPageAtIndex:index];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didUnloadPage:(UIView*)page {
    if (_delegate && [_delegate respondsToSelector:@selector(cascadeView:didUnloadPage:)]) {
        [_delegate cascadeView:self didUnloadPage:page];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidAppearAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(cascadeView:pageDidAppearAtIndex:)]) {
        [_delegate cascadeView:self pageDidAppearAtIndex:index];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pageDidDisappearAtIndex:(NSInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(cascadeView:pageDidDisappearAtIndex:)]) {
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
