//
//  NewFavoritesListViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 15/06/11.
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

#import "FavoritesListViewController.h"
#import "UIViewController+TagTitle.h"
#import "UIImage+TabIcon.h"
#import "Favorites.h"
#import "MoveCategories.h"
#import "ElementalTypes.h"
#import "TCTableViewCell.h"
#import "PokemonTableCellContentView.h"
#import "MoveTableCellContentView.h"
#import "PokemonEntryFinder.h"
#import "MoveEntryFinder.h"
#import "EggGroupEntryFinder.h"
#import "AbilityEntryFinder.h"
#import "PokemonProfileTabController.h"
#import "MoveProfileTabController.h"
#import "AbilityProfileTabController.h"
#import "EggGroupMainViewController.h"

@interface FavoritesListViewController ()

- (void)removeEntryFromFavoritesWithIndexPath: (NSIndexPath *)indexPath;
- (void)moveEntryInFavoritesFromIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath;

@end

@implementation FavoritesListViewController

@synthesize elementalTypes, moveCategories, sectionTypes;

- (id)init
{
    self = [super init];
    if (self) {
        //segment view parameters
        self.segmentedButtonTitles = [NSArray arrayWithObjects: NSLocalizedString(@"Pokémon",nil), NSLocalizedString(@"Moves",nil), NSLocalizedString(@"Abilities",nil), NSLocalizedString(@"Eggs",nil), nil];
        self.segmentedSortTitle = nil;
        
        //tab bar view parameters
        self.tabBarItem.title = NSLocalizedString(@"Favorites", @"Favotries Menu");
        self.tabBarItem.image = [UIImage tabIconWithName: @"Favorites"];   
        
        //edit object
        self.navigationItem.rightBarButtonItem = self.editButton;   
    }
        
    return self;
}

- (void)dealloc
{
    [elementalTypes release];
    [moveCategories release];
    [sectionTypes release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //no favorites message
    self.noResultsMessage = NSLocalizedString( @"No favorites yet!", nil );   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    //if the view's already been loaded before, but the favorites have changed in the meantime, refresh
    if( [tableEntries count] > 0 && [[Favorites sharedFavorites] forceRefresh] )
        [self reloadTableContent];
}

- (NSArray *) loadTableContent
{ 
	if( self.elementalTypes == nil )
		self.elementalTypes = [ElementalTypes typesFromDatabaseWithIcons: YES];
	
	if( self.moveCategories == nil )
		self.moveCategories = [MoveCategories categoriesFromDatabaseWithIcons: YES];
    
    //set up a dummy array to disable all of the segment buttons by default
    NSMutableArray *disableButtons = [NSMutableArray arrayWithObjects: [NSNumber numberWithBool: NO],
                                                            [NSNumber numberWithBool: NO],
                                                            [NSNumber numberWithBool: NO],
                                                            [NSNumber numberWithBool: NO], nil ];
    //set it now
    [self performSelectorOnMainThread: @selector(setSegmentedDisabledButtons:) withObject:disableButtons waitUntilDone: YES];
    
	//favorites
	NSDictionary *favorites = [[Favorites sharedFavorites] favorites];
    
	//handle each favorite
	if ( [favorites count] == 0 )
    {
        [self setSelectedIndex: -1 withReload: NO];
        return nil;  
    }
        
    //loop through each one, and enable if we have entries in there
    NSInteger initialIndex = -1;
    NSArray *favoriteKeys = [NSArray arrayWithObjects: @"Pokemon", @"Moves", @"Abilities", @"EggGroups", nil ];
    
    for( NSInteger i = 0; i < [favoriteKeys count]; i++ )
    {
        NSArray *entries = [favorites objectForKey: [favoriteKeys objectAtIndex: i]];
        if( entries == nil || [entries count] <= 0 )
            continue;
        
        //this will be the initial tab to highlight (if another one is invalidated etc)
        if( initialIndex < 0 )
            initialIndex = i;
        
        //set enabled in the disable list
        [disableButtons replaceObjectAtIndex: i withObject: [NSNumber numberWithBool: YES]];
    }

    //update the table with the latest disabled buttons
    [self performSelectorOnMainThread: @selector(setSegmentedDisabledButtons:) withObject:disableButtons waitUntilDone: YES];
    
    //determine the selected index to make the button
    if( selectedIndex < 0 || selectedIndex >= [disableButtons count] || [[disableButtons objectAtIndex: selectedIndex] boolValue] == NO )
        selectedIndex = [self firstEnabledSelectedIndex];
    
    //if it's still -1 (eg no buttons are free), return
    if( selectedIndex < 0 )
        return nil;
    
    NSArray *idList = [favorites objectForKey: [favoriteKeys objectAtIndex: selectedIndex]];
    if( idList == nil || [idList count] == 0 )
        return nil;
    
    //set the selected index
    [self setSelectedIndex: selectedIndex withReload: NO];
    
    NSArray *entries = nil;
    
    //build the favorites entry data
    switch (selectedIndex) {
        case FavoritesTypePokemon:
        {
            entries = [PokemonEntryFinder pokemonWithDatabaseIDList: idList];
        
            //load icon data for each one
            for( PokemonListEntry *entry in entries )
            {
				if (entry.type1Id)
					entry.type1Icon = [[elementalTypes objectForKey: [NSNumber numberWithInt: entry.type1Id]] icon];
                
				if( entry.type2Id )
					entry.type2Icon = [[elementalTypes objectForKey: [NSNumber numberWithInt: entry.type2Id]] icon];
				
				[entry loadIcon];
            }
        }
            break;
        
        case FavoritesTypeMoves:
        {
            entries = [MoveEntryFinder movesWithDatabaseIDList: idList];
       
            for( MoveListEntry *move in entries )
            {
                move.categoryIcon = [[moveCategories objectForKey: [NSNumber numberWithInt: move.categoryID]] icon];
                move.typeIcon = [[elementalTypes objectForKey: [NSNumber numberWithInt: move.elementalTypeID]] icon];
            }
        }
            break;
        case FavoritesTypeAbilities:
            entries = [AbilityEntryFinder abilitiesWithDatabaseIDList: idList];
            break;
        case FavoritesTypeEggGroups:
            entries = [EggGroupEntryFinder eggGroupsWithDatabaseIDList: idList];
            break;
        default:
            break;
    }
    
    //load out the content from the favorites array
    return entries;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCTableViewCell *cell = nil;
    static NSString *pokemonCellIdentifier = @"pokemonFavoriteCell";
    static NSString *moveCellIdentifier = @"moveFavoriteCell";
    static NSString *subtitleCellIdentifier = @"subtitleFavoriteCell";
    
    //prepare the cell given the type of content
    ListEntry *entry = [tableEntries objectAtIndex: indexPath.row];
	
	switch ( self.selectedIndex ) {
		case FavoritesTypePokemon:
        {
            cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier: pokemonCellIdentifier];
            if( cell == nil )
            {
                cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: pokemonCellIdentifier] autorelease];
                cell.drawView = [[[PokemonTableCellContentView alloc] initWithFrame: cell.contentView.bounds] autorelease];
            }
            
			PokemonTableCellContentView *pokemonView = (PokemonTableCellContentView *)cell.drawView;
			PokemonListEntry *pokemon = (PokemonListEntry *)entry;
			
			pokemonView.title = pokemon.name;
			pokemonView.subTitle = pokemon.species;
			pokemonView.dexNumValue = pokemon.dexText;
			pokemonView.type1Image = pokemon.type1Icon;
			pokemonView.type2Image = pokemon.type2Icon;
            pokemonView.icon = pokemon.icon;
            
            [pokemonView setNeedsDisplay];
        }
            break;
        case FavoritesTypeMoves:
        {
            cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier: moveCellIdentifier];
            if( cell == nil )
            {
                cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: moveCellIdentifier] autorelease];
                cell.drawView = [[[MoveTableCellContentView alloc] initWithFrame: cell.contentView.bounds] autorelease];
            }            
            
            MoveTableCellContentView *moveView = (MoveTableCellContentView *)cell.drawView;
            MoveListEntry *move = (MoveListEntry *)entry;
            
            moveView.title = move.name;
            moveView.powerValue = move.powerValue;
            moveView.accuracyValue = move.accuracyValue;
            moveView.PPValue = move.PPValue;
            
            moveView.typeImage = move.typeIcon;
            moveView.categoryImage = move.categoryIcon;
            
            [moveView setNeedsDisplay];
        }
            break;
        case FavoritesTypeAbilities:
        {
            cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier: subtitleCellIdentifier];
            if( cell == nil )
                cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: subtitleCellIdentifier] autorelease];
            
            ListEntry *ability = (ListEntry *)entry;
            
            cell.textLabel.text = ability.name;
            cell.detailTextLabel.text = ability.caption;
        }
            break;
        case FavoritesTypeEggGroups:
        {
            cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier: subtitleCellIdentifier];
            if( cell == nil )
                cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: subtitleCellIdentifier] autorelease];            
            
            ListEntry *egg = (ListEntry *)entry;
            
            cell.textLabel.text = egg.name;
            cell.detailTextLabel.text = egg.caption;
        }
            break;
		default:
			break;
	}
	
    //set up default cell properties
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];
    
	//prepare the cell given the type of content
    ListEntry *entry = [tableEntries objectAtIndex: indexPath.row];
	
	switch ( self.selectedIndex ) {
		case FavoritesTypePokemon:
        {
			PokemonListEntry *pokemon = (PokemonListEntry *)entry;
			PokemonProfileTabController *pokemonController = [[PokemonProfileTabController alloc] initWithDatabaseID: pokemon.dbID pokemonEntry: pokemon ]; 
			[self.parentViewController.navigationController pushViewController: pokemonController animated: YES ];
			[pokemonController release];
        }
            break;
        case FavoritesTypeMoves:
        {
			MoveListEntry *move = (MoveListEntry *)entry;
			MoveProfileTabController *moveController = [[MoveProfileTabController alloc] initWithDatabaseID: move.dbID moveEntry: move ]; 
			[self.parentViewController.navigationController pushViewController: moveController animated: YES ];
			[moveController release];
        }
            break;
        case FavoritesTypeAbilities:
        {
            ListEntry *ability = (ListEntry *)entry;
            AbilityProfileTabController *abilityController = [[AbilityProfileTabController alloc] initWithDatabaseID: ability.dbID abilityEntry: ability ];
            [self.parentViewController.navigationController pushViewController: abilityController animated: YES];
            [abilityController release];
        }
            break;
        case FavoritesTypeEggGroups:
        {
            ListEntry *egg = (ListEntry *)entry;
            EggGroupMainViewController *eggController = [[EggGroupMainViewController alloc] initWithEggGroup1ID: egg.dbID ];
            [self.parentViewController.navigationController pushViewController: eggController animated: YES];
            [eggController release];
        }
            break;            
		default:
			break;
	}	
}

#pragma mark Deletion Callbacks
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NSLocalizedString( @"Remove", @"Table Row Removal" );
}

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		//find the object we're removing
		ListEntry *remove = [tableEntries objectAtIndex: indexPath.row];
		
        //remove from the Favorites singleton
        [self removeEntryFromFavoritesWithIndexPath: indexPath];        
        
		//remove the entry from the main list
		[(NSMutableArray *)tableEntries removeObject: remove];
        
		//remove the cell
		[_tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        //if the table is completely emptied, reload it to default it back to the original style
        if( [tableEntries count] == 0 )
        {
            //disable editing
            if(self.tableView.editing)
                [self editButtonTapped: self];
            
            [self reloadTableContent];
        }
	}
}

//delete the entry from the Favorites singleton
- (void) removeEntryFromFavoritesWithIndexPath: (NSIndexPath *)indexPath
{
    //prepare the cell given the type of content
    ListEntry *entry = [tableEntries objectAtIndex: indexPath.row];
    
    switch ( selectedIndex ) {
        case FavoritesTypePokemon:
            [[Favorites sharedFavorites] removeFavoritePokemonWithPokemonID: entry.dbID];
            break;
        case FavoritesTypeMoves:
            [[Favorites sharedFavorites] removeFavoriteMoveWithMoveID: entry.dbID];
            break;
        case FavoritesTypeAbilities:
            [[Favorites sharedFavorites] removeFavoriteAbilityWithAbilityID: entry.dbID];
            break;
        case FavoritesTypeEggGroups:
            [[Favorites sharedFavorites] removeFavoriteEggGroupWithEggGroupID: entry.dbID];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Reorder Delegate Methods

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)_tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
    //find the object we're moving
    ListEntry *listEntry = [[tableEntries objectAtIndex: fromIndexPath.row] retain];
    
    //move the object in the favorites singleton
    [self moveEntryInFavoritesFromIndexPath: fromIndexPath toIndexPath: toIndexPath];
    
    //move it around in the datasource
    [tableEntries removeObjectAtIndex: fromIndexPath.row];
    //reinsert
    [tableEntries insertObject: listEntry atIndex: toIndexPath.row];
    
    [listEntry release];
}

- (void)moveEntryInFavoritesFromIndexPath: (NSIndexPath *)fromIndexPath toIndexPath: (NSIndexPath *)toIndexPath
{
    switch ( self.selectedIndex ) {
        case FavoritesTypePokemon:
            [[Favorites sharedFavorites] reorderFavoritePokemonFromIndex: fromIndexPath.row toIndex: toIndexPath.row];
            break;
        case FavoritesTypeMoves:
            [[Favorites sharedFavorites] reorderFavoriteMoveFromIndex: fromIndexPath.row toIndex: toIndexPath.row];
            break;
        case  FavoritesTypeAbilities:
            [[Favorites sharedFavorites] reorderFavoriteAbilityFromIndex: fromIndexPath.row toIndex: toIndexPath.row];
            break;
        case FavoritesTypeEggGroups:
            [[Favorites sharedFavorites] reorderFavoriteEggGroupFromIndex: fromIndexPath.row toIndex: toIndexPath.row];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Favorites";
}

@end
