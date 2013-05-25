    //
//  MoveProfileMainViewController.m
//  iPokedex
//
//  Created by Tim Oliver on 28/02/11.
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

#import "MoveProfileMainViewController.h"
#import "TCTableViewCell.h"
#import "UIImage+TabIcon.h"
#import "UITableView+CellRect.h"
#import "UIViewController+TagTitle.h"

#define TABLE_NUM_SECTIONS 3

#define MOVE_SECTION_FLAVORTEXT 0
#define MOVE_ROW_FLAVORTEXT 0

#define MOVE_STATS_POWER 0
#define MOVE_STATS_ACCURACY 1
#define MOVE_STATS_PP 2
#define MOVE_STATS_MAXPP 3

#define MOVE_SECTION_STATS 1
#define MOVE_ROW_STATS 0
#define MOVE_ROW_EFFECT 1
#define MOVE_ROW_FLAGS 2

#define MOVE_SECTION_LINKS 2
#define MOVE_ROW_LINKS 0


@interface MoveProfileMainViewController ()

-(void) initTableHeader;
-(void) initFlavorText;
-(void) initEffectText;
-(void) initStatsView;
-(void) initFlagsView;
-(void) initExternalLinksView;

@end


@implementation MoveProfileMainViewController

@synthesize dbID, move;
@synthesize flavorTextView, effectTextView, moveStatsView, flagsView, externalLinksView, moveGeneration;

- (id)initWithDatabaseID: (NSInteger) databaseID
{
	if ( (self = [super initWithStyle: UITableViewStyleGrouped]) )
	{
		self.dbID = databaseID;
        
        self.tabBarItem.title = NSLocalizedString( @"Move", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Moves"];
	}

	return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	//get the move
	move = [[Move alloc] initWithDatabaseID: dbID];
	[move loadMove];

    self.moveGeneration = [Generations generationWithDatabaseID: move.generation];
    
	self.tableView.sectionHeaderHeight = 0.0f;
	
	//set the BG Color off the move
    UIView *background = [[UIView alloc] initWithFrame: self.view.bounds];
    background.backgroundColor = move.type.bgColor;
	self.tableView.backgroundView = background;
    [background release];
    
	//init table content views
	[self initTableHeader];
	[self initFlavorText];
	[self initStatsView];
	[self initFlagsView];
    [self initExternalLinksView];
    
    if( [move.effectText length] > 0 )
        [self initEffectText];
	
	[super viewDidLoad];
}

- (void)initTableHeader
{
	TableHeaderContentView *tableHeaderView = [[TableHeaderContentView alloc] initWithFrame: CGRectMake( 0, 0, 240, 80 )];
	tableHeaderView.icon1 = move.type.icon;
	tableHeaderView.icon2 = move.category.icon;
	tableHeaderView.contentIndent = 20;
	
    if( LANGUAGE_IS_JAPANESE )
    {
        tableHeaderView.subTitle = move.name;
        tableHeaderView.title = move.nameJP;
    }
    else
    {
        tableHeaderView.title = move.name;
        tableHeaderView.subTitle = [NSString stringWithFormat: @"%@ %@", move.nameJP, move.nameJPMeaning];
    }
    
    tableHeaderView.generation = [NSString stringWithFormat: NSLocalizedString( @"Generation %@", nil ), moveGeneration.name];
    
	self.tableView.tableHeaderView = tableHeaderView;
	[tableHeaderView release];
}

-(void) initFlavorText
{
	flavorTextView = [[TextBoxContentView alloc] initWithFrame:  CGRectZero];
	flavorTextView.flavorText = move.flavorText;
}

-(void) initEffectText
{
	effectTextView = [[TitledTextBoxContentView alloc] initWithFrame: CGRectZero];
    effectTextView.title = NSLocalizedString(@"Effect", nil);
	effectTextView.flavorText = move.effectText;
}

-(void) initStatsView
{
	moveStatsView = [[TCTableViewStatsSplitCell alloc] initWithFrame: CGRectMake( 0, 0, 300, 45 )];
	moveStatsView.delegate = self;
    
	NSMutableArray *items = [[NSMutableArray alloc] init];
	NSMutableArray *itemTitles = [[NSMutableArray alloc] init];
	
	//power
	[items addObject: move.powerValue];
	[itemTitles addObject: NSLocalizedString(@"Power", nil)];
	
	//Accuracy
	[items addObject: move.accuracyValue];
	[itemTitles addObject: NSLocalizedString(@"Acc.", nil)];
	
	//PP
	[items addObject: move.PPValue];
	[itemTitles addObject: NSLocalizedString(@"PP", nil)];
	
	//Max PP
	[items addObject: move.maxPPValue];
	[itemTitles addObject: NSLocalizedString(@"Max PP", nil)];
	
	//add the items to the view
	moveStatsView.items = items;
	moveStatsView.itemTitles = itemTitles;
	
	//release
	[items release];
	[itemTitles release];
}

- (void)initFlagsView
{
	flagsView= [[MoveFlagsContentView alloc] initWithFrame: CGRectMake( 0, 0, 270, 110 )];
	flagsView.flags = move.flags;
}

-(void) initExternalLinksView
{
    externalLinksView = [[MoveExternalLinksView alloc] initWithFrame: CGRectMake( 0, 0, 280, EXTERNAL_LINKS_HEIGHT )];
    externalLinksView.generation = move.generation;
    externalLinksView.targetController  =self.parentViewController;
    
    if( LANGUAGE_IS_JAPANESE )
        externalLinksView.moveName = move.nameJP;
    else
        externalLinksView.moveName = move.name;
}

- (void)didReceiveMemoryWarning {    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {	
    
	self.flagsView = nil;
	self.flavorTextView = nil;
	self.moveStatsView = nil;
	
    [super viewDidUnload];
}


- (void)dealloc {
	[move release];
    [moveGeneration release];
	[flagsView release];
	[flavorTextView release];
	[moveStatsView release];
    [externalLinksView release];
	
    [super dealloc];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return TABLE_NUM_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch( section )
	{
		case MOVE_SECTION_STATS:
            if( effectTextView == nil )
                return 2;
            else
                return 3;
            break;
		default:
			return 1;
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return the number of rows in the section.
	switch( indexPath.section )
	{
		case MOVE_SECTION_FLAVORTEXT: 
            flavorTextView.frame = [self.tableView boundsRectWithCellRect: flavorTextView.frame widthInset: 14.0f];
			return [flavorTextView height]+16;
		case MOVE_SECTION_STATS:
			switch (indexPath.row )
			{
                case MOVE_ROW_EFFECT:
                    if( effectTextView )
                    {
                        effectTextView.frame = [self.tableView boundsRectWithCellRect: effectTextView.frame widthInset: 14.0f];
                        return [effectTextView height]+16;
                    }
                    //continue
				case MOVE_ROW_FLAGS:
                    flagsView.frame = [self.tableView boundsRectWithCellRect: flagsView.frame widthInset: 12.0f];
					return [flagsView height]+16;
				default:
					return 45;
			}
        case MOVE_SECTION_LINKS:
            return EXTERNAL_LINKS_HEIGHT+10;
            break;
		default:
			return 45;
	}
	
	return 45;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContentCell";
    
    TCTableViewCell *cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TCTableViewCell alloc] initWithFrame: CGRectZero] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.backgroundColor = [UIColor whiteColor];
	} 
	
	switch ( indexPath.section )
	{
		case MOVE_SECTION_FLAVORTEXT:
            flavorTextView.frame = CGRectInset(cell.contentView.bounds, 14.0f, 10.0f);
			cell.drawView = flavorTextView;
			break;
		case MOVE_SECTION_STATS:
			switch ( indexPath.row ) {
				case MOVE_ROW_STATS:
                    moveStatsView.frame = CGRectInset(cell.contentView.bounds, 0.0f, 0.0f);
                    cell.drawView = moveStatsView;
					break;
                case MOVE_ROW_EFFECT:
                    if( effectTextView )
                    {
                        effectTextView.frame = CGRectInset(cell.contentView.bounds, 14.0f, 10.0f);
                        cell.drawView = effectTextView;
                        break;
                    }
                    //continue if the view was null
				case MOVE_ROW_FLAGS:
                    flagsView.frame = CGRectInset(cell.contentView.bounds, 15.0f, 8.0f);
                    cell.drawView = flagsView;
					break;
				default:
					break;
			}
            break;
        case MOVE_SECTION_LINKS:
            externalLinksView.frame = CGRectInset(cell.contentView.bounds, 7.0f, 7.0f );
            cell.drawView = externalLinksView;
            break;
			
	}
	
    return cell;
}

//---------------------------------------------------
//Split cell delegate
-(BOOL)splitTableCell: (TCTableViewSplitCell *)splitCell indexCanBeTapped: (NSInteger) index
{
    switch ( index ) {
        case MOVE_STATS_POWER:
            return (move.powerHasChangeLog);
        case MOVE_STATS_ACCURACY:
            return (move.accuracyHasChangeLog);
        case MOVE_STATS_PP:
        case MOVE_STATS_MAXPP:
            return (move.ppHasChangeLog);
        default:
            return NO;
    }
}

-(void)splitTableCellTapped: (TCTableViewSplitCell *)splitCell withIndex: (NSInteger)index
{
    NSString *stat = @"";
    NSString *unit = @""; //units for the specific stat (eg '%')
    NSArray *entries = nil;
    
    switch ( index ) {
        case MOVE_STATS_POWER:
            stat = NSLocalizedString(@"Power",nil);
            entries = [move.changeLog objectForKey: @"power"];
            break;
        case MOVE_STATS_ACCURACY:
            stat = NSLocalizedString(@"Accuracy",nil);
            unit = @"%";
            entries = [move.changeLog objectForKey: @"accuracy"];
            break;
        case MOVE_STATS_PP:
            stat = NSLocalizedString(@"PP", nil);
            entries = [move.changeLog objectForKey: @"pp"];
            break;
        case MOVE_STATS_MAXPP:
            stat = NSLocalizedString(@"Max PP", nil);
            entries = [NSMutableArray arrayWithArray:[move.changeLog objectForKey: @"pp"]];
            for( MoveChangeLogEntry *entry in entries )
            {
                entry.previousValue = ceil(entry.previousValue*1.6f);
            }
            break;
    }
    
    if( entries == nil )
        return;
    
    NSString *moveName = nil;
    if( LANGUAGE_IS_JAPANESE )
        moveName = move.nameJP;
    else
        moveName = move.name;
    
    NSString *alertTitle = [NSString stringWithFormat: @"%@ - %@", moveName, stat];
    NSString *content = @"";
    
    for( MoveChangeLogEntry *entry in entries )
        content = [content stringByAppendingFormat: NSLocalizedString(@"%d%@ until Generation %@\n",nil), entry.previousValue, unit, entry.generationName];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: alertTitle message: content delegate: nil cancelButtonTitle: nil otherButtonTitles: NSLocalizedString(@"OK", nil), nil];
    [alertView show];
    [alertView release];

}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"";
}


@end
