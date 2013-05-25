//
//  TCListViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 12/01/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "UIColor+CustomColors.h"
#import "TCListViewController.h"
#import "TCTableViewCell.h"
#import "UIDevice+Hardware.h"

#import <QuartzCore/QuartzCore.h>

#define MAX_LAZY_IMAGES 100

@implementation TCListViewController

@synthesize isLoading, 
            deferIconLoading,
			imagesLoaded,
			tableEntries,
			tableCellIdentifier, 
			tableView,
			loadingActivityView, 
			noResultsLabel,
			noResultsMessage,
			footerView, 
			footerCountMessage, 
			footerCountMessageSingular, 
			footerViewCountLabel,
			sectionIndexTitles,
			sectionIndexIndicies,
			sectionHeaderEntries, 
			sectionHeaderTitles,
            noLoadOnInit,
            editButton,
            tableMessage,
            tableMessageLabel;

- (void)loadView {
    [super loadView];

  	//create main tableview
	tableView = [[UITableView alloc] initWithFrame: self.view.frame];
    tableView.opaque = YES;
    tableView.backgroundColor = [UIColor whiteColor];
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth);
	tableView.dataSource = self;
	tableView.delegate = self;  
    
    //add the table to the view
	self.view = tableView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    self.noResultsMessage = NSLocalizedString(@"No Results", nil);
    
    //enable lazy loading images if we're on 2nd gen or less iPhone/iPod
    if( ([[UIDevice currentDevice] platformType] >= UIDevice1GiPhone && [[UIDevice currentDevice] platformType] <= UIDevice3GiPhone ) //iPhone
       ||
       ([[UIDevice currentDevice] platformType] >= UIDevice1GiPod && [[UIDevice currentDevice] platformType] <= UIDevice2GiPod ) ) //iPod
    {
        lazyLoadImages = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];

	//load the content from the child class
    if( noLoadOnInit == NO )
        [self loadTableContentOnNewThread];
	
    if( deferIconLoading )
    {
        //if the images in the cells were unloaded to save memory, reload them here
        if( lazyLoadImages == NO && imagesLoaded == NO && [tableEntries count] > 0 )
            [self loadCellImagesOnNewThread];
        
        //force the initial visible cells to load their icons
        if( lazyLoadImages == YES )
            [self lazyLoadVisibleCellImages];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark Memory Management
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    /*if( [tableEntries count] )
    {
        self.tableEntries = nil;
    }*/
}

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
	self.footerViewCountLabel = nil;
	self.noResultsLabel = nil;
	self.loadingActivityView = nil;
    self.tableView = nil;
}

- (void)dealloc {
	[footerViewCountLabel release];
	[footerCountMessage release];
	[footerCountMessageSingular release];
	[noResultsLabel release];
	[loadingActivityView release];	
	[tableView release];
	[tableEntries release];
    [lazyLoadTimer release];
    [loadIconThread release];
    
    [super dealloc];
}

#pragma mark Subclass Override Methods
- (NSArray *) loadTableContent
{
	//abstract class for children to load their own content in this view on init
	return nil;
}

- (BOOL) cellImageisLoadedWithDataSourceEntry: (id)dataSourceEntry
{
    return YES;
}

-(UIImage *) loadCellImageWithDataSourceEntry: (id)dataSourceEntry
{
	//child subclass
	return nil;
}

#pragma mark Multithreaded LoadingCode
- (void) loadTableContentOnNewThread
{ 
	//if already loaded (or is currently reloading on another thread), don't reload
	if ( [tableEntries count] > 0 || self.isLoading == YES )
		return;
	
	self.isLoading = YES;
	
	//if a custom footer has been set, release it now
	self.tableView.tableFooterView = nil;
	
	//reset the section index lists
	self.sectionIndexTitles = nil;
	self.sectionIndexIndicies = nil;
	//reset the section header titles
	self.sectionHeaderTitles = nil;
	self.sectionHeaderEntries = nil;

	//Load the Entry in a new thread
	[self performSelectorInBackground: @selector(loadTableEntriesOnNewThread) withObject: nil];	
}

- (void)loadTableEntriesOnNewThread
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    //ping the child class to load its table content
    NSArray *entries = [self loadTableContent];
    self.tableEntries = [NSMutableArray arrayWithArray: entries]; 
    
    //if the table needs to display section headers, set them up now
    if( [self sectionHeadersAreVisible] )
        [self buildSectionHeaders];		
    
    //if the table is going to display a section index scrollbar, set up the parms now
    if( [self sectionIndexIsVisible] )
        [self buildSectionIndex];
    
    [self performSelectorOnMainThread: @selector(insertEntriesIntoTable) withObject: nil waitUntilDone: YES];
    
    [pool release];
}

- (void)insertEntriesIntoTable
{
    //hide the loading indicator
    self.isLoading = NO;
    
    //update the table with the new content
    [self updateTableFooterView];
    [tableView reloadData];
    
    if( [tableEntries count] > 0 )
        self.editButton.enabled = YES;
    else
        self.editButton.enabled = NO;
    
    //if section headers are visible, set the background of the table
    //set background header color
    if( [self sectionHeadersAreVisible] && [tableEntries count] > 0 )
        [tableView setValue: [UIColor tableHeaderBackgroundColor] forKey: @"tableHeaderBackgroundColor"];
    else
        [tableView setValue: nil forKey: @"tableHeaderBackgroundColor"];
    
    //If we're not loading, start loading them all now
    if( deferIconLoading )
    {
        if( lazyLoadImages == NO )
        {
            //flush out the thread entry if needed
            if( loadIconThread )
            {
                [loadIconThread cancel];
                [loadIconThread release];
                loadIconThread = nil;
            }
            
            //spawn the thread and execute
            loadIconThread = [[NSThread alloc] initWithTarget: self selector: @selector(loadCellImagesOnNewThread) object: nil];
            [loadIconThread start];
        }
        else //attach a timer to automatically check for icons to load every half-second
        {
            lazyLoadTimer = [[NSTimer scheduledTimerWithTimeInterval: 0.5f target: self selector: @selector(lazyLoadVisibleCellImages) userInfo: nil repeats: YES] retain];
            [lazyLoadTimer fire];
        }
    }
}

- (void) reloadTableContent
{
    //if the thread is currently loading images, cancel
    if( loadIconThread )
    {
        [loadIconThread cancel];
        [loadIconThread release];
        loadIconThread = nil;
    }
    
	//remove all data from the main table
	self.tableEntries = nil;
	
	//reset the section index lists
	self.sectionIndexTitles = nil;
	self.sectionIndexIndicies = nil;
	//reset the section header titles
	self.sectionHeaderTitles = nil;
	self.sectionHeaderEntries = nil;	
	
    //flush out the table view
	[tableView reloadData];
    
    //reload the table data
	[self loadTableContentOnNewThread];
}


- (void) loadCellImagesOnNewThread
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    //set up the list of objects to iterate through
    NSArray *entrySectionList = nil;
    
    //if the entrylist has been divided into sections, 
    //iterate through each section, if it isn't, just
    //create a dummy section for the primary list
    if( [sectionHeaderEntries count] > 0 )
    {
        entrySectionList = sectionHeaderEntries;
    }
    else
    {
        entrySectionList = [NSArray arrayWithObject: tableEntries];
    }
    
    //loop through each iteration, generating the indexPath off the
    //section/row indices
    NSInteger sectionIndex = 0;
    for( NSArray *sectionEntries in entrySectionList )
    {
        NSInteger rowIndex = 0;
        for( NSObject *entry in sectionEntries )
        {
            //check the thread hasn't been terminated
            if( [[NSThread currentThread] isCancelled] )
            {
                [pool release];
                return;
            }
            
            //hang on to the entry, in case a refresh catches this thread mid-execution
            [entry retain];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow: rowIndex inSection: sectionIndex];
            
            //get the child class to load the image
            [self loadCellImageWithDataSourceEntry: entry];
            
            TCAsyncIconEntry *iconEntry = [TCAsyncIconEntry asyncIconEntryWithTableView: self.tableView indexData: indexPath tableEntry: entry];
            
            //see if this one is visible and reload as needed
            [self performSelectorOnMainThread: @selector(reloadTableCellContentViewWithIconEntryData:) withObject: iconEntry waitUntilDone: YES];
        
            rowIndex++;
            
            //release the entry
            [entry release];
        }
        
        sectionIndex++;
    }
        
    imagesLoaded = YES;

    [pool release];
}

//Set which table gets load priority (in the case of superimposed tables like search bars)
- (UITableView *)lazyLoadTableViewInFocus
{
    return tableView;
}

- (void)lazyLoadVisibleCellImages
{
    if ( self.view.superview == nil ) 
        return;
    
    UITableView *targetTable = [self lazyLoadTableViewInFocus];
    NSArray *visibleCells = [targetTable indexPathsForVisibleRows];
    
    if( visibleCells == nil || targetTable.decelerating || targetTable.dragging )
        return;
    
    if( loadIconThread && [loadIconThread isExecuting] )
        return;
    
    //to prevent a memory blowout, flush out all of the images once we go over the limit
    if( numLazyLoadedImages + [visibleCells count] > MAX_LAZY_IMAGES )
    {
        [self unloadImages];
        numLazyLoadedImages = 0;
    }
    
    TCAsyncIconEntry *loadData = [TCAsyncIconEntry asyncIconEntryWithTableView: targetTable indexData: visibleCells tableEntry: nil];
    
    if( loadIconThread )
    {
        [loadIconThread release];
        loadIconThread = nil;
    }
    
    loadIconThread = [[NSThread alloc] initWithTarget: self selector: @selector(lazyLoadVisibleCellImagesOnNewThreadWithIconEntryData:) object: loadData];
    [loadIconThread start];
}

- (void)lazyLoadVisibleCellImagesOnNewThreadWithIconEntryData:(TCAsyncIconEntry *)iconEntryData
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    for( NSIndexPath *indexPath in (NSArray *)iconEntryData.iconIndexData )
    {
        NSObject *entry = nil;
    
        //if the thread was terminated, cease execution (beyond this point will cause errors)
        if( [[NSThread currentThread] isCancelled] || [tableEntries count] == 0 )
        {
            [pool release];
            return;
        }
        
        //NB retain the entry for the duration of loading the icon so if tableEntries gets pulled out from under
        //us in a different thread, the app won't crash
        if( [sectionHeaderTitles count] )
            entry = [[[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row] retain];
        else
            entry = [[tableEntries objectAtIndex: indexPath.row] retain];
        
        if( entry && [self cellImageisLoadedWithDataSourceEntry: entry] == NO )
        {
            @synchronized(self) {
                [self loadCellImageWithDataSourceEntry: entry];
                numLazyLoadedImages++;
            
                TCAsyncIconEntry *iconEntry = [TCAsyncIconEntry asyncIconEntryWithTableView: tableView indexData: indexPath tableEntry: entry];
                
                [self performSelectorOnMainThread: @selector(reloadTableCellContentViewWithIconEntryData:) withObject: iconEntry waitUntilDone: YES];
            }
        }
        
        [entry release];
    }
    
    [pool release];
}

- (void) reloadTableCellContentViewWithIconEntryData:(TCAsyncIconEntry *)iconEntryData
{
    //abstract
}

- (void)unloadImages
{
    //abstract
}
         
#pragma mark TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if( sectionHeaderEntries != nil )
		return [sectionHeaderEntries count];
	
	// Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)_tableView titleForHeaderInSection:(NSInteger)section
{
	if( [self.sectionHeaderTitles count] > 0 )
	{			
		return (NSString *)[sectionHeaderTitles objectAtIndex: section];
	}
		
	return nil;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	if( tableEntries == nil )
		return 0;
	
	if( [sectionHeaderEntries count] > 0 )
		return [(NSArray *)[sectionHeaderEntries objectAtIndex: section] count];
	else
		return [tableEntries count];
}

- (UITableViewCell *)tableView: (UITableView *)_tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
	//set up a default cell by default and return it
	TCTableViewCell *cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier: self.tableCellIdentifier];
	if (cell == nil) {
		cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: self.tableCellIdentifier] autorelease];
		cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.contentView.frame = CGRectInset(cell.bounds, 1.0f, 1.0f);
        //set up the image
        cell.imageView.opaque = YES;
        cell.imageView.backgroundColor = [UIColor whiteColor];
    }	
    
	return cell;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark Section Index Display
-(BOOL) sectionIndexIsVisible
{
	return NO;
}

-(void) buildSectionIndex
{
	//override for child
}

-(BOOL) sectionHeadersAreVisible
{
	return NO;
}

-(void) buildSectionHeaders
{
	//override for child
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	
	if( [self sectionIndexIsVisible] == NO )
		return nil;
	
	return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)_tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	
	//top of the view
	if (index == 0) {
        [_tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
	
	//if manual table placement has been specified
	if( sectionIndexIndicies != nil )
	{
		NSInteger numberOffset = [[sectionIndexIndicies objectAtIndex: index] intValue];
		[_tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: numberOffset inSection: 0 ] atScrollPosition: UITableViewScrollPositionTop animated:NO ];
	}
    
	return index;	
}

#pragma mark Loading Visual Feedback

- (void) setIsLoading: (BOOL)loading
{
	
	if( isLoading == loading )
		return;
	
	isLoading = loading;
	
	NSInteger cellHeight = tableView.rowHeight;
	
	//If we started loading, add a scroller to the 2nd cell (ala the search controller)
	if( isLoading == YES )
	{
        //if no results was previously being shown, remove it
        if( noResultsLabel != nil )
        {
            [noResultsLabel removeFromSuperview];
            self.noResultsLabel = nil;
        }        
        
		if( loadingActivityView == nil )
		{
			loadingActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
			loadingActivityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
			loadingActivityView.center = CGPointMake( floor(tableView.bounds.size.width / 2), (2*cellHeight) + (cellHeight/2));
			
			[loadingActivityView startAnimating];
			[tableView addSubview: loadingActivityView];
		}
	}
	else 
	{
		//if a scroller was showing, remove it now
		if( loadingActivityView != nil )
		{
			[loadingActivityView removeFromSuperview];
			self.loadingActivityView = nil;
		}
		
		//all good, the table now has content, remove the 'no results' view (just in case)
		if( [tableEntries count] > 0 )
		{
            //if no results was previously being shown, remove it
            if( noResultsLabel != nil )
            {
                [noResultsLabel removeFromSuperview];
                self.noResultsLabel = nil;
            }		
		}
		else //the reload failed. display 'No results' 
		{
			noResultsLabel = [[UILabel alloc] initWithFrame: CGRectZero];
			noResultsLabel.autoresizingMask = loadingActivityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
			noResultsLabel.text = noResultsMessage;
			noResultsLabel.textAlignment = UITextAlignmentCenter;
			noResultsLabel.textColor = [UIColor grayColor];
			noResultsLabel.font = [UIFont boldSystemFontOfSize: 20.0f];
			CGSize size = [noResultsLabel.text sizeWithFont: noResultsLabel.font];
			noResultsLabel.frame = CGRectMake( floor((tableView.bounds.size.width/2) - (size.width/2)), 
												floor((cellHeight*2) + ((cellHeight/2)-(size.height/2))),
												size.width, size.height );
			
			[tableView addSubview: noResultsLabel];
		}

	}
}

#pragma mark Edit Button accessor method
-(UIBarButtonItem *)editButton
{
    if( editButton == nil )
        editButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString( @"Edit", @"Menu bar Edit") style: UIBarButtonItemStylePlain  target: self action: @selector( editButtonTapped: )];
    
    return editButton;
}

#pragma mark Edit Button callback
- (void) editButtonTapped:(id)sender
{	
    if(self.tableView.editing)
    {
        [self.tableView setEditing: NO animated: YES];
        
        editButton.style = UIBarButtonItemStylePlain;
        editButton.title = NSLocalizedString( @"Edit", @"Menu bar Done");
    }
    else
    {
        [self.tableView setEditing: YES animated: YES];
		
        editButton.style = UIBarButtonItemStyleDone;
        editButton.title = NSLocalizedString( @"Done", @"Menu bar Done");
    }
}

#pragma mark Footer View Label Code
- (void)setFooterCountMessage: (NSString *)message
{
	if( message == footerCountMessage )
		return;
	
	[footerCountMessage release];
	footerCountMessage = [message retain];
	
	if( footerView == nil )
		[self initTableFooterView];
	
	[self updateTableFooterView];
}
	   
- (void)setFooterCountMessageSingular: (NSString *)message
{
	if( message == footerCountMessageSingular )
		return;
	
	[footerCountMessageSingular release];
	footerCountMessageSingular = [message retain];
	
	if( footerView == nil )
		[self initTableFooterView];
	
	[self updateTableFooterView];
}

- (void)initTableFooterView
{
	//init the footer view
	footerView = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, tableView.bounds.size.width, 42 )];
	footerView.backgroundColor = [UIColor whiteColor];
	footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	//add the label to the view
	footerViewCountLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, footerView.bounds.size.width, 21 )];
	footerViewCountLabel.font = [UIFont systemFontOfSize: 20.0f];
	footerViewCountLabel.backgroundColor = [UIColor whiteColor];
	footerViewCountLabel.textAlignment = UITextAlignmentCenter;
	footerViewCountLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	footerViewCountLabel.textColor = [UIColor grayColor];
	footerViewCountLabel.center = CGPointMake( 160, 21.5f);
	[footerView addSubview: footerViewCountLabel];
}

- (void)updateTableFooterView
{
	if (footerCountMessage == nil || [footerCountMessage length] == 0) 
		return;
	
	if( tableEntries == nil || [tableEntries count] == 0 )
	{
		tableView.tableFooterView = nil;
	}
	else 
	{
		if( [footerCountMessageSingular length] && [tableEntries count] == 1 )
			footerViewCountLabel.text = [NSString stringWithFormat: footerCountMessageSingular, [tableEntries count]];
		else	
			footerViewCountLabel.text = [NSString stringWithFormat: footerCountMessage, [tableEntries count]];
		
		tableView.tableFooterView = footerView;
	}
}

#pragma mark Table Header Message delegate
- (void)setTableMessage:(NSString *)_tableMessage
{
    if( [_tableMessage isEqualToString: tableMessage] )
        return;
    
    //set the new string
    [tableMessage release];
    tableMessage = [_tableMessage retain];
    
    //if the new string is nil, remove the label
    if( [tableMessage isEqualToString: @""] )
    {
        if( tableMessageLabel != nil )
        {
            [tableMessageLabel removeFromSuperview];
            [tableMessageLabel release];
            tableMessageLabel = nil;
        }
        
        return;
    }
    
    //init the label
    if( tableMessageLabel == nil )
        [self initTableMessageView];
    
    //update with the text
    [self updateTableMessageView];
}

- (void)initTableMessageView
{
    tableMessageLabel = [[UILabel alloc] initWithFrame: CGRectMake( 0, 0, 220, 100)];
    tableMessageLabel.numberOfLines = 0;
	tableMessageLabel.font = [UIFont boldSystemFontOfSize: 13.0f];
	tableMessageLabel.backgroundColor = [UIColor clearColor];
	tableMessageLabel.textAlignment = UITextAlignmentCenter;
    tableMessageLabel.lineBreakMode = UILineBreakModeWordWrap;
	tableMessageLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	tableMessageLabel.textColor = [UIColor blackColor];
    tableMessageLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    tableMessageLabel.shadowColor = [UIColor whiteColor];
    tableMessageLabel.alpha = 0.5;
	[self.tableView addSubview: tableMessageLabel];
}

- (void)updateTableMessageView
{ 
    CGSize textSize = [tableMessage sizeWithFont: tableMessageLabel.font constrainedToSize: CGSizeMake( tableMessageLabel.frame.size.width, NSIntegerMax) lineBreakMode: tableMessageLabel.lineBreakMode];
    CGRect drawRect;
    
    drawRect.origin.x       = (self.view.frame.size.width/2) - 110;
    drawRect.origin.y       = -(textSize.height + 15);
    drawRect.size.width     = 220.0f;
    drawRect.size.height    = textSize.height;
 
    tableMessageLabel.frame = drawRect;
    tableMessageLabel.text = tableMessage;
}

#pragma mark -
#pragma mark UIScrollView Delegate Events
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if( lazyLoadImages == NO )
        return;
    
    [self lazyLoadVisibleCellImages];   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( lazyLoadImages == NO )
        return;
    
    if (!decelerate)
	{
        [self lazyLoadVisibleCellImages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( lazyLoadImages == NO )
        return;
    
    [self lazyLoadVisibleCellImages];
}

@end

/*Transient object to hold all of the data necessary to ansyncronously refresh one or more table cells*/
@implementation TCAsyncIconEntry

@synthesize tableView, iconIndexData, tableEntry;

- (id)initWithTableView: (UITableView *)_tableView indexData: (NSObject *)_indexData tableEntry: (NSObject *)entry
{
    if( (self = [super init]) )
    {
        self.tableView = _tableView;
        self.iconIndexData = _indexData;
        self.tableEntry = entry;
    }
    
    return self;
}

+ (TCAsyncIconEntry *)asyncIconEntryWithTableView: (UITableView *)_tableView indexData: (NSObject *)_indexData tableEntry: (NSObject *)entry
{
    return [[[self alloc] initWithTableView: _tableView indexData: _indexData tableEntry: entry] autorelease];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"%@ %@ %@", tableView, iconIndexData, tableEntry];
}

- (void)dealloc
{
    [super dealloc];
    
    [iconIndexData release];
}

@end
