//
//  TCSearchableListViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 14/02/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCSearchableListViewController.h"
#import "UIColor+CustomColors.h"
#import "EntryFinder.h"
#import "TCTableViewCell.h"

#define MAX_LAZY_IMAGES 100

@implementation TCSearchableListViewController

@synthesize tableSearchedEntries, 
			searchBar, 
			searchController,
			parentNavigationController,
			savedSearchTerm,	
			savedScopeButtonIndex,
			searchWasActive,
            searchWasWithLanguage;


#pragma mark Init/Load Methods

- (void)loadView {
    [super loadView];
  
    //create search bar
	searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake( 0, 0, self.view.bounds.size.width, 44)];
	searchBar.delegate = self;
	searchBar.barStyle = UIBarStyleDefault;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//create a search controller
	searchController = [[UISearchDisplayController alloc] initWithSearchBar: searchBar contentsController: self];
	searchController.delegate = self;
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;	
    searchController.searchResultsTableView.opaque = YES;
    searchController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
	searchBar.delegate = self;
	
	//add the searchbar to the table
	tableView.tableHeaderView = searchBar;
	
	if( self.searchWasActive )
	{
		[self.searchDisplayController setActive: YES];
        [self.searchDisplayController.searchBar setText: self.savedSearchTerm];
		
		searchWasActive = NO;
	}    
    
	//set initial scroll value to hide the search bar
	[tableView setContentOffset: CGPointMake(0, searchBar.frame.size.height) ];
    
	//set background header color
	[tableView setValue: [UIColor tableHeaderBackgroundColor] forKey: @"tableHeaderBackgroundColor"];	    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
	
	//If we are the child of a navigation contorller, save it for when we leave
	UINavigationController *navController = self.parentViewController.navigationController;
	if( navController == nil ) navController = self.navigationController;
	self.parentNavigationController = navController;
	
    if( [self.searchController isActive] )
    {
        if( parentNavigationController )
            [parentNavigationController setNavigationBarHidden:YES animated:animated];
    }
    
    if( lazyLoadImages )
        [self lazyLoadVisibleCellImages];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear: animated];

    if( [self.searchController isActive] )
    {
        if( parentNavigationController )
            [parentNavigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void) loadTableContentOnNewThread
{ 
	//if already loaded (or mid-load), don't reload
	if ( [self.tableEntries count] > 0 || self.isLoading == YES )
		return;

	self.isLoading = YES;
	
	//if a custom footer has been set, release it now
	self.tableView.tableFooterView = nil;
	
	//reset the section lists
	self.sectionHeaderEntries = nil;
	self.sectionHeaderTitles = nil;	
	self.sectionIndexTitles = nil;
	self.sectionIndexIndicies = nil;
	
    //load new table entries in new thread
	[self performSelectorInBackground: @selector(loadTableEntriesOnNewThread) withObject: nil];	
}

- (void)insertEntriesIntoTable
{
    [super insertEntriesIntoTable];
    
	//set background header color
	[tableView setValue: [UIColor tableHeaderBackgroundColor] forKey: @"tableHeaderBackgroundColor"];	   
    
    //if the search bar is active, refresh that table as well
    if( self.searchController.active )
    {
        [self searchListWithString: self.searchController.searchBar.text];
        [searchController.searchResultsTableView reloadData];
    } 
}

- (UITableView *)lazyLoadTableViewInFocus
{
    if( self.searchController.active )
        return self.searchController.searchResultsTableView;
    
    return tableView;
}

- (void)lazyLoadVisibleCellImagesOnNewThreadWithIconEntryData:(TCAsyncIconEntry *)iconEntryData
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    UITableView *_tableView = (UITableView *)[(TCAsyncIconEntry *)iconEntryData tableView];
    NSArray *visibleCellList = (NSArray *)[(TCAsyncIconEntry *)iconEntryData iconIndexData];
    
    for( NSIndexPath *indexPath in visibleCellList )
    {
        NSObject *entry = nil;
        
        //if the thread was terminated, cease execution (beyond this point will cause errors)
        if( [[NSThread currentThread] isCancelled] || [tableEntries count] == 0 )
        {
            [pool release];
            return;
        }
            
        //if the table view being loaded is the search table
        if( _tableView == self.searchController.searchResultsTableView )
        {
            //gotta be careful here. since the user can keep typing searches, it's
            //possible the list of entries can change on top of us
            if( indexPath.row >= [tableSearchedEntries count] )
            {
                [pool release];
                return;
            }
            
            entry = [[self.tableSearchedEntries objectAtIndex: indexPath.row] retain];
        }
        else //else it's the main table
        {    
            if( [sectionHeaderTitles count] )
                entry = [[[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row] retain];
            else
                entry = [[tableEntries objectAtIndex: indexPath.row] retain];
        }
        
        if( entry && [self cellImageisLoadedWithDataSourceEntry: entry] == NO )
        {
            @synchronized(self) {
                [self loadCellImageWithDataSourceEntry: entry];
                numLazyLoadedImages++;
                
                //send the sub class the needed data to refresh the target cell
                TCAsyncIconEntry *iconData = [TCAsyncIconEntry asyncIconEntryWithTableView: _tableView indexData: indexPath tableEntry: entry];
                [self performSelectorOnMainThread: @selector(reloadTableCellContentViewWithIconEntryData:) withObject: iconData waitUntilDone: YES];
            }
        }
        
        [entry release];
    }

    [pool release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
	
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
}

- (void)viewDidUnload {
	self.searchBar = nil;

	[super viewDidUnload];
}

- (void)dealloc {
	[parentNavigationController release];
	[searchBar release];
	[tableSearchedEntries release];
	[searchController release];	
	
    [super dealloc];
}

#pragma mark Search
-(void) searchListWithString: (NSString *)searchString
{
	//abstract
}

-(void) performFilter
{
	//if the search table is visible, reset that too
	if( searchController.active )
	{
		self.tableSearchedEntries = nil;
		[searchController.searchResultsTableView reloadData];
	}
	
	[super performFilter];
}


#pragma mark UITableView Delegate Methods
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)_tableView
{
	if( _tableView == searchController.searchResultsTableView )
		return nil;
	
	return [super sectionIndexTitlesForTableView: _tableView];
}

- (NSInteger)tableView:(UITableView *)_tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	//search
	if (index == 0 || _tableView == searchController.searchResultsTableView ) {
        [_tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
	
	//if manual table placement has been specified
	if( sectionIndexIndicies != nil )
	{
		NSInteger numberOffset = [[sectionIndexIndicies objectAtIndex: index-1] intValue];
		[_tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: numberOffset inSection: 0 ] atScrollPosition: UITableViewScrollPositionTop animated:NO ];
	}
	
    if( lazyLoadImages )
        [self lazyLoadVisibleCellImages];    
    
	return index-1;	
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	//if table is the search table
	if( _tableView == searchController.searchResultsTableView )
		return [tableSearchedEntries count];
	else 
		return [super tableView: _tableView numberOfRowsInSection: section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
	if( _tableView == searchController.searchResultsTableView )
		return 1;
	
	return [super numberOfSectionsInTableView: _tableView];
}

- (NSString *)tableView:(UITableView *)_tableView titleForHeaderInSection:(NSInteger)section
{
	if( _tableView == searchController.searchResultsTableView || [self sectionHeadersAreVisible] == NO )
		return nil;
	
	return [super tableView: _tableView titleForHeaderInSection: section];
}

- (UITableViewCell *)tableView: (UITableView *)_tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
	UITableViewCell	*cell = [super tableView: _tableView cellForRowAtIndexPath: indexPath];
	
	if( _tableView == searchController.searchResultsTableView == NO && [self sectionIndexIsVisible] )
	{
		//if the scroll index view is visible, resize the content view to remove the padding
		CGRect contentFrame = cell.contentView.frame;
		contentFrame.size.width += 5;
		cell.contentView.frame = contentFrame;
	}
		
	return cell;
}

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchListWithString: searchString];
	
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    //if the section index is visible, reload the visible rows since auto-rotation can mess up the cell width while
    //the index is hidden
    if( [self sectionIndexIsVisible] )
        [self.tableView reloadRowsAtIndexPaths: [tableView indexPathsForVisibleRows] withRowAnimation: UITableViewRowAnimationNone];
}

@end

