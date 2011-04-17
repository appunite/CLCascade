//
//  CLPhotoViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-04-07.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLPhotoViewController.h"
#import "CLImageScrollView.h"

@interface CLPhotoViewController (Private) 
- (void)configurePage:(CLImageScrollView *)page forIndex:(NSUInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)tilePages;
- (CLImageScrollView *)dequeueRecycledPage;

- (NSUInteger)imageCount;
- (UIImage *)imageAtIndex:(NSUInteger)index;
@end

@implementation CLPhotoViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) updateLayout {
    [super updateLayout];
}

#pragma mark -
#pragma mark View loading and unloading
- (void)viewDidLoad {
    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = self.view.frame;//[self frameForPagingScrollView];
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [UIColor clearColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = CGSizeMake(pagingScrollViewFrame.size.width * [self imageCount],
                                              pagingScrollViewFrame.size.height);
    pagingScrollView.delegate = self;
    [self.view addSubview: pagingScrollView];
    
    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    [self tilePages];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    [pagingScrollView release];
    pagingScrollView = nil;
    [recycledPages release];
    recycledPages = nil;
    [visiblePages release];
    visiblePages = nil;
    [pagingScrollView release];
    pagingScrollView = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [pagingScrollView release];
    [super dealloc];
}


#pragma mark -
#pragma mark Tiling and page configuration

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self imageCount] - 1);
    
    // Recycle no-longer-visible pages 
    for (CLImageScrollView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            CLImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[CLImageScrollView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
            [visiblePages addObject:page];
        }
    }    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CLImageScrollView *)dequeueRecycledPage
{
    CLImageScrollView *page = [recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [recycledPages removeObject:page];
    }
    return page;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (CLImageScrollView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)configurePage:(CLImageScrollView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.frame = [self frameForPageAtIndex:index];
    [page displayImage:[self imageAtIndex:index]];
}


#pragma mark -
#pragma mark ScrollView delegate methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}


#pragma mark -
#pragma mark  Frame calculations
#define PADDING  10

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)frameForPagingScrollView {
//    CLCascadeContentNavigator* contentNavigator = [self.parentCascadeViewController contentNavigator];
//    CGRect frame = [contentNavigator masterCascadeFrame];

    CGRect frame = self.view.frame;

    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)frameForPageAtIndex:(NSUInteger)index {
//    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    CGRect pagingScrollViewFrame = self.view.frame;
    
    CGRect pageFrame = pagingScrollViewFrame;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (pagingScrollViewFrame.size.width * index) + PADDING;
    return pageFrame;
}


#pragma mark -
#pragma mark Image wrangling

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage *)imageAtIndex:(NSUInteger)index {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg", index]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)imageCount {
    return 3;
//    static NSUInteger __count = NSNotFound;  // only count the images once
//    if (__count == NSNotFound) {
//        __count = [[self imageData] count];
//    }
//    return __count;
}

@end
