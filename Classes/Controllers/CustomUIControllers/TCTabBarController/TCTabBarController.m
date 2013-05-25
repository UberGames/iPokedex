//
//  TCTabBarController.m
//  Created by Tim Oliver on 19/11/10.
//
//	An extended view controller class that
//	sets up a view to display multiple subviews in
//	a UITabBar configuration similar to UITabBarController
//
//	The class automatically saves the TabBarItem order upon program exit
//	and has special code in place to handle view transitions in the cases of
//	it being pushed onto a UINavigationController

#import "TCTabBarController.h"

@implementation TCTabBarController

@synthesize saveIdentifier,
            delegate,
            tabBar,
            viewControllers,
            visibleViewController,
            moreTabBarItem,
            moreViewController,
            selectedTabBarItem,
            persistantTabOrder,
            numberOfVisibleItems,
            rightBarButtonItem;

#pragma mark Initialization

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.numberOfVisibleItems = TABBARCONTROLLER_DEFAULT_VISIBLE_ITEMS;	
        selectedTabBarIndex = -1;
	}
	return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
	if( (self = [super initWithCoder: aDecoder]) )
	{
		self.numberOfVisibleItems = TABBARCONTROLLER_DEFAULT_VISIBLE_ITEMS;	
        selectedTabBarIndex = -1;
	}
	
	return self;
}

//initialize the view region and add all of the default UI elements
- (void)loadView
{ 
	//set up the view for this controller. Consists of a background and the tab bar
	UIView *mainView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	
    //legacy support for iOS 3
    if( [UIColor respondsToSelector: NSSelectorFromString( @"scrollViewTexturedBackgroundColor" )] )
        mainView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    else
        mainView.backgroundColor = [UIColor blackColor];
	
    mainView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	mainView.autoresizesSubviews = YES;
	mainView.clipsToBounds = YES;
	self.view = mainView;
	[mainView release];
	
	tabBar = [[UITabBar alloc] initWithFrame: CGRectMake( 0, self.view.bounds.size.height-TABBARCONTROLLER_TABBAR_HEIGHT, self.view.bounds.size.width, TABBARCONTROLLER_TABBAR_HEIGHT)];
	tabBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
	tabBar.delegate = self;
	tabBar.contentMode = UIViewContentModeRedraw;
	tabBar.clipsToBounds = YES;
	[self.view addSubview: tabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	
	//if transitioning to this view now, send a message to its active view controller
	if( visibleViewController )
    {
		[visibleViewController viewWillAppear: animated];
    }
    
    if( selectedTabBarItem && selectedTabBarItem != moreTabBarItem )
    {
        //send a delegate event to the delegate to let it know a tab item appeared
        if( [self.delegate respondsToSelector: @selector(tabBarItemDidAppear:)] )
            [self.delegate tabBarItemDidAppear: selectedTabBarItem];
    }
    
    //If the view is appearing, and it appears that the tabbar isn't
    //in here, or in the parent nav (eg, by a controller that has been removed from the nav stack)'
    //reset it here
    UIView *superview = tabBar.superview;
    if( self.navigationController )
    {
        if( [superview isEqual: self.view] == NO && [superview isEqual: self.navigationController.view] == NO)
            [self moveTabBarToController: self];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
 	//if transitioning out of this view now, send a message to its active view controller
	if( visibleViewController )
		[visibleViewController viewWillDisappear: animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self.visibleViewController willAnimateRotationToInterfaceOrientation: interfaceOrientation duration:duration];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if( _isTabBarEditing )
        return NO;
        
    return YES;
}

#pragma mark Memory Management

- (void) viewDidUnload
{
    [super viewDidUnload];
    
	//unlink any tab items in here
	self.tabBar = nil;    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[viewControllers release];
	[saveIdentifier release];
	[tabBar release];
	[moreTabItemList release];
    [moreTabBarItem release];
	[moreViewController release];
    [rightBarButtonItem release];
    [visibleViewController release];
	
    [super dealloc];
}

#pragma mark Accessor Methods
- (void) setRightBarButtonItem:(UIBarButtonItem *)newButton
{
    if( [newButton isEqual: rightBarButtonItem] )
        return;
    
    [rightBarButtonItem release];
    rightBarButtonItem = [newButton retain];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

@end


