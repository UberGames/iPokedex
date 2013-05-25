//
//  MoveProfilePokemonViewController.m
//  iPokedex
//
//  Created by Tim Oliver on 4/03/11.
//  Copyright 2011 UberGames. All rights reserved.
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

#import "MoveProfilePokemonViewController.h"
#import "TCTableViewCell.h"
#import "UIColor+CustomColors.h"
#import "UIImage+TabIcon.h"
#import "UIImage+ImageLoading.h"

#define POKEMON_SEGMENT_LEVEL	0
#define POKEMON_SEGMENT_TMHM	1
#define POKEMON_SEGMENT_TUTOR	2
#define POKEMON_SEGMENT_EGGS	3


@implementation MoveProfilePokemonViewController

@synthesize dbID, moveGeneration;
@synthesize pokemonFinder, tmFinder;
@synthesize elementalTypes, generations, headerBGView;
@synthesize tmHeaderEntry;
@synthesize defaultIcon;

#pragma mark -
#pragma mark Initialization
- (id) initWithDatabaseID: (NSInteger) databaseID
{
	if( (self = [super init]) )
	{
		//save the database ID
		self.dbID = databaseID;
		self.segmentedButtonTitles = [NSArray arrayWithObjects: NSLocalizedString( @"Level", nil), NSLocalizedString(@"TM/HM",nil), NSLocalizedString(@"Tutor",nil), NSLocalizedString(@"Breed",nil), nil];
        self.segmentedSortTitle = NSLocalizedString( @"Gen.", nil );
        
        self.tabBarItem.title = NSLocalizedString( @"Pokémon", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Pokeball"];
        
        self.deferIconLoading = YES;
    }
	
	return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    //put all the main DB init code here, so we don't bog down the main tab controller when we initially load this controller
    if( generations == nil )
    {
        //load generations
        self.generations = [Generations generationsFromDatabase];
        self.moveGeneration = [MoveEntryFinder generationOfMoveWithDatabaseID: self.dbID];
        sortTitles = [[NSArray alloc] initWithObjects: NSLocalizedString(@"Generation", nil ), nil];	

        //set up the gens button in the segmented control bar
        selectorNavBar.topItem.rightBarButtonItem.title = [Generations generationShortNameWithGeneration: [generations objectForKey: [NSNumber numberWithInt: [generations count]]]];
        //disable it if this pokemon is the last in its generation
        if( moveGeneration == [generations count] )
            [selectorNavBar.topItem.rightBarButtonItem setEnabled: NO];
    }
    
	//init the pokemon finder
	if( pokemonFinder == nil )
	{
		pokemonFinder = [[PokemonEntryFinder alloc] init];
		pokemonFinder.moveID = self.dbID;
		pokemonFinder.gameVersionGroups = [GameVersions gameVersionsByGroupingFromDatabase];
        
        //get the default generation
        NSNumber *defaultGeneration = [[NSUserDefaults standardUserDefaults] objectForKey: @"defaultGeneration" ];
        if( defaultGeneration != nil )
        {
            NSInteger gen = [defaultGeneration intValue];
            
            if( gen > 0 )
            {
                //cap it at the lowest possible generation
                if( gen < moveGeneration )
                    gen = moveGeneration;
            }
            else
                gen = [generations count];
            
            pokemonFinder.generationID = gen;
        }
        else
        {
            pokemonFinder.generationID = [generations count];
        }
        
        //update the sort menu to match
        [self setSortIndex: [generations count] - pokemonFinder.generationID forRow: 0];
        
        //set sort menu name
		selectorNavBar.topItem.rightBarButtonItem.title = [Generations generationShortNameWithGeneration: [generations objectForKey: [NSNumber numberWithInt: pokemonFinder.generationID]]];        
        
        //disable any buttons that return 0 moves
        self.segmentedDisabledButtons = [pokemonFinder availableLearnCategoriesFromDatabase];        
	}
	
	//set up the TM finder
    if( tmFinder == nil )
    {
        tmFinder = [[TechnicalMachineFinder alloc] init];
        tmFinder.moveID = self.dbID;
        tmFinder.generationID = [generations count];
        tmFinder.gameVersionGroups = pokemonFinder.gameVersionGroups;    
    }
    
	//set the initial position of the generations scroller
	//if ( self.sortSavedRows == nil )
	//	sortSavedRows = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: ([generations count]-self.moveGeneration) ], [NSNumber numberWithInt: 0], nil];
	
	[super viewWillAppear: animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.footerCountMessage = NSLocalizedString(@"%d Pokémon",nil);
	self.tableCellIdentifier = @"MovePokemonCell";
    
    //load a dummy image 
    if( lazyLoadImages )
        self.defaultIcon = [UIImage imageFromResourcePath: @"Images/Interface/PokeBall.png"];
    else
        self.defaultIcon = [UIImage imageFromResourcePath: @"Images/Pokemon/Small/0.png"];
}

- (NSArray *) loadTableContent
{
	if( elementalTypes == nil )
		self.elementalTypes = [ElementalTypes typesFromDatabaseWithIcons: YES];
	
	NSArray *entries;

    //reset the ignored versions
    pokemonFinder.gameVersionIgnoredCaptions = nil;
    
	//load entries from the moves database
	switch ( selectedIndex )
	{
		case POKEMON_SEGMENT_LEVEL:
			entries = [pokemonFinder moveLevelPokemonFromDatabase];
			break;
		case POKEMON_SEGMENT_TMHM:
			self.tmHeaderEntry = [tmFinder tmEntryFromDatabase];
            pokemonFinder.gameVersionIgnoredCaptions = tmHeaderEntry.versionGroupIDNumbers;
			entries = [pokemonFinder moveTMPokemonFromDatabase];
			break;
		case POKEMON_SEGMENT_EGGS:
			entries = [pokemonFinder moveBreedPokemonFromDatabase];
			break;
		case POKEMON_SEGMENT_TUTOR:
			entries = [pokemonFinder moveTutorPokemonFromDatabase];
			break;
		default:
			return nil;
	}
	
	//populate the entries with the image data
	for ( PokemonListEntry *pokemon in entries )
	{
		pokemon.type1Icon = [[elementalTypes objectForKey: [NSNumber numberWithInt: pokemon.type1Id]] icon];
		pokemon.type2Icon = [[elementalTypes objectForKey: [NSNumber numberWithInt: pokemon.type2Id]] icon];
		
		//[pokemon loadIcon];
	}
	
    //if the selected index is the TM one, add a grey box
    //(This must be done instead of setting headerBG color because of the header view being locked in place and its white BG getting exposed)
	if( selectedIndex == POKEMON_SEGMENT_TMHM )
	{
		headerBGView = [[UIView alloc] initWithFrame: CGRectMake( 0, -(tableView.bounds.size.height-44), tableView.bounds.size.width, tableView.bounds.size.height)];
		headerBGView.backgroundColor = [UIColor tableHeaderBackgroundColor];
		[tableView addSubview: headerBGView];
		[tableView sendSubviewToBack: headerBGView];
	}
	else
	{
		if( headerBGView )
		{
            [headerBGView removeFromSuperview]; 
			self.headerBGView = nil;
		}
	}
    
    
	return (NSMutableArray *)entries;
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) didReceiveMemoryWarning
{	
	[super didReceiveMemoryWarning];
	self.elementalTypes = nil;  
	self.generations = nil;
}

- (void)viewDidUnload {
	self.headerBGView = nil;
	
    [super viewDidUnload];
}


- (void)dealloc {
	[tmHeaderEntry release];
	[elementalTypes release];
	[generations release];
	[pokemonFinder release];
	[headerBGView release]; 
	[defaultIcon release];
    
    [super dealloc];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return ([generations count]-self.moveGeneration)+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	Generation *gen = [generations objectForKey: [NSNumber numberWithInt: [generations count] - row]];
	
	NSString *genName = [NSString stringWithFormat: NSLocalizedString( @"Generation %@", nil ), gen.name];
	return genName;
}

#pragma mark Filter Method
- (void) performFilter
{
	NSInteger gen = [generations count] - [(NSNumber *)[sortRows objectForKey: [NSNumber numberWithInt: 0]] intValue ];
	selectorNavBar.topItem.rightBarButtonItem.title = [Generations generationShortNameWithGeneration: [generations objectForKey: [NSNumber numberWithInt: gen]]];
    
	//resize the selecter bar to accomodate the new space
	CGRect frame = segmentedSelectorView.frame;
	frame.size.width = self.view.bounds.size.width;
	segmentedSelectorView.frame = frame;
	
	//set the new generation
	pokemonFinder.generationID = gen;
	tmFinder.generationID = gen;
	
	//reset the buttons that return 0 moves
	self.segmentedDisabledButtons = [pokemonFinder availableLearnCategoriesFromDatabase];
    [self setSelectedIndex:[self firstEnabledSelectedIndex] withReload: YES];
    
    //no need to call the super selector. We're handling the refresh from our own code
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)_tableView titleForHeaderInSection:(NSInteger)section
{
	//If it is a TM/HM, instead of repeating the same thing in each table cell, derive its full caption
	//name and set it as the section title
	if([tableEntries count] && selectedIndex == POKEMON_SEGMENT_TMHM )
	{
		NSString *title = tmHeaderEntry.name;
		
		if( tmHeaderEntry.versionStrings )
		{
			title = [title stringByAppendingString: @" ("];
			
			for( NSString *version in tmHeaderEntry.versionStrings )
				title = [title stringByAppendingString: version];
			
			title = [title stringByAppendingString: @")"];
		}
		
		return title;
	}
		
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//generate a cell from the class parent
	TCTableViewCell *cell = (TCTableViewCell *)[super tableView: _tableView cellForRowAtIndexPath: indexPath];	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    if( cell.drawView == nil )
        cell.drawView = [[[PokemonTableCellContentView alloc] initWithFrame: cell.contentView.frame] autorelease];
    
	PokemonListEntry *pokemon = [tableEntries objectAtIndex: indexPath.row];
	
	//create the content view
	PokemonTableCellContentView *contentView = (PokemonTableCellContentView *)cell.drawView;
	
	//main info
	contentView.title = pokemon.name;
	contentView.dexNumValue = pokemon.dexText;
	contentView.type1Image = pokemon.type1Icon;
	contentView.type2Image  = pokemon.type2Icon;
	
    contentView.subTitle = pokemon.caption;
    //version exclusive items
    contentView.versionStrings	= pokemon.versionStrings;
    contentView.versionColors	= pokemon.versionColors;
    
	//if the icon's been loaded, laod it now, and redraw on finish
	if( pokemon.iconLoaded == NO )
	{
		contentView.icon = defaultIcon;
	}
	else {
		contentView.icon = pokemon.icon;
	}  
    
    [contentView setNeedsDisplay];
    
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];
	
	PokemonListEntry *pokemon = [tableEntries objectAtIndex: indexPath.row];
	
	PokemonProfileTabController *pokemonController = [[PokemonProfileTabController alloc] initWithDatabaseID: pokemon.dbID pokemonEntry: pokemon ]; 
	[self.parentViewController.navigationController pushViewController: pokemonController animated: YES ];
	[pokemonController release];
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Pokémon";
}

@end