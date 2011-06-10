//
//  CLSplitCascadeViewController.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-03-27.
//  Copyright 2011 CreativeLabs.pl. All rights reserved.
//

#import "CLSplitCascadeViewController.h"
#import "CLSplitCascadeView.h"

@implementation CLSplitCascadeViewController

@synthesize cascadeNavigationController = _cascadeNavigationController;
@synthesize categoriesViewController = _categoriesViewController;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_cascadeNavigationController release], _cascadeNavigationController = nil;
    [_categoriesViewController release], _categoriesViewController = nil;
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) loadView {
    NSString *nib = self.nibName;
    if (nib) {
        NSBundle *bundle = self.nibBundle;
        if(!bundle) bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:nib ofType:@"nib"];
        
        if(path) {
            self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
            CLSplitCascadeView* view_ = (CLSplitCascadeView*)self.view;
            [view_ setCategoriesView: self.categoriesViewController.view];
            [view_ setCascadeView: self.cascadeNavigationController.view];
            return;
        }
    }
    
    CLSplitCascadeView* view_ = [[CLSplitCascadeView alloc] init];
    self.view = view_;
    [view_ setCategoriesView: self.categoriesViewController.view];
    [view_ setCascadeView: self.cascadeNavigationController.view];
    [view_ release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) viewDidLoad {
    [super viewDidLoad];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.cascadeNavigationController = nil;
    self.categoriesViewController = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark -
#pragma mark Class methods

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setBackgroundView:(UIView*)backgroundView {
    [(CLSplitCascadeView*)self.view setBackgroundView: backgroundView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setDividerImage:(UIImage*)image {
    [(CLSplitCascadeView*)self.view setVerticalDividerImage: image];
    
}

@end
