//
//  PokemonProfileStatsViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 25/01/11.
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

#import "PokemonProfileStatsViewController.h"
#import "UIImage+TabIcon.h"
#import "ElementalTypes.h"
#import "ElementalTypesDamages.h"
#import "RoundedRectView.h"
#import "GlossyRoundedRectView.h"
#import "PokemonStats.h"
#import "PokemonTypeStrengthsView.h"
#import "UIViewController+TagTitle.h"

#define SECTION_BASE_STATS 0
#define SECTION_TYPE_EFFECTIVENESS 1

@interface PokemonProfileStatsViewController ()
-(void) initBaseStatsView;
-(void) initTypeDamagesView;
@end


@implementation PokemonProfileStatsViewController

@synthesize dbID, baseStatsView, typesDamageView;

#pragma mark -
#pragma mark Initialization

- (id)initWithDatabaseID: (NSInteger) databaseID 
{
	if( (self = [super initWithStyle: UITableViewStyleGrouped]) ) 
	{
		self.dbID = databaseID;
        
        self.tabBarItem.title = NSLocalizedString( @"Stats", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Stats"];
    }
	
    return self;	
}

#pragma mark -
#pragma mark View lifecycle

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
}

-(void) viewWillAppear:(BOOL)animated
{
	[self initBaseStatsView];
	[self initTypeDamagesView];
	
	[super viewWillAppear: animated];
}

-(void) initBaseStatsView
{
	PokemonStats *stats = [[PokemonStats alloc] initWithDatabaseID: self.dbID loadStats: YES];
	
	baseStatsView = [[PokemonBaseStatsView alloc] initWithFrame: CGRectMake( 0, 0, self.tableView.bounds.size.width-20, BASE_STATS_CELL_HEIGHT )];
	baseStatsView.hp = stats.base.hp;
	baseStatsView.atk = stats.base.atk;
	baseStatsView.def = stats.base.def;
	baseStatsView.spAtk = stats.base.spAtk;
	baseStatsView.spDef = stats.base.spDef;
	baseStatsView.speed = stats.base.speed;
    baseStatsView.total = stats.base.total;
	[stats release];
}

-(void) initTypeDamagesView
{
	typesDamageView = [[PokemonTypeStrengthsView alloc] initWithFrame: CGRectMake( 0, 0, self.tableView.bounds.size.width-20, 0 )];

	//get the type info and the damage info we need
	typesDamageView.types = [ElementalTypes typesFromDatabaseWithIcons: YES];
	typesDamageView.typeDamages = [ElementalTypesDamages damagesWithPokemonId: dbID];
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
    self.typesDamageView = nil;
	self.baseStatsView = nil;
	
	[super viewDidUnload];
}

- (void)dealloc {
	[typesDamageView release];
	[baseStatsView release];
	
    [super dealloc];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch( indexPath.section )
	{
		case SECTION_BASE_STATS:
			return BASE_STATS_CELL_HEIGHT;
		case SECTION_TYPE_EFFECTIVENESS:
			return [typesDamageView frameHeight]+25;
		default:
			return 44;
	}
	
	return 44;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
	}
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//flush the cell properties
	cell.contentView.frame = CGRectMake( 0, 0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height );
	if ([cell.contentView subviews]) {
		for (UIView *subview in cell.contentView.subviews) {
			[subview removeFromSuperview];
		}
	}
	
	switch ( indexPath.section )
	{
		case SECTION_BASE_STATS:
			baseStatsView.frame = CGRectMake( cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+5, cell.contentView.frame.size.width-20, BASE_STATS_CELL_HEIGHT-10);
			[cell.contentView addSubview: baseStatsView];
			break;
		case SECTION_TYPE_EFFECTIVENESS:
			typesDamageView.frame = CGRectMake( cell.contentView.frame.origin.x+10, cell.contentView.frame.origin.y+10, cell.contentView.frame.size.width-20, 44);
			[cell.contentView addSubview: typesDamageView];
			break;
	}
    
    return cell;
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Stats";
}

@end

