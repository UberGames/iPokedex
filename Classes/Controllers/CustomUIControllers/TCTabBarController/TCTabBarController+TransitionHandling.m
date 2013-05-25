//
//  TCTabBarController+TransitionHandling.m
//  iPokedex
//
//  Created by Timothy Oliver on 22/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCTabBarController+TransitionHandling.h"

@implementation TCTabBarController (TransitionHandling)

- (void) moveTabBarToController: (UIViewController *) viewController
{
	if( self.tabBar.superview == viewController.view )
		return;
	
	//pull it out of this view
	[tabBar removeFromSuperview];
	
	//refactor the frame position so it appears in the bottom of the window
	//(NB: MUST use bounds to ensure proper positioning after translation)
	tabBar.frame = CGRectMake( 0, viewController.view.bounds.size.height-TABBARCONTROLLER_TABBAR_HEIGHT, self.view.bounds.size.width, TABBARCONTROLLER_TABBAR_HEIGHT);	
	
	//add to the new controller
	[viewController.view addSubview: tabBar];
	
	//bring the tabBar back to the front
	[viewController.view bringSubviewToFront: tabBar];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];	
	
	//once this view comes in, put the tab bar back into this controller's view 
	//(in case of subsequent transitions or overlays)
	if( self.navigationController )
		[self moveTabBarToController: self];
}

- (void) viewWillDisappear:(BOOL)animated
{
	//let the current subview know it's about to disappear
	if( visibleViewController )
		[visibleViewController viewWillDisappear: animated];
	
	//ignore this if the transition has no animation,
	//or we are not part of a nav controller (in which case, another instantaneous transition)
	if( animated == NO || self.navigationController == nil )
	{
		[super viewWillDisappear: animated];
		return;
	}
	
	//this is the target view controller we're transitioning to
	//(This can either be before or after us in the stack, but by this point, it will be the last value in this array)
	UIViewController *target = [self.navigationController.viewControllers lastObject];
	
	//if the target is an active search controller, just animate normally
	if( self.searchDisplayController.isActive == YES || target.searchDisplayController.active == YES )
	{
		[super viewWillDisappear: animated];
		return;	
	}
	
	//if the target is a 'more' tab. check it's ours and handle it accordingly
	if( [target isKindOfClass: [TCMoreTabViewController class]] == YES ) //The target is a 'more' tab
	{
		TCMoreTabViewController *moreTab = (TCMoreTabViewController *)target;
		
		//if this is indeed the child more tab controller of this class
		if( [moreTab.parentTabController isEqual: self] == YES )
		{
			//move the tabBar to the parent navcontroller
			[self moveTabBarToController: self.navigationController];
			
			[super viewWillDisappear: animated];
			return;
		}
	}
	
	[super viewWillDisappear: animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear: animated];
	
	//inform the active controller that it's disappearing
	if( self.visibleViewController )
		[visibleViewController viewDidDisappear: animated];
}

@end
