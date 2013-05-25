//
//  TCTabBarController+.m
//  iPokedex
//
//  Created by Timothy Oliver on 22/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCTabBarController+SwitchHandling.h"

@implementation TCTabBarController (SwitchHandling)

- (void)switchToSelectedIndex: (NSInteger) index
{
	UITabBarItem *selectItem = [self.tabBar.items objectAtIndex: index];
	if( !selectItem )
		return;
	
	[self switchToNewSelectedItem: selectItem];
}

- (void)switchToNewSelectedItem: (UITabBarItem *) newItem
{	
    //ignore if we tapped the same item twice
    if( self.tabBar.selectedItem != nil && [self viewControllerForTabBarItem: newItem] == visibleViewController )
        return;

	//if we're in the More Tab and we're currently pushed into a Tab view from it's Nav controller, 
	//remove it from the nav stack
	if ( _isMoreTabPushed )
	{
		if( self.navigationController ) {
			[self.navigationController popToViewController: self animated: NO];
		} else {
			[(UINavigationController *)self.moreViewController popToRootViewControllerAnimated: NO];
		}
		
		_isMoreTabPushed = NO;
	}	
	
	//switch over the view controllers
	[self transitionToNewSelectedItem: newItem];
	
    //save the selected item (for memory warning cases)
    selectedTabBarItem = newItem;
    selectedTabBarIndex = [self.tabBar.items indexOfObject: newItem];
    
	//set the selected item in the tab bar
	self.tabBar.selectedItem = newItem;
}

//When a new tab bar item is passed, the controller removes the
//current content view and places the new one in its place
//(NB: This particular method only handles the actual switching of the views.
//All error checking is actually done in the 'switchToNewSelectedItem' method)
- (void)transitionToNewSelectedItem: (UITabBarItem *) newItem
{ 	
    //check to ensure this view controller is actually visible right now
    //(if it's not, don't send any viewDidAppear/Disappear messages;
    //the parentController will do that when the view becomes visible)
    BOOL isVisible = (self.view.superview != nil);
    
    //send a delegate event
    if( isVisible )
    {
        //send a delegate event
        if( [self.delegate respondsToSelector: @selector(tabBarItemDidAppear:)] && newItem != moreTabBarItem )
            [self.delegate tabBarItemDidAppear: newItem];
    }
    
	//if there is already a visible view controller, remove its reference
	if( self.visibleViewController != nil )
	{
		//send it a message saying it's about to disappear
		if( isVisible )
            [visibleViewController viewWillDisappear: NO];
		
        //remove it from the stack
		[visibleViewController.view removeFromSuperview];
        
        //send it a message saying it's now disappeared
        if( isVisible )
            [visibleViewController viewDidDisappear: NO];
		
		//release it from this pointer
		self.visibleViewController = nil;
	}
	
    //derive the view controller from the tab item
    UIViewController *newController = [self viewControllerForTabBarItem: newItem];
    if( newController == nil )
        return;
    
	//set the title of the parent navigation bar
	if( [newItem.title length] > 0 && [self.title length] <= 0 )
		self.navigationItem.title = newItem.title;
	else if (newItem == self.moreTabBarItem && [self.title length] <= 0 ) //Not sure why, but Apple seem to have specifically locked this out
		self.navigationItem.title = NSLocalizedString(@"More", @"More Tab Item");
    
	//reset the navigation item
    if( self.rightBarButtonItem == nil )
        self.navigationItem.rightBarButtonItem = nil;
	
	//if the new item has a view controller specified
	if( newController != nil )
	{
		//add the new view controller
		self.visibleViewController = newController;
        
        //reset frame to match content view
		//(height is the height of the avialble frame minus the tabBar height)
        visibleViewController.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tabBar.frame.size.height );        
        visibleViewController.view.clipsToBounds = YES;   
        visibleViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        //send notification to controller to prepare for display
        if( isVisible )
            [visibleViewController viewWillAppear: NO];
        
        //re-set the frame. just in case viewWillAppear modified it (eg a search controller hid the navigation bar)
        //(yeah this is hacky, but it seems to work X_X)
        visibleViewController.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height-self.tabBar.frame.size.height );
        
		//add view controller to content view
		[self.view addSubview: visibleViewController.view];
        
        //inform the view it just appeared
        if( isVisible )
            [visibleViewController viewDidAppear: NO];
        
		//make sure the tab bar is brought to the front, or else its edit mode will break the whole app
		[self.view bringSubviewToFront: tabBar];
		
		//if there is a parent nav controller, override the current nav item info with this view's information
		if( self.rightBarButtonItem == nil && self.navigationController )
			self.navigationItem.rightBarButtonItem = visibleViewController.navigationItem.rightBarButtonItem;
	}
	
	//if we're switching to the more tab, ensure the delegates are properly set
	//(This can get reset if a memory error is triggered)
	if ( newItem == moreTabBarItem )
	{
		moreTableViewController.tableView.delegate = self;
		moreTableViewController.tableView.dataSource = self;	
	}
}

@end
