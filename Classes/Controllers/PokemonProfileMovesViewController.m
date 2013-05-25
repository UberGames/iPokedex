    //
//  PokemonProfileMovesViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 16/02/11.
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

#import "PokemonProfileMovesViewController.h"
#import "UIImage+TabIcon.h"
#import "TCTableViewCell.h"
#import "PokemonEntryFinder.h"
#import "Generations.h"
#import "GameVersions.h"
#import "ElementalTypes.h"
#import "MoveCategories.h"
#import "MoveTableCellContentView.h"
#import "MoveProfileTabController.h"
#import "UIViewController+TagTitle.h"

#define MOVE_SEGMENT_LEVEL 0
#define MOVE_SEGMENT_TMHM 1
#define MOVE_SEGMENT_TUTOR 2
#define MOVE_SEGMENT_EGGS 3

@implementation PokemonProfileMovesViewController

@synthesize dbID, generations, elementalTypes, moveCategories, pokemonGeneration, movesFinder;

- (id) initWithDatabaseID: (NSInteger) databaseID
{
	if( (self = [super init]) )
	{
		//save the database ID
		self.dbID = databaseID;
		self.segmentedButtonTitles = [NSArray arrayWithObjects: NSLocalizedString(@"Level",nil), NSLocalizedString(@"TM/HM",nil), NSLocalizedString(@"Tutor",nil), NSLocalizedString(@"Breed",nil), nil];
        self.segmentedSortTitle = NSLocalizedString( @"Gen.", nil );
    
        self.tabBarItem.title = NSLocalizedString( @"Moves", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Moves"];
    }
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	
	if( self.generations == nil )
	{
		//load generations
		self.generations = [Generations generationsFromDatabase];
		self.pokemonGeneration = [PokemonEntryFinder generationOfPokemonWithDatabaseID: self.dbID];
		sortTitles = [[NSArray alloc] initWithObjects: NSLocalizedString(@"Generation",nil), nil];	
		
		//disable it if this pokemon is the last in its generation
		if( pokemonGeneration == [generations count] )
			[selectorNavBar.topItem.rightBarButtonItem setEnabled: NO];		
	}
	
	//init the moves finder
	if( movesFinder == nil )
	{
		movesFinder = [[MoveEntryFinder alloc] init];
		movesFinder.pokemonID = self.dbID;
		movesFinder.gameVersionGroups = [GameVersions gameVersionsByGroupingFromDatabase];
        
        //set the default generation
        NSNumber *defaultGeneration = [[NSUserDefaults standardUserDefaults] objectForKey: @"defaultGeneration"];
        if( defaultGeneration != nil )
        {
            NSInteger generation = [defaultGeneration intValue];
            
            if( generation > 0 )
            {
                if( generation < pokemonGeneration )
                    generation = pokemonGeneration;
            }
            else
                generation = [generations count];
            
            movesFinder.generationID = generation;
        }
        else
        {
            movesFinder.generationID = [generations count];
        }
        
        //update the sort menu to match
        [self setSortIndex: [generations count] - movesFinder.generationID forRow: 0];
        
        //set sort menu name
		selectorNavBar.topItem.rightBarButtonItem.title = [Generations generationShortNameWithGeneration: [generations objectForKey: [NSNumber numberWithInt: movesFinder.generationID]]];
        
		//disable any buttons that return 0 moves
		self.segmentedDisabledButtons = [movesFinder availableLearnCategoriesFromDatabase];        
	}
	
	//set the initial position of the generations scroller
	//if ( self.sortSavedRows == nil )
	//	self.sortSavedRows = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt: ([generations count]-self.pokemonGeneration) ], [NSNumber numberWithInt: 0], nil];		
    
    [super viewWillAppear: animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.footerCountMessage = NSLocalizedString( @"%d Moves", nil );
	self.footerCountMessageSingular = NSLocalizedString( @"%d Move", nil );
	self.tableCellIdentifier = @"PokemonMoveCell";	
}

-(NSArray *) loadTableContent
{	
	if( moveCategories == nil )
		self.moveCategories = [MoveCategories categoriesFromDatabaseWithIcons: YES];
	
	if( elementalTypes == nil )
		self.elementalTypes = [ElementalTypes typesFromDatabaseWithIcons: YES];
		
	NSArray *entries;
	
	//load entries from the moves database
	switch ( selectedIndex )
	{
		case MOVE_SEGMENT_LEVEL:
			entries = [movesFinder pokemonLevelMovesFromDatabase];
			break;
		case MOVE_SEGMENT_TMHM:
			entries = [movesFinder pokemonTechnicalMachineMovesFromDatabase];
			break;
		case MOVE_SEGMENT_EGGS:
			entries = [movesFinder pokemonEggMovesFromDatabase];
			break;
		case MOVE_SEGMENT_TUTOR:
			entries = [movesFinder pokemonTutorMovesFromDatabase];
			break;
		default:
			return nil;
	}

	//populate the entries with the image data
	for ( MoveListEntry *move in entries )
	{
		move.typeIcon = [[elementalTypes objectForKey: [NSNumber numberWithInt: move.elementalTypeID]] icon];
		move.categoryIcon = [[moveCategories objectForKey: [NSNumber numberWithInt: move.categoryID]] icon];
	}
	
	return entries;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
    self.generations = nil;
}

- (void)viewDidUnload {   
    [super viewDidUnload];
}


- (void)dealloc {
	[elementalTypes release];
	[moveCategories release];
	[generations release];
	[movesFinder release];
	
    [super dealloc];
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return ([generations count]-self.pokemonGeneration)+1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger generationId = [generations count]-row;
    //generationId = -generationId + ([generations count]+1);
    
	Generation *gen = [generations objectForKey: [NSNumber numberWithInt: generationId]];
	
	NSString *genName = [NSString stringWithFormat: NSLocalizedString( @"Generation %@", nil), gen.name];
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
	movesFinder.generationID = gen;
	
	//reset the buttons that return 0 moves
	self.segmentedDisabledButtons = [movesFinder availableLearnCategoriesFromDatabase];
    [self setSelectedIndex:[self firstEnabledSelectedIndex] withReload: YES];
    
    //no need to call the super selector. We're handling the refresh from our own code
}

#pragma mark -
#pragma mark Table view data source
							  
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	//generate a cell from the class parent
	TCTableViewCell *cell = (TCTableViewCell *)[super tableView: _tableView cellForRowAtIndexPath: indexPath];	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    if( cell.drawView == nil )
        cell.drawView = [[[MoveTableCellContentView alloc] initWithFrame: cell.contentView.frame] autorelease];

	MoveListEntry *move = [tableEntries objectAtIndex: indexPath.row];
	
	//create the content view
	MoveTableCellContentView *contentView = (MoveTableCellContentView *)cell.drawView;

	//main info
	contentView.title = move.name;
	contentView.subTitle = move.caption;
	contentView.powerValue = move.powerValue;
	contentView.accuracyValue = move.accuracyValue;
	contentView.PPValue = move.PPValue;

	//icons
	contentView.typeImage = move.typeIcon;
	contentView.categoryImage = move.categoryIcon;

	//version exclusive items
	contentView.versionStrings = move.versionStrings;
	contentView.versionColors = move.versionColors;
    
    [contentView setNeedsDisplay];
    
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];
	
	MoveListEntry *move = [tableEntries objectAtIndex: indexPath.row];
	
	MoveProfileTabController *moveController = [[MoveProfileTabController alloc] initWithDatabaseID: move.dbID moveEntry: move ]; 
	[self.parentViewController.navigationController pushViewController: moveController animated: YES ];
	[moveController release];
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Moves";
}
							  
@end
