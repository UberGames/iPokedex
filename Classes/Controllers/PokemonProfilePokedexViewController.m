    //
//  ;
//  iPokedex
//
//  Created by Timothy Oliver on 17/02/11.
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

#import "PokemonProfilePokedexViewController.h"
#import "UIImage+TabIcon.h"
#import "ElementalTypes.h"
#import "TCGroupedTableSectionHeaderView.h"
#import "PokemonFlavorTexts.h"
#import "Generations.h"
#import "GameVersions.h"
#import "PokemonPokedexTextView.h"
#import "UIViewController+TagTitle.h"
#import "TCTableViewCell.h"

@interface PokemonProfilePokedexViewController ()

-(void) initGenerationHeaders;

@end


@implementation PokemonProfilePokedexViewController

@synthesize dbID, tableEntries, tableHeaders;

- (id) initWithDatabaseID: (NSInteger) databaseID
{
	if( (self = [super initWithStyle: UITableViewStyleGrouped]) )
	{
		self.dbID = databaseID;
        
        self.tabBarItem.title = NSLocalizedString( @"Pokédex", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Pokedex"];
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//get the elemental type of this pokemon and 
	ElementalType *type = [ElementalTypes typeWithPokemonID: self.dbID];
	
    //set the background color of the view
    UIView *background = [[UIView alloc] initWithFrame: self.view.bounds];
    background.backgroundColor = type.bgColor;
	self.tableView.backgroundView = background;
    [background release];
	
	self.tableView.sectionFooterHeight = 9.0f;
	self.tableView.sectionHeaderHeight = 9.0f;
	
	//load the table entries
	self.tableEntries = [PokemonFlavorTexts pokemonFlavorTextTableEntriesWithDatabaseID: self.dbID];
						 
	//load the generations
	[self initGenerationHeaders];
}

- (void) initGenerationHeaders
{
	NSInteger numPokemonGens = [tableEntries count]; //1 section per generation this Pokemon has
	NSDictionary *gensDict = [Generations generationsFromDatabase];
	NSInteger numGens = [gensDict count];
	NSMutableArray *headers = [[NSMutableArray alloc] init];
	
	for( NSInteger i = 0; i < numPokemonGens; i++ )
	{
		//Grab the generation
		Generation *gen = [gensDict objectForKey: [NSNumber numberWithInt: numGens-i]];
		
		if( gen == nil )
			continue;
		
		//create the header view
		TCGroupedTableSectionHeaderView *header = [[TCGroupedTableSectionHeaderView alloc] initWithTitle: [NSString stringWithFormat: NSLocalizedString (@"Generation %@", nil ), gen.name]];
		[headers addObject: header];
		[header release];
	}
	
	//flip the generations (as we compiled it from the end)
	if( [headers count] > 1 )
		self.tableHeaders = [[headers reverseObjectEnumerator] allObjects];
	else 
		self.tableHeaders = headers;
	
	[headers release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) didReceiveMemoryWarning
{	
	[super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
 	self.tableEntries = nil;
    self.tableHeaders = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
	[tableEntries release];
	[tableHeaders release];
	
    [super dealloc];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return GROUP_TABLE_SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return [tableHeaders objectAtIndex: section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
	PokemonFlavorTextTableEntry *flavorTextEntry = [[tableEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	flavorTextEntry.cellHeight = [PokemonPokedexTextView cellHeightWithWidth: (self.tableView.bounds.size.width-20)-(POKEDEX_TEXT_PADDING*2) text: flavorTextEntry.flavorText ];
	return flavorTextEntry.cellHeight + POKEDEX_TEXT_PADDING*2;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [tableEntries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[tableEntries objectAtIndex: section] count];
}
	
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"PokedexCell";
	
	TCTableViewCell *cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if( cell == nil ) {
		cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.drawView = [[[PokemonPokedexTextView alloc] initWithFrame: CGRectZero] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
	}
		
	//flush the cell properties
	PokemonFlavorTextTableEntry *flavorTextEntry = [[tableEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	
	//create the view
	PokemonPokedexTextView *textView = (PokemonPokedexTextView *)cell.drawView;
    
    cell.contentView.frame = cell.bounds;
    textView.frame = CGRectInset( cell.contentView.frame, POKEDEX_TEXT_PADDING, POKEDEX_TEXT_PADDING );
    
	textView.versionNames = flavorTextEntry.versionNames;
	textView.versionColors = flavorTextEntry.versionColors;
	textView.flavorText = flavorTextEntry.flavorText;
    
	return cell;
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Pokédex";
}

@end
