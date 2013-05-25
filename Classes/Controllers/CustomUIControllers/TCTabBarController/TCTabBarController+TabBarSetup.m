//
//  TCTabBarController+ManualAccessors.m
//  iPokedex
//
//  Created by Timothy Oliver on 21/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCTabBarController+TabBarSetup.h"

#define IS_IOS_3 ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0f)

@implementation TCTabBarController (TabBarSetup)

#pragma mark -
#pragma mark Manual Accessors
- (void)setViewControllers: (NSArray *)newControllers
{ 
    if( newControllers == viewControllers )
        return;
    
    [viewControllers release];
    viewControllers = [newControllers retain];
    
    //rather cheap dodgy hack to ensure this works on iOS 3
    //When the UITabBar view is released in a memory warning, it somehow breaks any
    //child UITabBarItems inside it to the point of them not working in a new one. 
    //This way, when the view is loaded, we force a complete dealloc and realloc of the items so they're set up 
    //from scratch each time.
    //This was fixed in iOS 4. Obviously it's an epic fail on Apple's behalf, and they knew about it.
    if( IS_IOS_3 )
    {
        for( UIViewController *controller in viewControllers )
        {
            [self reinitTabBarItemWithController: controller];
        }
        
        //manually reset the 'more menu'
        self.moreTabBarItem = nil;
        self.moreViewController.tabBarItem = nil;
    }
    
    //set up each viewController
    NSInteger index = 0;
    for( UIViewController *controller in viewControllers )
    {
        //record the index of the controller in the array as the item's tag
        controller.tabBarItem.tag = index++;
        //make sure the controller knows it's a child of this controller
        [controller setValue: self forKey: @"parentViewController"];
    } 
    
    //this tab controller has been set up for loading its order from file
    if( persistantTabOrder )
    {
        //if tab order hasn't been saved, resort to default
        if( [self populateTabBarFromSavedList] == NO )
            [self populateTabBarFromDefaultList];
    }
    else
    {
        //load from default
        [self populateTabBarFromDefaultList];
    }
    
    //force the tab bar to redraw itself
    [self.tabBar setNeedsDisplay];
    
    //if selectedTabBarIndex is active, it means that we're restoring
    //this view from a memory warning now. Restore all of the views
    if( selectedTabBarIndex >= 0 )
    {
        UITabBarItem *selected = [tabBar.items objectAtIndex: selectedTabBarIndex];
        self.selectedTabBarItem = selected;
        [self transitionToNewSelectedItem: selected];
        [self.tabBar setSelectedItem: selected];
    }
    else //not restoring. just use the first index
    {
        [self switchToSelectedIndex: 0];
    }
}

#pragma mark -
#pragma mark UITabBar Item Population Methods
- (void)reinitTabBarItemWithController: (UIViewController *)controller
{
    NSString *title = [controller.tabBarItem.title retain];
    UIImage *image = [controller.tabBarItem.image retain];
    
    controller.tabBarItem = nil;
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = image;
    
    [title release];
    [image release];
}

- (BOOL)populateTabBarFromDefaultList
{
    BOOL willRequireMoreItem = NO;
    NSInteger itemsNum = self.numberOfVisibleItems;
    
    //check if we'll need to add a more item
    if( [viewControllers count] > itemsNum )
    {
        itemsNum--;
        willRequireMoreItem = YES;
    }
    else
    {
        itemsNum = [viewControllers count];
    }
        
    //add the items to the list
    NSMutableArray *tabItems = [NSMutableArray array];
    for( NSInteger i = 0; i < itemsNum; i++ )
        [tabItems addObject: [[viewControllers objectAtIndex: i] tabBarItem]];
    
    //add the items to the tab bar
    self.tabBar.items = tabItems; 
    
    //check for a more item and append to the bar if needed
    if( willRequireMoreItem )
    {
        [self initMoreTabBarItem];
        
        [tabItems addObject: moreTabBarItem];
        self.tabBar.items = tabItems;
    }
    
    return YES;
}

- (BOOL)populateTabBarFromSavedList
{
    NSArray *savedTabOrder = [[NSUserDefaults standardUserDefaults] arrayForKey: TABBARCONTROLLER_SAVETABORDER_KEY];
    if( savedTabOrder == nil )
        return NO;
    
    BOOL willRequireMoreItem = NO;
    NSInteger itemsNum = self.numberOfVisibleItems;
    
    //check if adding a 'more' tab item is needed
    if( [viewControllers count] > itemsNum )
    {
        itemsNum--;
        willRequireMoreItem = YES;
    }
    
    NSMutableArray *tabItems = [NSMutableArray array];
    NSInteger i = 0;
    
    for( NSNumber *tabIndex in savedTabOrder )
    {
        if( i >= itemsNum )
            break;
        
        //-1 because tag titles are saved with a +1 offset
        NSInteger index = [tabIndex intValue]-1;
        //make sure index is a 
        if( index < 0 || index >= [viewControllers count] )
            continue;
        
        UITabBarItem *item = [[viewControllers objectAtIndex: index] tabBarItem];
        [tabItems addObject: item];
        
        i++;
    }
    
    //potential error cleaning. If the number of items saved was less than
    //the number of tabs required to display, loop through and pad it out
    //with additional controllers
    if( [tabItems count] < itemsNum )
    {
        NSInteger i = [tabItems count];
        
        //loop through each controller in the list,
        //grab its tab item, and check if it's in the tab bar array
        //if it isn't, add it in
        for( UIViewController *controller in viewControllers )
        {
            if( i >= itemsNum )
                break;
            
            UITabBarItem *item = [controller tabBarItem];
            if( [tabItems indexOfObject: item] != NSNotFound )
                continue;
            
            [tabItems addObject: item];
            i++;
        }
        
        //save this new list to file for next time
        [self saveTabBarOrderToFileWithList: tabItems];
    }
    
    self.tabBar.items = tabItems;
    
    //check for a more item and append to the bar if needed
    if( willRequireMoreItem )
    {
        [self initMoreTabBarItem];
        
        [tabItems addObject: moreTabBarItem];
        self.tabBar.items = tabItems;
    }
    
    return YES;    
}

#pragma mark -
#pragma mark 'More' Tab + Controller Setup
- (void)initMoreTabBarItem
{
    //create the more tab if not already
	if( moreTabBarItem == nil )
	{
		//create the tab bar item
		NSInteger tag = [viewControllers count]+1;
        moreTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem: UITabBarSystemItemMore tag: tag];
	}
	
    //if a more controller already exists (eg this is called as a result of a memory warning)
    //hook it up to the new more tabbar item and refresh it
    if( moreViewController != nil )
    {
        //assign the tab bar item to the more controller
        moreViewController.tabBarItem = moreTabBarItem;
        //reset the delegates
        moreTableViewController.tableView.delegate = self;
        moreTableViewController.tableView.dataSource = self;
        
        //reload the table view
        [self buildMoreItemList];
        return;
    }
    
	//create a table view controller for this menu
	UITableViewController *tableController = [[UITableViewController alloc] initWithStyle: UITableViewStylePlain ];
    tableController.tableView.opaque = YES;
    tableController.tableView.backgroundColor = [UIColor whiteColor];
	tableController.tableView.delegate = self;
	tableController.tableView.dataSource = self;
    moreTableViewController = [tableController retain];
	
	//create the edit button and append the button to the nav item of this view
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target: self action:@selector( beginCustomizingTabItems ) ];
	
	//if we are not a child of a navigation controller, manually add our own navigation controller that can be used to push controllers
	if( self.navigationController == nil )
	{
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: tableController];
		navController.navigationItem.title = NSLocalizedString(@"More", @"More Tab Item");
		navController.navigationItem.rightBarButtonItem = button;
		
        self.moreViewController = navController;
        [navController release];
	}
	else //else, we'll just keep the table controller, and intercept control from the parent nav controller later 
	{
		tableController.navigationItem.title = NSLocalizedString(@"More", @"More Tab Item");
		tableController.navigationItem.rightBarButtonItem = button;
		
		//attach the nav controller as the main view controller for this tab
		self.moreViewController = tableController;			
	}
	
	[tableController release];
	[button release];	
	
    //attach the more tab item to the final more controller
    self.moreViewController.tabBarItem = moreTabBarItem;
    
	//build the list of items for the more tab
	[self buildMoreItemList];
}

- (void)buildMoreItemList
{
    //clear the old list
    if( moreTabItemList )
    {
        [moreTabItemList release];
        moreTabItemList = nil;
    }
	
	//duplicate the master list
	NSMutableArray *nonVisibleList = [NSMutableArray array];
	
	//go through each visible tab, and remove it from the list
	for( UIViewController *controller in viewControllers )
    {
        UITabBarItem *item = [controller tabBarItem];
        
        if( [self.tabBar.items indexOfObject: item] == NSNotFound )
            [nonVisibleList addObject: item];
    }
    
    //convert the list to more menu entry
    NSMutableArray *moreList = [NSMutableArray array];
    
    for( UITabBarItem *item in nonVisibleList )
        [moreList addObject: [TCMoreMenuEntry moreMenuEntryWithItem: item]];
    
    moreTabItemList = [[NSArray alloc] initWithArray: moreList];
         
	//force the table to refresh itself
	[moreTableViewController.tableView reloadData];
}

#pragma mark - 
#pragma mark Persistant Save/Load Methods
- (void)saveTabBarOrderToFileWithList: (NSArray *)tabOrder
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tabIndexOrder = [NSMutableArray new];   
    
    for( UITabBarItem *item in tabOrder )
    {
        //ignore the more tab
        if( item == moreTabBarItem )
            continue;
        
        [tabIndexOrder addObject: [NSNumber numberWithInt: item.tag+1] ]; //+1 to ensure we don't record a 'valid' null object
    }
    
    //save to UserDefaults
    [userDefaults setObject: tabIndexOrder forKey: TABBARCONTROLLER_SAVETABORDER_KEY ];
    [userDefaults synchronize];
    
    //free up resources
    [tabIndexOrder release];
}

#pragma mark -
#pragma mark ViewController to TabBarItem Handler Methods

- (UIViewController *)viewControllerForTabBarItem: (UITabBarItem *)item
{
    //special case for the more tab item
    if( item == moreTabBarItem )
        return moreViewController;
    
    NSInteger index = item.tag;
    if( index < 0 || index >= [viewControllers count] )
        return nil;
    
    return [viewControllers objectAtIndex: index];
}

@end
