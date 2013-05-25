//
//  TCTabBarController+UITabBarDelegate.m
//
//  Created by Timothy Oliver on 4/12/10.
//
//	The UITabBarDelegate events for the
//	TCTabBarController class. This includes
//	custom code for when the active tab gets changed
//	and delegate events when the 'Edit' bar appears
//	and disappears.


#import "TCTabBarController+UITabBarDelegate.h"
#import "TCTabBarController+SwitchHandling.h"

@implementation TCTabBarController (UITabBarDelegate)

-(void) beginCustomizingTabItems
{
    //build a list of all of the item items
    NSMutableArray *tabItems = [NSMutableArray new];
    for ( UIViewController *controller in viewControllers )
        [tabItems addObject: [controller tabBarItem] ];
    
	//spawn the customization view
	[tabBar beginCustomizingItems: tabItems];
    [tabItems release];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{	
	[self switchToNewSelectedItem: item];
}

- (void)tabBar: (UITabBar *)_tabBar willBeginCustomizingItems: (NSArray *)items
{
	//if it's inside a navigationcontroller, we NEED to hide it, or the close button gets stuck under the navigation bar
	if( self.navigationController != nil )
	{
		//animate the navbar to hide
		[self.navigationController setNavigationBarHidden: YES animated: YES];

		//find the tab bar customize view in the hierarchy and reset its frame to 0.
		//(Apple obviously assumed this will always be in a subview with a header bar, so its offset is initially -44)
		for( UIView *subview in self.view.subviews )
		{
			if( [subview isKindOfClass: [NSClassFromString(@"UITabBarCustomizeView") class] ] )
			{
				//reset the bounds of this view to default (ie match parent)
				subview.frame = self.view.bounds;
				
				//if we are inside a nav controller, match the tint
				if( self.navigationController )
				{
					for( UIView *_subview in subview.subviews )
					{
						if ( [_subview isKindOfClass: [UINavigationBar class]] )
						{
							[(UINavigationBar *)_subview setTintColor: self.navigationController.navigationBar.tintColor];
							break;
						}
					}
				}
				
				break;
			}
		}
	}
    
    _isTabBarEditing = YES;
}

- (void)tabBar:(UITabBar *)_tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed
{
	//if we're inside a UINavigationController, restore the navigation bar
	if( self.navigationController )
		[self.navigationController setNavigationBarHidden: NO animated: YES];
	
	if( changed )
	{
        NSMutableArray *visibleControllers = [NSMutableArray array];
        
        for( UIViewController *controller in viewControllers )
        {
            if( [self.tabBar.items indexOfObject: [controller tabBarItem]] != NSNotFound )
                [visibleControllers addObject: controller];
        }
        
		//reset the parent controllers of the new visible tabs
		for( UIViewController *controller in visibleControllers )
			[controller setValue: self forKey: @"parentViewController" ];
		
		//update the more window
		[self buildMoreItemList];
	}
	
	//Save the new order to disk
	if( changed && persistantTabOrder )
	{
        [self saveTabBarOrderToFileWithList: self.tabBar.items];
	}
    
    _isTabBarEditing = NO;
}

@end
