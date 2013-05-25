//
//  UICustomNavigationController.m
//  NavTab
//
//  Created by Timothy Oliver on 17/11/10.
//  Copyright 2010 UberGames. All rights reserved.
//

#import "TCNavigationController.h"
#import "UIDevice+VersionTracker.h"

#define MAX_VIEWCONTROLLERS 5

@implementation TCNavigationController

@synthesize tapHoldRecognizer;

#pragma mark Class *structors
- (void)viewDidLoad
{	
	[super viewDidLoad];
	
    if( NSClassFromString(@"UILongPressGestureRecognizer") != nil )
    {
        //init the gesture recognizer
        tapHoldRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector( handleTap: ) ];
        //attach the gesture recognizer to the navigation bar
        [self.navigationBar addGestureRecognizer: tapHoldRecognizer];
	}
	self.delegate = self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (self.visibleViewController )
    {
        return [self.visibleViewController shouldAutorotateToInterfaceOrientation: interfaceOrientation];
    }
        
    return YES;
}

- (void) dealloc
{
	[tapHoldRecognizer release];
	[super dealloc];
}

#pragma mark UINavigationController methods
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{ 
	if( [self.viewControllers count]-1	> MAX_VIEWCONTROLLERS )
	{
		//create a new array of controllers
		NSMutableArray *controllers = [[NSMutableArray alloc] init];
		
		//add the root view
		[controllers addObject: [self.viewControllers objectAtIndex: 0]];
		
		//add the last set of view controllers to this new array
		for( NSInteger i = 0; i < MAX_VIEWCONTROLLERS; i++ )
		{
			NSInteger index = (([self.viewControllers count])-MAX_VIEWCONTROLLERS) + i;
			[controllers addObject: [self.viewControllers objectAtIndex: index]]; 
		}

		//push these back to the main list
		[self setViewControllers: controllers animated: NO];
		[controllers release];
	}
	
	[super pushViewController: viewController animated: animated];
}

#pragma mark UIGesture Delegate Methods
- (void) handleTap: (UILongPressGestureRecognizer *)sender
{
    //disable for iOS 3
    if( [[UIDevice currentDevice] isIOS3] )
        return;
    
	if( sender.state == UIGestureRecognizerStateBegan && [self.viewControllers count] > 1 )
	{
		//get the point the gesture was activated at
		CGPoint touch = [sender locationOfTouch: 0 inView: self.navigationBar];
		//get size of the nav box
		CGRect navBarBounds = self.navigationBar.bounds;
		
		//approximate the width of the 'back' button and set the valid bounds to it
		navBarBounds.size.width = 120.0f;
		
		//if the touch point was inside the box, pop the navigation stack
		if( CGRectContainsPoint(navBarBounds, touch) )
			[self popToRootViewControllerAnimated: YES];
	}
}

@end



