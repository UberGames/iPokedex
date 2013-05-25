//
//  PokemonTabViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 18/11/10.
//  Copyright 2010 UberGames. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "PokemonListViewController.h"

#import "PokemonProfileTabController.h"
#import "TCSearchableListViewController+ListEntryFinder.h"
#import "TCTableViewCell.h"
#import "UIImage+TabIcon.h"
#import "ElementalTypes.h"
#import "Regions.h"
#import "TableCellContentView.h"
#import "PokemonTableCellContentView.h"
#import "UIViewController+TagTitle.h"
#import "UIImage+ImageLoading.h"

#define SORT_REGION 0
#define SORT_TYPE 1
#define SORT_ORDER 2

#define ORDER_DEX 0
#define ORDER_ALPHA 1


@implementation PokemonListViewController

@synthesize pokemonFinder, types, regions, sortOrder, entryCaption, searchEntryCaption, defaultIcon;

#pragma mark -
#pragma mark View lifecycle

- (id)init
{
    if( (self = [super init]) )
    {
        //set this view's title
        self.tableCellIdentifier = @"PokemonEntryCell";	
        self.tabBarItem.title = NSLocalizedString(@"Pokémon", @"Nav Title");
        self.tabBarItem.image = [UIImage tabIconWithName: @"Pokeball" ];
        
        //let the controller know to load each cell's icon on a separate thread
        self.deferIconLoading = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Pokémon", @"Nav Title");        
    self.footerCountMessage = NSLocalizedString( @"%d Pokémon", nil );
    
	//get a list of regions for the sort menu
	if( regions == nil )
    {
		self.regions = [Regions regionsFromDatabase];
    }    
    
	//grab the main database and init the pokemon finder
	if( pokemonFinder == nil )
    {
		pokemonFinder = [[PokemonEntryFinder alloc] init];
        
        //load the default region from settings
        NSNumber *defaultRegion = [[NSUserDefaults standardUserDefaults] objectForKey: @"defaultRegion"];
        if( defaultRegion != nil )
        {
            //set the entry in the database finder
            pokemonFinder.dexId = [defaultRegion intValue];
        
            //now the regions are loaded, set the default list entry
            if( pokemonFinder.dexId > 0 )
            {
                NSInteger regionIndex = -pokemonFinder.dexId + ([regions count]+1);
                //update the sort list
                [self setSortIndex: regionIndex forRow: SORT_REGION];
            }   
        }
    }
	
	//add an array to handle the 'order' portion of the scroller
	self.isSortable = YES;
	sortTitles = [[NSArray alloc] initWithObjects: NSLocalizedString(@"Region", @""), NSLocalizedString(@"Type", @""), NSLocalizedString(@"Order", @""), nil];
	sortOrder = [[NSArray alloc] initWithObjects: NSLocalizedString(@"Dex. #",nil), NSLocalizedString(@"A-Z",nil), nil];
	
	//load a dummy image 
    if( lazyLoadImages )
        self.defaultIcon = [UIImage imageFromResourcePath: @"Images/Interface/PokeBall.png"];
    else
        self.defaultIcon = [UIImage imageFromResourcePath: @"Images/Pokemon/Small/0.png"];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Get realname mode
    BOOL realNameMode = [[NSUserDefaults standardUserDefaults] boolForKey: @"realNameMode"];
    
    if( realNameMode != smugleafMode )
    {
        [self reloadTableContent];
        smugleafMode = realNameMode;
    }
    
    [super viewWillAppear: animated];
}

- (NSArray *) loadTableContent
{
	//get a list of types for the menu
	if( types == nil )
		self.types = [ElementalTypes typesFromDatabaseWithIcons:YES];	
	
	//Load the Pokemon from the database
	NSArray *entries = [pokemonFinder entriesFromDatabase];
	
	//load icons from the types and assign them to each pokemon (faster than doing it on Cell load)
	for( PokemonListEntry *pokemon in entries )
	{
		if( pokemon.type1Id > 0 )
			pokemon.type1Icon = [(ElementalType *)[types objectForKey: [NSNumber numberWithInt: pokemon.type1Id]] icon];
								 
		if( pokemon.type2Id > 0 )
			pokemon.type2Icon = [(ElementalType *)[types objectForKey: [NSNumber numberWithInt: pokemon.type2Id]] icon];
	}

	return entries;
}

//load the pokemon icon
-(UIImage *) loadCellImageWithDataSourceEntry: (id)dataSourceEntry
{ 
    [(PokemonListEntry *)dataSourceEntry loadIcon];
	return [(PokemonListEntry *)dataSourceEntry icon];
}

- (BOOL) cellImageisLoadedWithDataSourceEntry: (id)dataSourceEntry
{
    return ([(PokemonListEntry *)dataSourceEntry icon]) != nil;
}

- (void) reloadTableCellContentViewWithIconEntryData:(TCAsyncIconEntry *)dataEntry
{    
    TCTableViewCell *cell = (TCTableViewCell *)[dataEntry.tableView cellForRowAtIndexPath: (NSIndexPath *)dataEntry.iconIndexData];
    if( cell == nil )
    {
        return;
    }
        
    PokemonTableCellContentView *pokemonView = (PokemonTableCellContentView *)cell.drawView;
    pokemonView.icon = [(PokemonListEntry* )dataEntry.tableEntry icon];
    [pokemonView setNeedsDisplay];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if( component == SORT_REGION )
	{
		//default value
		if( row == 0 )
		{
			return NSLocalizedString( @"National", nil );
		}
		else
		{
            NSInteger regionIndex = -row + ([regions count]+1); //invert the region index so it starts from the end
            
			Region *region = [self.regions objectForKey: [NSNumber numberWithInt: regionIndex]];
			return region.name;
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
			ElementalType *type = [self.types objectForKey: [NSNumber numberWithInt: row]];
			return type.name;
		}
	}
	else if( component == SORT_ORDER )
	{
		return (NSString *)[self.sortOrder objectAtIndex: row];
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
	if( component == SORT_REGION )
	{
		return [self.regions count]+1;
	}
	else if ( component == SORT_TYPE )
	{
		return [self.types count]+1;
	}
	else if( component == SORT_ORDER )
	{
		return [self.sortOrder count];
	}
		
	return 0;
}

#pragma mark Perform Refine Methods
-(void) performFilter
{
	[pokemonFinder reset];
	
	//set search filter parameters
    //flip the region id
    NSInteger dexId = [(NSNumber *)[sortRows objectForKey:  [NSNumber numberWithInt: SORT_REGION]] intValue ];
    if (dexId > 0 )
        dexId = -dexId + ([regions count]+1);
    
    pokemonFinder.dexId = dexId;
	pokemonFinder.typeId = [(NSNumber *)[sortRows objectForKey: [NSNumber numberWithInt: SORT_TYPE]] intValue ];
	
	//set sort order
	NSInteger order = [(NSNumber *)[sortRows objectForKey:  [NSNumber numberWithInt: SORT_ORDER]] intValue ];
	
	if( order <= ORDER_DEX )
		pokemonFinder.sortedOrder = PokemonFinderSortByNumber;
	else 
		pokemonFinder.sortedOrder  = PokemonFinderSortByName;

	//perform the filter
	[super performFilter];
}

#pragma mark -
#pragma mark Table View data source

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	//generate a cell from the class parent
	TCTableViewCell *cell = (TCTableViewCell *)[super tableView: _tableView cellForRowAtIndexPath: indexPath];	
	BOOL isSearch = ( _tableView == searchController.searchResultsTableView );
	BOOL sectionHeaders = [self sectionHeadersAreVisible];
	BOOL sectionIndex = [self sectionIndexIsVisible];
    
	if( isSearch || sectionIndex == NO )
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
    if( cell.drawView == nil )
        cell.drawView = [[[PokemonTableCellContentView alloc] initWithFrame: cell.contentView.bounds] autorelease];
    
	//get the list of entries either from the search table, or from the main one
	NSArray *entries;
	if( isSearch )
		entries = tableSearchedEntries;
	else
		entries = tableEntries;	
	
	PokemonListEntry *pokemon;
	//use that list of entries to grab the pokemon info
	if( sectionHeaders && isSearch == NO )
		pokemon = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row ];
	else
		pokemon = [entries objectAtIndex: indexPath.row];

    //save the indexpath in case we need to reload the cell
    pokemon.indexPath = indexPath;
    
	PokemonTableCellContentView *pokemonCellContentView = (PokemonTableCellContentView *)cell.drawView;
    
	//populate the view with all the necessary info
	pokemonCellContentView.title = pokemon.name;
	
    //depending on search results or standard, change the caption text as needed
	if( isSearch && searchWasWithLanguage )
		pokemonCellContentView.subTitle = pokemon.nameAlt;
	else
		pokemonCellContentView.subTitle = pokemon.species;
    
    pokemonCellContentView.dexNumValue = pokemon.dexText;
	
	//add the Pokemon's type icons
	pokemonCellContentView.type1Image = pokemon.type1Icon;
	pokemonCellContentView.type2Image  = pokemon.type2Icon;
    
	//if the icon's been loaded, laod it now, and redraw on finish
	if( pokemon.iconLoaded == NO )
	{
		pokemonCellContentView.icon = defaultIcon;
	}
	else {
		pokemonCellContentView.icon = pokemon.icon;
	}    
	
    [pokemonCellContentView setNeedsDisplay];
    
	return cell;
}

#pragma mark Section Index Calls
-(BOOL) sectionIndexIsVisible
{
	if( pokemonFinder.sortedOrder == PokemonFinderSortByNumber )
		return ( [tableEntries count] > POKEMON_NUM_DEX_SECTION_INDICIES);
	else if( pokemonFinder.sortedOrder == PokemonFinderSortByName )
		return ( [tableEntries count] > 26 );
		
	return NO;
}

-(BOOL) sectionHeadersAreVisible
{
	return (pokemonFinder.sortedOrder == PokemonFinderSortByName && [tableEntries count] > 20);
}

-(void) buildSectionHeaders
{
	NSDictionary *sectionEntries = [EntryFinder alphabeticalSectionEntryListWithEntries: tableEntries];
	self.sectionHeaderTitles = [EntryFinder alphabeticalSectionHeaderTitleListWithDictionary: sectionEntries];
	self.sectionHeaderEntries = [EntryFinder alphabeticalSectionHeaderEntryListWithDictionary: sectionEntries titleList: self.sectionHeaderTitles];
}

-(void) buildSectionIndex
{
	if( pokemonFinder.sortedOrder == PokemonFinderSortByNumber )
	{
		NSDictionary *sectionEntries = [PokemonEntryFinder dexSectionIndexEntriesWithEntries: tableEntries];
		self.sectionIndexTitles = [PokemonEntryFinder dexSectionIndexTitlesWithDictionary: sectionEntries search: YES];
		self.sectionIndexIndicies = [PokemonEntryFinder dexSectionIndexIndiciesWithDictionary: sectionEntries titleList: self.sectionIndexTitles];

	}
	else if( pokemonFinder.sortedOrder == PokemonFinderSortByName )
	{
		//bit of a hack, but since it's the same content, we can make it a tad more efficient by sharing
		self.sectionIndexTitles = [EntryFinder alphabeticalSectionIndexTitleListWithSectionHeaderTitleList: self.sectionHeaderTitles search: YES];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];
	
	PokemonListEntry *pokemon;
	
	if( _tableView == self.searchController.searchResultsTableView )
	{
		pokemon = (PokemonListEntry *)[self.tableSearchedEntries objectAtIndex: indexPath.row];
	}
	else
	{
		if( [self sectionHeadersAreVisible] )
			pokemon = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row ];
		else
			pokemon = (PokemonListEntry *)[self.tableEntries objectAtIndex: indexPath.row];
	}
	
	UINavigationController *target;
	if( self.parentViewController && [self.parentViewController isKindOfClass: [UINavigationController class]] == NO )
		target = self.parentViewController.navigationController;
	else 
		target = self.navigationController;
	
	PokemonProfileTabController *pokemonController = [[PokemonProfileTabController alloc] initWithDatabaseID: pokemon.dbID pokemonEntry: pokemon ];
	[target pushViewController: pokemonController animated: YES ];
	[pokemonController release]; 
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    if( self.view.superview == nil )
    {
        for ( PokemonListEntry *pokemon in tableEntries )
            [pokemon unloadIcon];
		
		//alert the supeclass to reload this next time
		self.imagesLoaded = NO;
    }
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)unloadImages
{
    for( PokemonListEntry *entry in tableEntries )
        [entry unloadIcon];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.defaultIcon = nil;
}

- (void)dealloc {
	[defaultIcon release];
	[pokemonFinder release];
	[regions release];
	[types release];
	[sortOrder release];
    [super dealloc];
}

#pragma mark - 
#pragma mark Tag Title
- (NSString *)tagTitle
{
    return @"Pokémon";
}

@end

