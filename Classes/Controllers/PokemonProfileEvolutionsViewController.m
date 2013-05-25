    //
//  PokemonProfileEvolutionsViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 19/02/11.
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

#import "UIColor+CustomColors.h"
#import "UIImage+TabIcon.h"
#import "PokemonProfileEvolutionsViewController.h"
#import "TCTableViewCell.h"
#import "TCTabBarController+SwitchHandling.h"
#import "PokemonEntryFinder.h"
#import "ElementalTypes.h"
#import "PokemonTableCellContentView.h"
#import "PokemonProfileTabController.h"
#import "UIViewController+TagTitle.h"
#import "UITableView+CellRect.h"

#define POKEMON_EVOLUTION_BABY_SECTION_HEADER NSLocalizedString( @"Baby Form", @"Baby Section Header" )
#define POKEMON_EVOLUTION_BASE_SECTION_HEADER NSLocalizedString( @"Base Form", @"Base Section Header" )
#define POKEMON_EVOLUTION_FIRST_SECTION_HEADER NSLocalizedString( @"First Evolution", @"First Section Header" )
#define POKEMON_EVOLUTION_SECOND_SECTION_HEADER NSLocalizedString( @"Second Evolution", @"Second Section Header" )

@implementation PokemonProfileEvolutionsViewController

@synthesize dbID, defaultIcon;

- (id) initWithDatabaseID: (NSInteger) databaseID
{
	if( (self = [super init]) )
	{
		self.dbID = databaseID;
        
        self.tabBarItem.title = NSLocalizedString( @"Evolutions", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Evolutions"];
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableCellIdentifier = @"PokemonEvolution";
	
	//set background header color
	[tableView setValue: [UIColor tableHeaderBackgroundColor] forKey: @"tableHeaderBackgroundColor"];	
}

- (NSArray *) loadTableContent
{
	//table entries and section headers
	NSMutableArray *entries = [[NSMutableArray alloc] init];
	NSMutableArray *headerTitles = [[NSMutableArray alloc] init];
	NSMutableArray *sectionEntries = [[NSMutableArray alloc] init];
	
	NSDictionary *evolutionSections = [PokemonEntryFinder pokemonEvolutionsWithDatabaseID: dbID];

	//check for babies
	PokemonListEntry *baby = [evolutionSections objectForKey: POKEMON_EVOLUTION_BABY_KEY];
	if( baby )
	{
		[entries addObject: baby];
		[headerTitles addObject: POKEMON_EVOLUTION_BABY_SECTION_HEADER];
		[sectionEntries addObject: [NSArray arrayWithObject: baby]];
	}
	
	//base form
	NSArray *base = [evolutionSections objectForKey: POKEMON_EVOLUTION_BASE_KEY];
	if ( base ) {
		[entries addObjectsFromArray: base];
		[headerTitles addObject: POKEMON_EVOLUTION_BASE_SECTION_HEADER];
		[sectionEntries addObject: base ];
	}
	
	//first forms
	NSArray *first = [evolutionSections objectForKey: POKEMON_EVOLUTION_FIRST_KEY];
	if( first )
	{
		[entries addObjectsFromArray: first];
		[headerTitles addObject: POKEMON_EVOLUTION_FIRST_SECTION_HEADER];
		[sectionEntries addObject: first];
	}
	
	//second forms
	NSArray *second = [evolutionSections objectForKey: POKEMON_EVOLUTION_SECOND_KEY];
	if( second )
	{
		[entries addObjectsFromArray: second];
		[headerTitles addObject: POKEMON_EVOLUTION_SECOND_SECTION_HEADER];
		[sectionEntries addObject: second];
	}
	
	self.sectionHeaderTitles = headerTitles;
	[headerTitles release];
	
	self.sectionHeaderEntries = sectionEntries;
	[sectionEntries release];
	
	//load icons from the types and assign them to each pokemon (faster than doing it on Cell load)
	NSDictionary *types = [ElementalTypes typesFromDatabaseWithIcons: YES];
	for( PokemonListEntry *pokemon in entries )
	{
		if( pokemon.type1Id > 0 )
			pokemon.type1Icon = [(ElementalType *)[types objectForKey: [NSNumber numberWithInt: pokemon.type1Id]] icon];
		
		if( pokemon.type2Id > 0 )
			pokemon.type2Icon = [(ElementalType *)[types objectForKey: [NSNumber numberWithInt: pokemon.type2Id]] icon];
	
        //load the icon too
        [pokemon loadIcon];
    }
	
	//load a dummy image 
	UIImage *dummyImage = [[UIImage alloc] initWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"Images/Pokemon/Small/0.png"]];
	self.defaultIcon =  dummyImage;
	[dummyImage release];	
	
	return [entries autorelease];
}

//load the pokemon icon
-(UIImage *) loadCellImageWithDataSourceEntry: (id)dataSourceEntry
{
	[(PokemonListEntry *)dataSourceEntry loadIcon];
	return [(PokemonListEntry *)dataSourceEntry icon];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.defaultIcon = nil;
	
    [super viewDidUnload];
}


- (void)dealloc {
	[defaultIcon release];
	
    [super dealloc];
}

#pragma mark UITableDataSource Methods
- (BOOL) sectionHeadersAreVisible
{
	return YES;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokemonListEntry *pokemon = (PokemonListEntry *)[[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    CGFloat cellWidth = _tableView.frame.size.width - (TABLECONTENTCELL_DEFAULT_INSET+POKEMON_DEXTYPES_WIDTH+20); //+20 for the activity indicator view
    CGFloat height = [TableCellContentView heightWithSubtitleText: pokemon.caption withSubTitleSize: TABLECONTENTCELL_DEFAULT_SUBTITLESIZE forWidth: cellWidth];
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	//generate a cell from the class parent
	TCTableViewCell *cell = (TCTableViewCell *)[super tableView: _tableView cellForRowAtIndexPath: indexPath];	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    if( cell.drawView == nil )
    {
        cell.drawView = [[[PokemonTableCellContentView alloc] initWithFrame: cell.contentView.bounds] autorelease];
        [(PokemonTableCellContentView *)cell.drawView setSubTitleIsMultiline: YES];
    }
    
    cell.contentView.frame = cell.bounds;
    cell.drawView.frame = cell.contentView.bounds;
    
	PokemonListEntry *pokemon = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row ];

	//create the content view, offset to account for the icon
	PokemonTableCellContentView *pokemonCellContentView = (PokemonTableCellContentView *)cell.drawView;
	
	//populate the view with all the necessary info
	pokemonCellContentView.title = pokemon.name;
	pokemonCellContentView.dexNumValue = pokemon.dexText;
	pokemonCellContentView.subTitle = pokemon.caption;
	
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

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];
	
	PokemonListEntry *pokemon = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row ];
	
	//if we're going to link to ourselves, just skip the tab back
	if( pokemon.dbID == self.dbID )
	{
		[(TCTabBarController *)self.parentViewController switchToSelectedIndex: 0];
		return;
	}
	
	PokemonProfileTabController *pokemonController = [[PokemonProfileTabController alloc] initWithDatabaseID: pokemon.dbID pokemonEntry: pokemon ]; 
	[self.parentViewController.navigationController pushViewController: pokemonController animated: YES ];
	[pokemonController release];
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Evolutions";
}

@end
