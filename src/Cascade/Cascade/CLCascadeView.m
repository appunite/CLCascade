//
//  CLCascadeView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLCascadeView.h"
#import "CLSegmentedView.h"

@interface CLCascadeView (Private)
- (NSArray*) visiblePages;
- (NSArray*) pagesOnStock;

- (UIView*) previousPage:(UIView*)page;
- (UIView*) nextPage:(UIView*)page;
- (UIView*) firstPageOnStock;

- (BOOL) pageExistAtIndex:(NSInteger)index;
- (void) unloadInvisiblePagesOnStock;

- (CGFloat) calculatePageWidth:(UIView*)view;
- (CGSize) calculateContentSize:(UIInterfaceOrientation)interfaceOrientation;
- (UIEdgeInsets) calculateEdgeInset:(UIInterfaceOrientation)interfaceOrientation;
- (void) setProperContentSize;
- (void) setProperContentSize:(UIInterfaceOrientation)interfaceOrientation;
- (void) setProperEdgeInset:(BOOL)animated;
- (void) setProperEdgeInset:(BOOL)animated forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void) setPageHeightForLodedPages:(UIInterfaceOrientation)interfaceOrientation;

- (void) unloadPage:(UIView*)page remove:(BOOL)remove;

- (NSInteger) indexOfFirstVisiblePage;
@end

@interface CLCascadeView (DelegateMethods)
- (void) didLoadPage:(UIView*)page;
- (void) didAddPage:(UIView*)page animated:(BOOL)animated;
- (void) didPopPageAtIndex:(NSInteger)index;
- (void) didUnloadPage:(UIView*)page;
- (void) pageDidAppearAtIndex:(NSInteger)index;
- (void) pageDidDisappearAtIndex:(NSInteger)index;
- (void) didStartPullingToDetachPages;
- (void) didPullToDetachPages;
- (void) didCancelPullToDetachPages;
@end

#define DEFAULT_LEFT_INSET 58.0f
#define PULL_TO_DETACH_FACTOR 0.20f
#define OVERLOAD 0.0f

@implementation CLCascadeView

@synthesize leftInset = _leftInset; 
@synthesize pageWidth = _pageWidth;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize widerPageWidth = _widerPageWidth;
@synthesize pullToDetachPages = _pullToDetachPages;

#pragma mark -
#pragma mark Init & dealloc

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    _delegate = nil;
    _dataSource = nil;    
    [_scrollView release], _scrollView = nil;
    [_pages release], _pages = nil;
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pages = [[NSMutableArray alloc] init];

        self.leftInset = DEFAULT_LEFT_INSET;
        self.pullToDetachPages = YES;
        
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate: self];
        [_scrollView setDecelerationRate: UIScrollViewDecelerationRateFast];
        [_scrollView setScrollsToTop: NO];
        [_scrollView setBounces: YES];
        [_scrollView setPagingEnabled: YES];
        [_scrollView setClipsToBounds: NO];
        [_scrollView setAlwaysBounceVertical: NO];
        [_scrollView setAlwaysBounceHorizontal: YES];
        [_scrollView setDirectionalLockEnabled: NO];
        
        [_scrollView setDelaysContentTouches:NO];
        [_scrollView setMultipleTouchEnabled:NO];
        //        [_scrollView setShowsVerticalScrollIndicator: NO];
        //        [_scrollView setShowsHorizontalScrollIndicator: NO];
          [_scrollView setBackgroundColor:[UIColor redColor]];
        
        [_scrollView setAutoresizingMask:
         //         UIViewAutoresizingFlexibleLeftMargin | 
         //         UIViewAutoresizingFlexibleRightMargin | 
         UIViewAutoresizingFlexibleBottomMargin | 
         UIViewAutoresizingFlexibleTopMargin | 
         UIViewAutoresizingFlexibleHeight];
        //         UIViewAutoresizingFlexibleWidth];
        [self addSubview: _scrollView];
        
        
        [self setAutoresizingMask:
         UIViewAutoresizingFlexibleLeftMargin | 
         UIViewAutoresizingFlexibleRightMargin | 
         UIViewAutoresizingFlexibleBottomMargin | 
         UIViewAutoresizingFlexibleTopMargin | 
         UIViewAutoresizingFlexibleWidth | 
         UIViewAutoresizingFlexibleHeight];
        
        _flags.willDetachPages = NO;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (id item in _pages) {
        
        if (item != [NSNull null]) {
            
            UIView* page = (UIView*)item;
            CGRect rect = [_scrollView convertRect:page.frame toView:self];
            
            if (CGRectContainsPoint(rect, point)) {
                CGPoint newPoint = [self convertPoint:point toView:page];
                return [page hitTest:newPoint withEvent:event];
            }
        }
    }
    
    return [super hitTest:point withEvent:event];
}

#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pushPage:(UIView*)newPage fromPage:(UIView*)fromPage animated:(BOOL)animated {
    
    CGRect newPageFrame = CGRectMake(CGRectGetMaxX(fromPage.frame), 0.0f, fromPage.frame.size.width, fromPage.frame.size.height);
    
    if (fromPage == nil) {
        [self popAllPagesAnimated: animated];
        newPageFrame = CGRectMake(0.0f, 0.0f, _pageWidth, _scrollView.frame.size.height);
    }
    
    // set new page frame
    [newPage setFrame: newPageFrame];
    // add page to array of pages
    [_pages addObject: newPage];
    // update content size
    [self setProperContentSize];
    // update edge inset
    [self setProperEdgeInset: NO];
    // add subview
    [_scrollView addSubview: newPage];
    // send message to delegate
    [self didAddPage:newPage animated:animated];
    // scroll to new page frame
    //[_scrollView setContentOffset:CGPointMake(CGRectGetMaxX(fromPage.frame) - _scrollView.contentInset.left, 0.0f) animated:animated];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popPageAtIndex:(NSInteger)index animated:(BOOL)animated {
    // get item at index
    __block id item = [_pages objectAtIndex:index];
    
    // check if page is unloaded
    if (item != [NSNull null]) {
        
        if (animated) {
            // animate pop
            [UIView animateWithDuration:0.4f 
                             animations:^ {
                                 [item setAlpha: 0.0f];
                             }
                             completion:^(BOOL finished) {
                                 // unload page
                                 [self unloadPage:item];
                                 // remove page from array
                                 [_pages removeObjectAtIndex: index];
                                 // update content size
                                 [self setProperContentSize];
                                 // update edge inset
                                 [self setProperEdgeInset: NO];
                                 // send delegate message
                                 [self didPopPageAtIndex: index];
                             }];
            
        } else {
            // unload and remove page
            [self unloadPage:item remove:YES];
            // update content size
            [self setProperContentSize];
            // update edge inset
            [self setProperEdgeInset: NO];
            // send delegate message
            [self didPopPageAtIndex: index];
        }
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) popAllPagesAnimated:(BOOL)animated {
    id item = nil;
    // index of last page
    NSUInteger index = [_pages count] - 1;
    // pop page from back
    NSEnumerator* enumerator = [_pages reverseObjectEnumerator];
    // enumarate pages
    while ((item = [enumerator nextObject])) {
        // pop page at index
        [self popPageAtIndex:index animated:NO];
        index--;
    }    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) loadPageAtIndex:(NSInteger)index {
    // check if index exist
    if ([self pageExistAtIndex: index]) {
        id item = [_pages objectAtIndex:index];
        
        // if item at index is null
        if (item == [NSNull null]) {
            // get page from dataSource
            UIView* view = [_dataSource cascadeView:self pageAtIndex:index];
            
            // if got view from dataSorce
            if (view != nil) {
                //preventive, set frame
                CGRect pageFrame = CGRectMake(index * _pageWidth, 0.0f, _pageWidth, _scrollView.frame.size.height);
                [view setFrame: pageFrame];
                // replace in array of pages
                [_pages replaceObjectAtIndex:index withObject:view];
                // add subview
                [_scrollView insertSubview:view atIndex:0];
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
- (void) unloadPage:(UIView*)page {
    [self unloadPage:page remove:NO];
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
    // check if page contain in array of visible pages
    [pagesToUnload enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self unloadPage: obj];
    }];
    
    [pagesToUnload release];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateContentLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    // set proper content size
    [self setProperContentSize: interfaceOrientation];
    // set proper edge inset
    [self setProperEdgeInset:YES forInterfaceOrientation:interfaceOrientation];
    // recalculate pages height
    [self setPageHeightForLodedPages: interfaceOrientation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) indexOfFirstVisibleView:(BOOL)loadIfNeeded {
    // calculate first visible page
    NSInteger firstVisiblePageIndex = [self indexOfFirstVisiblePage];
    
    if ([self pageExistAtIndex: firstVisiblePageIndex]) {
        
        if (loadIfNeeded) {
            // get first visible page
            id item = [_pages objectAtIndex: firstVisiblePageIndex];
            
            // chceck if is loaded, and load if needed
            if (item == [NSNull null]) {
                [self loadPageAtIndex: firstVisiblePageIndex];
            }
        }        
        
        return firstVisiblePageIndex;
    } 
    
    return NSNotFound;
}


#pragma mark -
#pragma mark Private methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger) indexOfFirstVisiblePage {
    // calculate first visible page
    CGFloat contentOffset = _scrollView.contentOffset.x;// + _scrollView.contentInset.left;
    NSInteger index = floor((contentOffset) / _pageWidth);
    
    return (index < 0) ? 0 : index;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*) visiblePages {
    
    // calculate first visible page and visible page count
    NSInteger firstVisiblePageIndex = [self indexOfFirstVisiblePage];
    NSInteger visiblePagesCount = ceil(_scrollView.bounds.size.width / _pageWidth);
    
    // create array
    NSMutableArray* array = [NSMutableArray array];
    
    for (NSInteger i=firstVisiblePageIndex; i<=visiblePagesCount; i++) {
        
        // check if page index is in bounds 
        if ([self pageExistAtIndex: i]) {
            // get page at index
            id item = [_pages objectAtIndex: i];
            
            // if page is not load, then load
            if (item == [NSNull null]) {
                item = [self loadPageAtIndex: i];
            }
            
            // add page to array if could load
            if (item) {
                [array addObject: item];
            }
        }
    }
    
    // return array of visible pages
    return array;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*) pagesOnStock {
    
    // clalculate first visible page index
    NSInteger firstVisiblePageIndex = [self indexOfFirstVisiblePage];
    
    // create array
    NSMutableArray* array = [NSMutableArray array];
    
    for (NSInteger i=0; i<=firstVisiblePageIndex; i++) {
        
        // check if page index is in bounds 
        if ([self pageExistAtIndex: i]) {
            // get page at index
            id item = [_pages objectAtIndex: i];
            
            // adds all parties, even if they are represented by [NSNull null]
            [array addObject: item];
        }
    }
    
    // return array of visible pages
    return array;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) nextPage:(UIView*)page {
    
    NSUInteger index = [_pages indexOfObject: page];
    
    if (index != [_pages count] - 1) {
        return [_pages objectAtIndex: index + 1];
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) previousPage:(UIView*)page {
    NSUInteger index = [_pages indexOfObject: page];
    
    if (index != 0) {
        return [_pages objectAtIndex: index - 1];
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) pageExistAtIndex:(NSInteger)index {
    return (([_pages count] > 0) &&
            (index >= 0) && 
            (index <= [_pages count] - 1));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize) calculateContentSize:(UIInterfaceOrientation)interfaceOrientation {
    //    CGSize size = CGSizeMake([_pages count] * _pageWidth, UIInterfaceOrientationIsPortrait(interfaceOrientation) ? self.bounds.size.height : self.bounds.size.height);
    //    NSLog(@"size: %f %f", size.width, size.height);
    
    CGFloat width = 0.0f;
    
    width = [_pages count] * _pageWidth - _pageWidth;
    
    return CGSizeMake(width, UIInterfaceOrientationIsPortrait(interfaceOrientation) ? self.bounds.size.height : self.bounds.size.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setProperContentSize { 
    // get current interface orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    // set proper content size
    [self setProperContentSize: orientation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setProperContentSize:(UIInterfaceOrientation)interfaceOrientation {
    _scrollView.contentSize = [self calculateContentSize:interfaceOrientation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIEdgeInsets) calculateEdgeInset:(UIInterfaceOrientation)interfaceOrientation {
    
    CGFloat leftInset = 0.0f;
    CGFloat rightInset = 0.0f;
    
    //left inset depends on interface orientation
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        leftInset = self.bounds.size.width/2 - _pageWidth/2;
    } else {
        leftInset = self.bounds.size.width - _pageWidth - _leftInset;
        rightInset = 2 * _pageWidth + _leftInset - self.bounds.size.width;
    }
    
    NSLog(@"inset: %f", leftInset);
    // return edge inset
    return UIEdgeInsetsMake(0.0f, leftInset, 0.0f, rightInset);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setProperEdgeInset:(BOOL)animated forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // check if animated, change content inset
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^ {
            _scrollView.contentInset = [self calculateEdgeInset:interfaceOrientation];   
        }];
    } else {
        _scrollView.contentInset = [self calculateEdgeInset:interfaceOrientation];   
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setProperEdgeInset:(BOOL)animated {
    // get current interface orientation
    UIInterfaceOrientation interfaceOrienation = [[UIApplication sharedApplication] statusBarOrientation];
    // set proper edge inset for orientation
    [self setProperEdgeInset:animated forInterfaceOrientation:interfaceOrienation];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unloadInvisiblePagesOnStock {
    // get pages on stock
    NSArray* array = [self pagesOnStock];
    
    // get lat index of array
    __block NSUInteger lastIndex = [array count] -1;
    
    // enumerate all pages on stock
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // if item is not null and is not last page (first visible page on stock)
        if ((obj != [NSNull null]) && (idx != lastIndex)) {
            // unload page
            [self unloadPage:obj];
        }
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) firstPageOnStock {
    // calculate first visible page
    NSInteger firstVisiblePageIndex = [self indexOfFirstVisiblePage];
    
    // get first visible page
    id item = [_pages objectAtIndex: firstVisiblePageIndex];
    
    // chceck if is loaded, and load if needed
    if (item == [NSNull null]) {
        return [self loadPageAtIndex: firstVisiblePageIndex];
    }
    // return page
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unloadPage:(UIView*)page remove:(BOOL)remove {
    // get index of page
    NSUInteger index = [_pages indexOfObject: page];
    
    // if page exist
    if (index != NSNotFound) {
        // remove from superview
        [page removeFromSuperview];
        
        // send message to delegate
        [self didUnloadPage:page];        
        
        // check if remove
        if (remove) {
            // remove from array
            [_pages removeObject: page];
        } else {
            // replace with null
            [_pages replaceObjectAtIndex:index withObject:[NSNull null]];
        }
    }    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) calculatePageWidth:(UIView*)view {
    CLViewSize size = [(CLSegmentedView*)view viewSize];
    CGFloat width = _pageWidth;
    
    if (size == CLViewSizeWider) {
        width = 1.5 * _pageWidth;
    }
    
    return width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setPageHeightForLodedPages:(UIInterfaceOrientation)interfaceOrientation {

    [_pages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != [NSNull null]) {
            UIView* view = (UIView*)obj;
            CGRect rect = view.frame;
            rect.size.height = UIInterfaceOrientationIsLandscape(interfaceOrientation) ? self.bounds.size.width : self.bounds.size.height;
            [view setFrame:rect];
        }
    }];
}

#pragma mark -
#pragma mark UIScrollView delegates methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat realContentOffsetX = _scrollView.contentOffset.x + _scrollView.contentInset.left;
    
    if ((_pullToDetachPages) && (!_flags.isDetachPages)) {
        if ((!_flags.willDetachPages) && (realContentOffsetX < - _scrollView.frame.size.width * PULL_TO_DETACH_FACTOR)) {
            [self didStartPullingToDetachPages];
        }
        
        if ((_flags.willDetachPages) && (realContentOffsetX > - _scrollView.frame.size.width * PULL_TO_DETACH_FACTOR)) {
            [self didCancelPullToDetachPages];
        }
    }
    
    // calculate first visible page
    NSInteger firstVisiblePageIndex = [self indexOfFirstVisiblePage];
    
    for (NSInteger i=0; i<=firstVisiblePageIndex; i++) {
        
        // check if page index is in bounds 
        if ([self pageExistAtIndex: i]) {
            // get page at index
            id item = [_pages objectAtIndex: i];
            
            if (i == firstVisiblePageIndex) {
                
                if (item == [NSNull null]) {
                    item = [self loadPageAtIndex: i];
                }
                
                CGFloat contentOffset = _scrollView.contentOffset.x;
                
                if ((i == 0) && (contentOffset <= 0)) {
                    return;
                }
                
                UIView* view = (UIView*)item;
                
                CGRect rect = [view frame];
                rect.origin.x = contentOffset;
                [view setFrame: rect];
                
            } else {
                if (item != [NSNull null]) {
                    [self unloadPage: item];
                }
                
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pullToDetachPages) return;
    
    CGFloat realContentOffsetX = _scrollView.contentOffset.x + _scrollView.contentInset.left;

    if ((_flags.willDetachPages) && (realContentOffsetX < - _scrollView.frame.size.width * PULL_TO_DETACH_FACTOR)) {
        [self didPullToDetachPages];
    }

    if ((_flags.willDetachPages) && (realContentOffsetX > - _scrollView.frame.size.width * PULL_TO_DETACH_FACTOR)) {
        [self didCancelPullToDetachPages];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_flags.isDetachPages) _flags.isDetachPages = NO;
}


#pragma mark -
#pragma mark Delegate methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didLoadPage:(UIView*)page {
    if ([_delegate respondsToSelector:@selector(cascadeView:didLoadPage:)]) {
        [_delegate cascadeView:self didLoadPage:page];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didAddPage:(UIView*)page animated:(BOOL)animated {
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didStartPullingToDetachPages {
    _flags.willDetachPages = YES;
    if ([_delegate respondsToSelector:@selector(cascadeViewDidStartPullingToDetachPages:)]) {
        [_delegate cascadeViewDidStartPullingToDetachPages:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didPullToDetachPages {
    _flags.willDetachPages = NO;
    _flags.isDetachPages = YES;
    if ([_delegate respondsToSelector:@selector(cascadeViewDidPullToDetachPages:)]) {
        [_delegate cascadeViewDidPullToDetachPages:self];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) didCancelPullToDetachPages {
    _flags.willDetachPages = NO;
    if ([_delegate respondsToSelector:@selector(cascadeViewDidCancelPullToDetachPages:)]) {
        [_delegate cascadeViewDidCancelPullToDetachPages:self];
    }
}


#pragma mark -
#pragma mark Setters

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setLeftInset:(CGFloat)newLeftInset {
    CGFloat width = [UIScreen mainScreen].bounds.size.height;
    
    _leftInset = newLeftInset;
    _pageWidth = (width - _leftInset) / 2.0f;
    
    _scrollView.frame = CGRectMake(_leftInset, 0.0, _pageWidth, self.frame.size.height);
    
    [self setProperEdgeInset: NO];
}

@end
