    //
//  TCSegmentedListController.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCSegmentedListController.h"

@interface TCSegmentedListController ()

-(void) initNavBar;

@end

@implementation TCSegmentedListController

@synthesize segmentedButtonTitles, segmentedSortTitle, segmentedDisabledButtons, selectedIndex, segmentedSelectorView, selectorNavBar;

- (id)init
{
    if( ( self = [super init] ) )
    {
        //initial value is all indicies are unselected
        self.selectedIndex = -1;
        self.segmentedSortTitle = NSLocalizedString( @"Sort", nil );
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    [self initNavBar];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	//start loading the items based onthe first visible index
    [self setSelectedIndex:[self firstEnabledSelectedIndex] withReload: NO];
	
    [super viewWillAppear: animated];
}

- (void) initNavBar
{	
	//create the segemented control
	segmentedSelectorView = [[UISegmentedControl alloc] initWithItems: self.segmentedButtonTitles ];
	segmentedSelectorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedSelectorView.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedSelectorView.selectedSegmentIndex = selectedIndex;
    [segmentedSelectorView addTarget: self action: @selector(selectedIndexChanged) forControlEvents: UIControlEventValueChanged];	

	//create a navigation Item to place this view into
	UINavigationItem *navItem = [[UINavigationItem alloc] init];
	navItem.titleView = segmentedSelectorView;
	
 	//Create a 'generations' button
    if( segmentedSortTitle )
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: segmentedSortTitle style: UIBarButtonItemStyleBordered target: self action: @selector(showFilterDialog)];	   
        navItem.rightBarButtonItem = button;
        [button release];
    }
    
	//now the object is placed, resize the frame to ensure it fits properly in the middle
	CGRect frame = segmentedSelectorView.frame;
	frame.size.width = self.view.bounds.size.width-10; //-10 to account for the padding on either side
	segmentedSelectorView.frame = frame;	
	
	//create the bar to display it within
	selectorNavBar = [[UINavigationBar alloc] initWithFrame: CGRectMake( 0, 0, self.tableView.bounds.size.width, 44)];
	selectorNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	selectorNavBar.delegate = self;
	selectorNavBar.tintColor = self.parentViewController.navigationController.navigationBar.tintColor;
	[selectorNavBar pushNavigationItem: navItem animated: NO];
	
	//set the tablebar's scroll to account for the bar
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake( 44, 0, 0, 0 );
    self.tableView.contentInset = UIEdgeInsetsMake( 44, 0, 0, 0 );
	//add the nav bar to the table
	//[self.tableView	setTableHeaderView: selectorNavBar];
	[self.view addSubview: selectorNavBar];
    
	[navItem release];
}

- (void)setSegmentedDisabledButtons:(NSArray *)buttons
{
	if( [buttons isEqual: segmentedDisabledButtons] == NO )
    {
        [segmentedDisabledButtons release];
        segmentedDisabledButtons = [buttons retain];
    }
	
	//enable/disable buttons as required
	NSInteger i = 0;
	for( NSNumber *num in segmentedDisabledButtons )
		[segmentedSelectorView setEnabled: [num boolValue] forSegmentAtIndex: i++ ];
}

- (NSInteger)firstEnabledSelectedIndex
{
    //if the currently selected item is now disabled, switch to the first enabled one
    //else stick with what we have
	if( selectedIndex < 0 || [segmentedSelectorView isEnabledForSegmentAtIndex: selectedIndex] == NO)
	{ 
		NSInteger i = 0;
		for( NSNumber *num in segmentedDisabledButtons )
		{
			if ( [num boolValue] == YES )
			{
				return i;
			}
			i++;
		}
	}
    
    return selectedIndex;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.segmentedDisabledButtons = nil;
	self.segmentedSelectorView = nil;
	self.selectorNavBar = nil;		
	
    [super viewDidUnload];
}


- (void)dealloc {
	[segmentedButtonTitles release]; 
	[segmentedDisabledButtons release];	
	[segmentedSelectorView release];
	[selectorNavBar release];	
	[segmentedSortTitle release];
    
    [super dealloc];
}

#pragma mark UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y > selectorNavBar.frame.size.height )
        return;
    
    CGRect frame = selectorNavBar.frame;
	frame.origin.y = MIN(-44    ,scrollView.contentOffset.y);
    selectorNavBar.frame = frame;
}

#pragma mark UISegmentedControl Action
-(void) setSelectedIndex:(NSInteger)_newIndex withReload: (BOOL)reload
{
    selectedIndex = _newIndex;
    segmentedSelectorView.selectedSegmentIndex = _newIndex;
    
    if( reload )
        [self reloadTableContent];
}

-(void) selectedIndexChanged
{ 
	//check if we're already selected
	//-1 gets automatically called if a button is disabled. We don't want to process that
	if( segmentedSelectorView.selectedSegmentIndex == -1 || selectedIndex == segmentedSelectorView.selectedSegmentIndex )
		return;
	
	[self setSelectedIndex: segmentedSelectorView.selectedSegmentIndex withReload: YES];
}

@end
