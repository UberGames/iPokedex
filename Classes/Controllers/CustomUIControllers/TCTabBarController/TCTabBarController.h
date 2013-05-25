//
//  TCTabBarController.h
//	Created by Tim Oliver on 19/11/10.
//
//	An extended view controller class that allows
//	sets up a view to display multiple subviews in
//	a UITabBar configuration similar to UITabBarController
//
//	The class automatically saves the TabBarItem order upon program exit
//	and has special code in place to handle view transitions in the event
//	it is pushed onto a UINavigationController

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TABBARCONTROLLER_SAVETABORDER_KEY [NSString stringWithFormat: @"TCTabBarControllerOrder_%@", self.saveIdentifier]
#define TABBARCONTROLLER_DEFAULT_VISIBLE_ITEMS 5;
#define TABBARCONTROLLER_TABBAR_HEIGHT 50

//--------------

@interface TCTabBarController : UIViewController <UITabBarDelegate, UINavigationControllerDelegate> {
	//unique name for this class that can be used for saving to disk
	NSString *saveIdentifier;
	
    //delegate
    id delegate;
    
    //View Elements
	//The main tabBar element
	UITabBar *tabBar;
    
	//The view controller currently being shown in the content view
	UIViewController *visibleViewController;	
	
	//More Tab
    //The items that will be displayed on more table list
    NSArray *moreTabItemList;
    //The actual more item on the tab bar
    UITabBarItem *moreTabBarItem;
    //Reference to the more table controller so we can force reload and delegation
    UITableViewController *moreTableViewController;
	//Reference to the more view controller (which can be either the table controller or nav controller)
    UIViewController *moreViewController;	
	
	//A list of all of the viewControllers we'll be displaying
	NSArray *viewControllers;
	
    //the current highlighted tab item
    UITabBarItem *selectedTabBarItem;
    //The index of the selected item (in case a direct reference isn't possible)
    NSInteger selectedTabBarIndex;
    
	//Save the tab order to UserDefaults
	BOOL persistantTabOrder;
	
	//The number of visible items in the tabbar
	NSInteger numberOfVisibleItems;
	
    //Set to true when the tabbar edit menu is open
    BOOL _isTabBarEditing;
    
	//Set to YES when a tab is opened from the More menu
	//so we know to pop the navigation stack
	BOOL _isMoreTabPushed;
    
    //If this view controller itself has a bar button object set,
    //it overrides any bar buttons provided by sub views
    UIBarButtonItem *rightBarButtonItem;
}

@property (nonatomic, copy) NSString *saveIdentifier;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UITabBar *tabBar;
@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *visibleViewController;
@property (nonatomic, assign) UITabBarItem *selectedTabBarItem;
@property (nonatomic, retain) UITabBarItem *moreTabBarItem;
@property (nonatomic, retain) UIViewController *moreViewController;	
@property (nonatomic, assign) BOOL persistantTabOrder;
@property (nonatomic, assign) NSInteger numberOfVisibleItems;
@property (nonatomic, assign) UIBarButtonItem *rightBarButtonItem;

@end

@protocol TCTabBarControllerDelegate <NSObject>

- (void)tabBarItemDidAppear: (UITabBarItem *)tabBarItem;

@end

//----------- TabBarController Categories -------------
#import "TCTabBarController+TabBarSetup.h"
#import "TCTabBarController+SwitchHandling.h"
#import "TCTabBarController+TransitionHandling.h"
#import "TCTabBarController+UITabBarDelegate.h"
#import "TCTabBarController+UITableViewDelegate.h"
#import "TCTabBarController+TCMoreTabViewController.h"
#import "TCTabBarController+MoreMenuEntry.h"
