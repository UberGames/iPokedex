//
//  MoveListViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 28/12/10.
//  Copyright 2010 UberGames. All rights reserved.
//

#define SORT_GEN		0
#define SORT_TYPE		1
#define SORT_CATEGORY	2

#define ORDER_NAME		0
#define ORDER_POWER		1
#define ORDER_PP		2

#import "UIImage+TabIcon.h"
#import "TCTableViewCell.h"
#import "MoveListViewController.h"
#import "MoveProfileTabController.h"
#import "MoveTableCellContentView.h"
#import "ElementalTypes.h"
#import "MoveCategories.h"
#import "Generations.h"
#import "UIViewController+TagTitle.h"

@implementation MoveListViewController

@synthesize moveFinder, elementalTypes, generations, moveCategories, sortOrder, searchEntryCaption, entryCaption;

#pragma mark -
#pragma mark View lifecycle

- (id)init
{
    if( (self = [super init]) )
    {
        self.tableCellIdentifier = @"moveTableCell";
        
        self.tabBarItem.title = NSLocalizedString(@"Moves", @"");
        self.tabBarItem.image = [UIImage tabIconWithName: @"Moves"];        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Moves", @"");
    self.footerCountMessage = NSLocalizedString( @"%d Moves", nil );
    self.footerCountMessageSingular = NSLocalizedString( @"%d Move", nil );
    
	//add an array to handle the 'order' portion of the scroller
	sortTitles = [[NSArray alloc] initWithObjects: NSLocalizedString( @"Gen.",nil ), NSLocalizedString( @"Type", nil ), NSLocalizedString( @"Category", nil ), nil];
	sortOrder = [[NSArray alloc] initWithObjects: NSLocalizedString( @"Name", nil), NSLocalizedString( @"Power", nil ), NSLocalizedString( @"PP", nil ), nil ];
	
	//load the elemental types
	if( elementalTypes == nil )
		self.elementalTypes = [ElementalTypes typesFromDatabaseWithIcons: YES];			
	
	if( moveCategories == nil )
		self.moveCategories = [MoveCategories categoriesFromDatabaseWithIcons:YES];	
	
	//load the generations
	if ( self.generations == nil )
		self.generations = [Generations generationsFromDatabase];	
	
	if( moveFinder == nil )
    {
		moveFinder = [[MoveEntryFinder alloc] init];
        
        //load the default generation
        NSNumber *defaultGen = [[NSUserDefaults standardUserDefaults] objectForKey: @"defaultGeneration"];
        if( defaultGen != nil )
        {
            moveFinder.generationID = [defaultGen intValue];
            
            //flip the gen index for the list menu
            if( moveFinder.generationID > 0 )
            {
                NSInteger genIndex = -moveFinder.generationID + ([generations count]+1);
                [self setSortIndex: genIndex forRow: SORT_GEN];
            }
        }
    }    
    
	//create a sorting button
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString( @"Sort", nil ) style: UIBarButtonItemStyleBordered target: self action: @selector(showFilterDialog)];
    self.navigationItem.rightBarButtonItem = button;
	[button release];
}

- (NSArray *) loadTableContent
{
	//load the list of moves from the DB
	NSMutableArray *entries = [moveFinder entriesFromDatabase];		
	
	//insert references to the icons in each entry now
	for( MoveListEntry *move in entries )
	{
		move.typeIcon = [(ElementalType *)[elementalTypes objectForKey: [NSNumber numberWithInt: move.elementalTypeID]] icon];
		move.categoryIcon = [(MoveCategory *)[moveCategories objectForKey: [NSNumber numberWithInt: move.categoryID]] icon];
	}

	return entries;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[sortOrder release];
	[moveFinder release];
	[elementalTypes release];
	[generations release];
	[moveCategories release];
	
    [super dealloc];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if( component == SORT_GEN )
	{
		//default value
		if( row == 0 )
		{
			return NSLocalizedString( @"All", nil );
		}
		else
		{
            //invert the generation
            NSInteger genId = -row + ([generations count]+1);
			Generation *gen = [generations objectForKey: [NSNumber numberWithInt: genId]];
			return gen.name;
		}
	}
	else if ( component == SORT_TYPE )
	{
		//default value
		if( row == 0 )
		{
			return NSLocalizedString( @"All", nil );
		}
		else
		{
			ElementalType *type = [elementalTypes objectForKey: [NSNumber numberWithInt: row]];
			return type.name;
		}
	}
	else if( component == SORT_CATEGORY )
	{
		if( row == 0 )
		{
			return NSLocalizedString( @"All", nil );
		}
		else {
			return [[moveCategories objectForKey: [NSNumber numberWithInt: row]] name];
		}

	}
	
	return nil;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if( component == SORT_GEN )
	{
		return [self.generations count]+1;
	}
	else if ( component == SORT_TYPE )
	{
		return [self.elementalTypes count]+1;
	}
	else if( component == SORT_CATEGORY )
	{
		return [self.moveCategories count]+1;
	}
	
	return 0;
}

-(void) performFilter
{
	[moveFinder reset];
	
	//set search filter parameters
    NSInteger genId = [(NSNumber *)[sortRows objectForKey: [NSNumber numberWithInt: SORT_GEN]] intValue ];
    if( genId > 0 )
        genId = -genId + ([generations count] + 1);
    
	moveFinder.generationID = genId;
	moveFinder.typeID = [(NSNumber *)[sortRows objectForKey: [NSNumber numberWithInt: SORT_TYPE]] intValue ];
	moveFinder.categoryID = [(NSNumber *)[sortRows objectForKey:  [NSNumber numberWithInt: SORT_CATEGORY]] intValue ];
	moveFinder.sortedOrder  = MoveFinderSortByName;
	
	//perform the filter
	[super performFilter];
}

-(BOOL) sectionIndexIsVisible
{
	return ( [tableEntries count] > 25 );
}

-(BOOL) sectionHeadersAreVisible
{
	return (moveFinder.sortedOrder == MoveFinderSortByName && [tableEntries count] > 20 );
}

-(void) buildSectionHeaders
{
	NSDictionary *sectionEntries = [EntryFinder alphabeticalSectionEntryListWithEntries: tableEntries];
	self.sectionHeaderTitles = [EntryFinder alphabeticalSectionHeaderTitleListWithDictionary: sectionEntries];
	self.sectionHeaderEntries = [EntryFinder alphabeticalSectionHeaderEntryListWithDictionary: sectionEntries titleList: self.sectionHeaderTitles];
}

-(void) buildSectionIndex
{
	//bit of a hack, but since it's the same content, we can make it a tad more efficient by sharing
	self.sectionIndexTitles = [EntryFinder alphabeticalSectionIndexTitleListWithSectionHeaderTitleList: self.sectionHeaderTitles search: YES];
}


#pragma mark -
#pragma mark Table view data source

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	TCTableViewCell *cell = (TCTableViewCell *)[super tableView: _tableView cellForRowAtIndexPath: indexPath];	
	BOOL isSearch = ( _tableView == searchController.searchResultsTableView );
	BOOL sectionIndex = [self sectionIndexIsVisible];
	
	if( isSearch || sectionIndex == NO )
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	    
    
    if( cell.drawView == nil )
        cell.drawView = [[[MoveTableCellContentView alloc] initWithFrame: cell.contentView.bounds] autorelease];
    
	MoveListEntry *move;
	if( isSearch )
	{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		move = [tableSearchedEntries objectAtIndex: indexPath.row];
	}
	else
	{
		if( [self sectionHeadersAreVisible] )
			move = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
		else
			move = [tableEntries objectAtIndex: indexPath.row];
	}
	
	//create the content view
	MoveTableCellContentView *contentView = (MoveTableCellContentView *)cell.drawView;
	
	contentView.title = move.name;
	contentView.powerValue = move.powerValue;
	contentView.accuracyValue = move.accuracyValue;
	contentView.PPValue = move.PPValue;
	
	contentView.typeImage = move.typeIcon;
	contentView.categoryImage = move.categoryIcon;
	
	//depending on search results or standard, change the caption text as needed
	if( isSearch && searchWasWithLanguage )
		contentView.subTitle = move.nameAlt;
    else
        contentView.subTitle = nil;
    
    //if this is a search cell, we'll need to manually redraw it
    [contentView setNeedsDisplay];
    
	return cell;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];
	
	MoveListEntry *move;
	
	if( _tableView == self.searchController.searchResultsTableView )
	{
		move = (MoveListEntry *)[self.tableSearchedEntries objectAtIndex: indexPath.row];
	}
	else
	{
		if( [self sectionHeadersAreVisible] )
			move = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row ];
		else
			move = (MoveListEntry *)[self.tableEntries objectAtIndex: indexPath.row];
	}
	
	MoveProfileTabController *moveController = [[MoveProfileTabController alloc] initWithDatabaseID: move.dbID moveEntry: move ]; 
	[self.parentViewController.navigationController pushViewController: moveController animated: YES ];
	[moveController release];
}

#pragma mark - 
#pragma mark Tag Title
- (NSString *)tagTitle
{
    return @"Moves";
}

@end

