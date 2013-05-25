//
//  TCTabBarController+UITableViewDelegate.h
//
//  Created by Timothy Oliver on 4/12/10.
//
//	An extended view controller class that 
//	sets up a view to display multiple subviews in
//	a UITabBar configuration similar to UITabBarController
//
//	The class automatically saves the TabBarItem order upon program exit
//	and has special code in place to handle view transitions in the event
//	it is pushed onto a UINavigationController

#import "TCTabBarController.h"
#import "TCTabBarController+MoreMenuEntry.h"
#import "TCTabBarController+TCMoreTabViewController.h"

@implementation TCTabBarController ( UITableViewDelegate )
//Table view delegate events for the table view in the 'More' tab

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//the table displays all entries that aren't on the main tab bar
	return [moreTabItemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TCMoreMenuEntry *menuEntry = [moreTabItemList objectAtIndex: indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"moreTableCell"];
	if( cell == nil )
    {
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"moreTableCell"] autorelease];
        //Accessory
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	//Image
	cell.imageView.image = menuEntry.tabBarItem.image;
	cell.imageView.highlightedImage = menuEntry.highlightedImage;
	
	//Text
	cell.textLabel.text = menuEntry.tabBarItem.title;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//get the selected item
	TCMoreMenuEntry *menuItem = [moreTabItemList objectAtIndex: indexPath.row];
	
	//play deselect animation
	[tableView deselectRowAtIndexPath: indexPath animated: YES ];
	
    //determine the target viewController
    UIViewController *targetController = [self viewControllerForTabBarItem: menuItem.tabBarItem];
	if( targetController == nil )
		return;
	
	//get the more menu navigation item and push the new view controller onto it
	if( self.navigationController )
	{
		//create a 'more' view controller which the navigation stack will recognize
		TCMoreTabViewController *newController = [[TCMoreTabViewController alloc] initWithParentControllor: self viewController: targetController];
		
		//Push the new view controller out to the nav stack
		UINavigationController *nav = self.navigationController;
		[nav pushViewController: newController animated: YES];
		
		//dealloc created objects
		[newController release];
	}
	else {
		UINavigationController *nav = (UINavigationController *)moreViewController;
		[nav pushViewController: targetController animated: YES];
	}
	
    if( [self.delegate respondsToSelector: @selector(tabBarItemDidAppear:)] )
        [self.delegate tabBarItemDidAppear: menuItem.tabBarItem];
    
	//set the pushed state to yes
	_isMoreTabPushed = YES;
}

@end
