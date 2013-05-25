//
//  TCMoreTabViewController.m
//
//  Created by Timothy Oliver on 4/12/10.
//
//	In an instance of a TCTabController being a child of a UINavigationController,
//	when a tab's view controller is pushed from
//	the 'More' menu , it is placed inside this abstract
//	dummy view controller so the frame dimensions can be properly
//	maintained and the parent tabController can be tracked.
//
//	NB: This class is only used if the parent TCTabController itself
//	is a child of a UINavigationController, so it is ALWAYS assumed
//	that self.navigationController != nil

#import "TCTabBarController+TCMoreTabViewController.h"
#import "TCTabBarController+TransitionHandling.h"

@implementation TCMoreTabViewController

@synthesize parentTabController, viewController;

- (id)initWithParentControllor: (TCTabBarController *)parent viewController: (UIViewController *)_controller
{
	if( (self = [super init]) )
	{
		self.parentTabController = parent;
		self.viewController = _controller;
		
		self.title = viewController.title;
	}
	
	return self;
}

- (void)dealloc
{
    //redirect the view controller's parent back to the parent tab controller
    //(else if we call something on the controller that forces it to check its parent, it'll crash)
    [viewController setValue: parentTabController forKey: @"parentViewController"];
    
	[parentTabController release];
	[viewController release];
	
	[super dealloc];
}

- (void) loadView
{ 
	//When this view loads, so must its parent view (in order to get the tabBar object)
	//Force lazy load the parents view to reload its content
	[parentTabController view]; 
    [viewController setValue: self forKey: @"parentViewController"];
	
	//create the main background canvas
	UIView *newView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    
    if( [UIColor respondsToSelector: NSSelectorFromString( @"scrollViewTexturedBackgroundColor" )] )
        newView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	else
        newView.backgroundColor = [UIColor blackColor];
    
    newView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	self.view = newView;
	[newView release];
}

-(void) viewDidLoad
{	
	//resize the target view to fit inside the bound
	viewController.view.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height - self.parentTabController.tabBar.frame.size.height );
	[self.view addSubview: viewController.view];	
	
	//set navigation properties
	self.title = viewController.title;
	self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;	
	
	[super viewDidLoad];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    //animate the view
	[super viewWillAppear: animated];  
    
	//re-direct the parent of the tab view controller to us (as the tab controller is out of focus now)s
	[viewController setValue: self forKey: @"parentViewController"];
	
	//send the load message to the child controller letting it know it's about to appear
	[viewController viewWillAppear: animated];

    //if the bar is currently positioned in the parent (eg memory warning etc)
    //move the bar to here
    if( self.navigationController )
    {
        UIView *superview = parentTabController.tabBar.superview;
        if( superview == parentTabController.view )
            [parentTabController moveTabBarToController: self];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];	
	
	//send an event to the parent, telling it a tab item just got made visible
	//[parentTabController tabItemDidAppear: targetTabItem];	
	
	//once this view comes in, put the tab bar back into this controller's view 
	//(in case of subsequent transitions or overlays)
	if( self.navigationController )
		[self.parentTabController moveTabBarToController: self];
}

// When the view is sent a disappear message, this can mean 1 of 2 things:
// 1) Another view controller is being pushed on top of it. If this a TCTabController, set up tabBars of both for the crossfade animation
// 2) It's being popped back to its parent TabController, in which case, put the tabBar into the navigationController view, so it remains locked in place on the screen during transition
- (void) viewWillDisappear:(BOOL)animated
{
    //inform the child view controller that it is being moved
	if( viewController )
		[viewController viewWillDisappear: animated];
    
	if( animated == NO || self.navigationController == nil)
	{
		[super viewWillDisappear: animated];
        return;
    }
    
    //the target view controller we're transitioning to
    //(Since this already updated by the time the message is sent, the last object will always be the target view controller in the stack)
    UIViewController *target = [self.navigationController.viewControllers lastObject];
    
    //if the target is our parent, make sure the tab bar is placed in the navController's bounds and then animate as normal
    if( [target isEqual: self.parentTabController ] )
    {
        [self.parentTabController moveTabBarToController: self.navigationController];
        [super viewWillDisappear: animated];
        return;
    }
    
    //if our view currently has a search bar active, or our target does, just animate as normal
    //(Else the tabBars will wind up on top of the search views)
    if( self.searchDisplayController.isActive == YES || target.searchDisplayController.active == YES )
    {
        [super viewWillDisappear: animated];
        return;	
    }			
	
	//send the super message
	[super viewWillDisappear: animated];	
}

@end	
