//
//  PokemonInfoViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 29/12/10.
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

#import "PokemonProfileMainViewController.h"

#import "UIImage+TabIcon.h"
#import "TCTableViewCell.h"
#import "PokemonProfileMainViewController.h"
#import "EggGroupMainViewController.h"
#import "TCTableViewStatsSplitCell.h"
#import "PokemonGenderRatioView.h"
#import "PokemonEffortYieldView.h"
#import "UIColor+HexString.h"
#import "PokemonInfoHeader.h"
#import "UITableViewCellStyle2.h"
#import "AbilityProfileTabController.h"
#import "PokemonExternalLinksView.h"
#import "UIViewController+TagTitle.h"

#define TABLE_NUM_SECTIONS		6

#define SECTION_DEX_NUMBERS		0
#define SECTION_INFO			1
#define SECTION_STATS           2
#define SECTION_GENDER_RATE		3
#define SECTION_EV_STATS		4
#define SECTION_EXTERNAL_LINKS  5

#define TABLECELL_STANDARD  @"PokemonTableCellStandard"
#define TABLECELL_STATS     @"PokemonTableCellStats"
#define TABLECELL_GENDER    @"PokemonTableCellGender"
#define TABLECELL_EV        @"PokemonTableCellEV"
#define TABLECELL_LINKS     @"PokemonTableCellLinks"

@interface PokemonProfileMainViewController ()

-(void) initTableHeader;
-(void) initDexCellView;
-(void) initWeightAndHeightView;
-(void) initExtraStatsView;
-(void) initExtra2StatsView;
-(void) initGenderView;
-(void) initEffortYieldView;
-(void) initExternalLinks;
-(void) abilityTransition;
-(void) eggGroupTransition;

-(NSString *) filePathForPokemonCry;

- (void)handleSwipe: (UIGestureRecognizer *)sender;
@end

@implementation PokemonProfileMainViewController

@synthesize dbID, pokemon;
@synthesize dexNumbersTitles, dexNumbersValues, weightHeightTitles, weightHeightValues, extraStatsTitles, extraStatsValues, extra2StatsTitles, extra2StatsValues;
@synthesize genderTableCell, evTableCell, linksTableCell;
@synthesize eggGroupPrompt, abilityPrompt;
@synthesize cryFilePath, cryPlayer;


#ifdef PRIVATE_APIS_ARE_COOL
@synthesize pokedexSpeech;
#endif

#pragma mark -
#pragma mark Initialization

- (id)initWithDatabaseID: (NSInteger) databaseID
{
	if( (self = [super initWithStyle: UITableViewStyleGrouped]) ) 
	{
		self.dbID = databaseID;
        
        self.tabBarItem.title = NSLocalizedString( @"Pokémon", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Pokeball"];
    }
	
    return self;	
}

#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad
{
	//load the pokemon
	pokemon = [[Pokemon alloc] initWithDatabaseID: dbID];
	[pokemon loadPokemon];
	[pokemon loadPicture];
	
	//set the background color of the view
    UIView *background = [[UIView alloc] initWithFrame: self.view.bounds];
    background.backgroundColor = pokemon.type1.bgColor;
	self.tableView.backgroundView = background;
    [background release];
    
	//set up the header
	[self initTableHeader];
	//set up the dex row
	[self initDexCellView];
	//set up weight and height
	[self initWeightAndHeightView];
	//init extra stats
	[self initExtraStatsView];
    //init second lot of stats
    [self initExtra2StatsView];
    //init gender 
    [self initGenderView];
	//init the EV yield box
	[self initEffortYieldView];
	//init the External Links
    [self initExternalLinks];
    
    //get the cry audio file
    self.cryFilePath = [self filePathForPokemonCry];
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipe:)];
    swipeRecognizer.direction = (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight);
    
    for (UIGestureRecognizer *gesture in self.tableView.gestureRecognizers)
    {
        // don't want to mention any Apple TM'ed class names ;-)
        NSString *className = NSStringFromClass([gesture class]);
        if ([className rangeOfString:@"UIScrollViewDelayedTouches"].location!=NSNotFound)
        {
            [gesture requireGestureRecognizerToFail:swipeRecognizer];
        }
    }
    [self.tableView addGestureRecognizer: swipeRecognizer];
    [swipeRecognizer release];
    
	[super viewDidLoad];
}

- (void)handleSwipe: (UIGestureRecognizer *)sender {
    NSLog( @"Swipe Detected" );
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Init Methods
- (NSString *)filePathForPokemonCry
{
    NSString *audioPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"Sounds/Cries"];
    
    //check if there is a forme variant cry
    if( [pokemon.formeShortName length] )
    {
        NSString *formeAudioName = [NSString stringWithFormat: @"%d-%@.m4a", pokemon.ndex, pokemon.formeShortName];
        NSString *fileRoute = [audioPath stringByAppendingPathComponent: formeAudioName];
        
        if( [[NSFileManager defaultManager] fileExistsAtPath: fileRoute] )
            return fileRoute;
    }
    
    //no forme variant, return the standard one
    NSString *audioName = [NSString stringWithFormat: @"%d.m4a", pokemon.ndex];
    return [audioPath stringByAppendingPathComponent: audioName];
}

-(void) initTableHeader
{
	PokemonInfoHeader *pokemonInfoHeader = [[PokemonInfoHeader alloc] initWithFrame: CGRectMake( 0, 0, 280, 150 )];
	pokemonInfoHeader.pokemonPic = pokemon.picture;
	
    if( LANGUAGE_IS_JAPANESE )
    {
        pokemonInfoHeader.pokemonName = self.pokemon.nameJP;
        pokemonInfoHeader.pokemonLangName = [NSString stringWithFormat: @"%@", pokemon.name];
    }
    else
    {
        pokemonInfoHeader.pokemonName = self.pokemon.name;
        pokemonInfoHeader.pokemonLangName = [NSString stringWithFormat: @"%@ %@", pokemon.nameJP, pokemon.nameJPRomaji];
	}
	
	pokemonInfoHeader.type1Image = pokemon.type1.icon;
	if( pokemon.type2 )
		pokemonInfoHeader.type2Image = pokemon.type2.icon;
	
	pokemonInfoHeader.nDex = [Pokemon formatDexNumberWithInt: pokemon.ndex prependHash: YES];
	
	if( pokemon.formeName != nil )
		pokemonInfoHeader.pokemonForme = [NSString stringWithFormat: NSLocalizedString( @"(%@ Forme)", @"Forme name"), pokemon.formeName];
	
    //init the button action
    [pokemonInfoHeader.cryButton addTarget: self action: @selector(cryButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    
#ifdef PRIVATE_APIS_ARE_COOL
    [pokemonInfoHeader.speechButton addTarget: self action: @selector(speechButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
#endif
    
	self.tableView.tableHeaderView = pokemonInfoHeader;
	[pokemonInfoHeader release];
}

-(void) initDexCellView
{
	//dexNumbersView = [[TCTableViewStatsSplitCell alloc] initWithFrame: CGRectMake( 0, 0, 280, 45 )];
	//dexNumbersView.defaultText = NSLocalizedString( @"Not in any regional Pokédex", nil );
    
	NSMutableArray *items = [[NSMutableArray alloc] init];
	NSMutableArray *detailItems = [[NSMutableArray alloc] init];
	
	//Kanto
	if( pokemon.kdex > 0 )
	{
		[items addObject: [Pokemon formatDexNumberWithInt: pokemon.kdex prependHash: YES]];
		[detailItems addObject: NSLocalizedString( @"Kanto", nil)];
	}
	
	//Johto
	if( pokemon.jdex > 0 )
	{
		[items addObject: [Pokemon formatDexNumberWithInt: pokemon.jdex prependHash: YES]];
		[detailItems addObject: NSLocalizedString( @"Johto", nil)];
	}
	
	//Hoenn
	if( pokemon.hdex > 0 )
	{
		[items addObject: [Pokemon formatDexNumberWithInt: pokemon.hdex prependHash: YES]];
		[detailItems addObject: NSLocalizedString(@"Hoenn", nil)];
	}
	
	//Sinnoh
	if( pokemon.sdex > 0 )
	{
		[items addObject: [Pokemon formatDexNumberWithInt: pokemon.sdex prependHash: YES]];
		[detailItems addObject: NSLocalizedString(@"Sinnoh", nil)];
	}
	
    //Unova
    if( pokemon.udex > 0 || pokemon.ndex == 494 ) //Special exception for Victini (Seriously? 0 as a dex number?)
    {
        [items addObject: [Pokemon formatDexNumberWithInt: pokemon.udex prependHash: YES]];
        [detailItems addObject: NSLocalizedString(@"Unova", nil)];
    }
        
    self.dexNumbersTitles = detailItems;
    self.dexNumbersValues = items;
	
	[items release];
	[detailItems release];
}

-(void)initWeightAndHeightView
{
	//weightAndHeightView = [[TCTableViewStatsSplitCell alloc] initWithFrame: CGRectMake( 0, 0, 280, 45 )];
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	NSMutableArray *detailItems = [[NSMutableArray alloc] init];
	
	//calc the imperial height (Honestly. Who the crap uses this? ;) )
	CGFloat pokemonHeight = pokemon.height * 0.1f;
	NSInteger pokemonHeightFeet = floor(round(pokemonHeight*39.370078740157477f)/12.0f);
	NSInteger pokemonHeightInches = (int)round(pokemonHeight*39.370078740157477f) % 12;
	
	//add height
	[items addObject: [NSString stringWithFormat: NSLocalizedString(@"%2.1fm (%d'%02d\")", nil), 
													pokemonHeight, 
													pokemonHeightFeet,
													pokemonHeightInches]];
	[detailItems addObject: NSLocalizedString( @"Height", nil )];
	
	//calc weight
	CGFloat pokemonWeight = pokemon.weight * 0.1f;
	CGFloat pokemonWeightImperial = pokemonWeight * 2.204f;
	
	//weight
	[items addObject: [NSString stringWithFormat: NSLocalizedString(@"%2.1fkg (%2.1flb)", nil), pokemonWeight, pokemonWeightImperial ]];
	[detailItems addObject: NSLocalizedString(@"Weight", nil)];
	
	self.weightHeightValues = items;
	[items release];
	
	self.weightHeightTitles = detailItems;
	[detailItems release];
}

-(void) initExtraStatsView
{
	//extraStatsView = [[TCTableViewStatsSplitCell alloc] initWithFrame: CGRectMake( 0, 0, 280, 45 )];
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	NSMutableArray *itemTitles = [[NSMutableArray alloc] init];
	
	//add catch rate
	[items addObject: [NSString stringWithFormat: @"%d", pokemon.catchRate]];
	[itemTitles addObject: NSLocalizedString(@"Catch rate", nil)];
	
	//egg steps
	[items addObject: [NSString stringWithFormat: @"%d", pokemon.eggSteps]];
	[itemTitles addObject: NSLocalizedString(@"Egg steps", nil)];
	
	//exp yield
	[items addObject: [NSString stringWithFormat: @"%d", pokemon.expYield]];
	[itemTitles addObject: NSLocalizedString(@"Exp. yield", nil)];
	
	//add to view
	self.extraStatsValues = items;
	[items release];
	
	self.extraStatsTitles = itemTitles;
	[itemTitles release];
}

-(void) initExtra2StatsView
{
	//extraStatsView = [[TCTableViewStatsSplitCell alloc] initWithFrame: CGRectMake( 0, 0, 280, 45 )];
	
	NSMutableArray *items = [[NSMutableArray alloc] init];
	NSMutableArray *itemTitles = [[NSMutableArray alloc] init];
	
	//add Base Happiness
	[items addObject: [NSString stringWithFormat: @"%d", pokemon.baseHappiness]];
	[itemTitles addObject: NSLocalizedString(@"Base Happiness", nil)];
	
	//egg Lvl 100 XP
	[items addObject: pokemon.expAtLv100Value];
	[itemTitles addObject: NSLocalizedString(@"Exp. at Lv. 100", nil)];
	
	//add to view
	self.extra2StatsValues = items;
	[items release];
	
	self.extra2StatsTitles = itemTitles;
	[itemTitles release];
}

-(void) initGenderView
{
    //set up gender ratio view/table cell
	PokemonGenderRatioView *genderRatioView = [[PokemonGenderRatioView alloc] initWithFrame: CGRectMake( 0, 0, 280, 1 )];
	genderRatioView.genderRate = pokemon.genderRate;
    
    genderTableCell = [[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: TABLECELL_GENDER];
    genderTableCell.drawView = genderRatioView;
    genderTableCell.backgroundColor = [UIColor whiteColor];
    genderTableCell.drawView.frame = CGRectInset(genderTableCell.contentView.frame, 7.0f, 1.0f);
    genderTableCell.accessoryType = UITableViewCellAccessoryNone;
    genderTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [genderRatioView release];
    
    [genderTableCell.drawView setNeedsDisplay];
}

-(void) initEffortYieldView
{
    //create the EV view
	PokemonEffortYieldView *effortYieldView         = [[PokemonEffortYieldView alloc] initWithFrame: CGRectMake( 0, 0, 280, 1 )];
	effortYieldView.hp		= pokemon.stats.ev.hp;
	effortYieldView.atk		= pokemon.stats.ev.atk;
	effortYieldView.def		= pokemon.stats.ev.def;
	effortYieldView.spAtk	= pokemon.stats.ev.spAtk;
	effortYieldView.spDef	= pokemon.stats.ev.spDef;
	effortYieldView.speed	= pokemon.stats.ev.speed;
	
    //create a new table cell for it and add it
	evTableCell = [[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: TABLECELL_EV];
    evTableCell.drawView = effortYieldView;
    evTableCell.drawView.frame = CGRectInset(evTableCell.contentView.frame, 7.0f, 1.0f);
    evTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    evTableCell.accessoryType = UITableViewCellAccessoryNone;
    evTableCell.backgroundColor = [UIColor whiteColor];
    [effortYieldView release];
    
    [evTableCell.drawView setNeedsDisplay];
}

-(void) initExternalLinks
{
    PokemonExternalLinksView *externalLinksView = [[PokemonExternalLinksView alloc] initWithFrame: CGRectMake( 0, 0, 280, EXTERNAL_LINKS_HEIGHT )];
    externalLinksView.targetController = self.parentViewController;
    externalLinksView.generation = pokemon.generation;
    externalLinksView.backgroundColor = [UIColor whiteColor];

    if( LANGUAGE_IS_JAPANESE )
        [(PokemonExternalLinksView *)externalLinksView setPokemonName: pokemon.nameJP];
    else
        [(PokemonExternalLinksView *)externalLinksView setPokemonName: pokemon.name];
    
    [(PokemonExternalLinksView *)externalLinksView setPokemonNdex: pokemon.ndex];
    [(PokemonExternalLinksView *)externalLinksView setPokemonFormeShortName: pokemon.formeShortName];        

    linksTableCell = [[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: TABLECELL_LINKS];
    linksTableCell.backgroundColor = [UIColor whiteColor];
    linksTableCell.drawView = externalLinksView;
    linksTableCell.drawView.frame = CGRectInset(linksTableCell.contentView.frame, 7.0f, 7.0f);
    linksTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    linksTableCell.accessoryType = UITableViewCellAccessoryNone;
    [externalLinksView release];

    [linksTableCell.drawView setNeedsDisplay];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return TABLE_NUM_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch( section )
	{
		case SECTION_INFO:
			return 3;
		case SECTION_STATS:
            return 3;
		case SECTION_DEX_NUMBERS:
		case SECTION_GENDER_RATE:
		case SECTION_EV_STATS:
        case SECTION_EXTERNAL_LINKS:
			return 1;
	}
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return the number of rows in the section.
	switch( indexPath.section )
	{
        case SECTION_INFO:
            if( indexPath.row == 1 )
            {
                if( [pokemon.abilityHiddenName length] > 0 )
                return TWOLINE_HEIGHT;
            }
            break;
		case SECTION_GENDER_RATE:
			return [(PokemonGenderRatioView *)(genderTableCell.drawView) cellHeight]+1.0f;
            break;
		case SECTION_EV_STATS:
			return EFFORT_YIELD_CELL_HEIGHT+1.0f;
            break;
        case SECTION_EXTERNAL_LINKS:
            return EXTERNAL_LINKS_HEIGHT+10;
            break;
	}
	
	return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	switch ( indexPath.section )
	{
		case SECTION_DEX_NUMBERS:
            {
                TCTableViewCell *cell = (TCTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: TABLECELL_STATS];
                if( cell == nil )
                {
                    cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: TABLECELL_STATS] autorelease];
                    cell.drawView = [[[TCTableViewStatsSplitCell alloc] initWithFrame: cell.contentView.bounds] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                [(TCTableViewStatsSplitCell *)cell.drawView setItems: dexNumbersValues];
                [(TCTableViewStatsSplitCell *)cell.drawView setItemTitles: dexNumbersTitles];
                [(TCTableViewStatsSplitCell *)cell.drawView setDefaultText: NSLocalizedString( @"Not in any regional Pokédex", nil )];
                
                return cell;
            }
            break;
		case SECTION_STATS:
            {    
                TCTableViewCell *cell = (TCTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: TABLECELL_STATS];
                if( cell == nil )
                {
                    cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: TABLECELL_STATS] autorelease];
                    cell.drawView = [[[TCTableViewStatsSplitCell alloc] initWithFrame: cell.contentView.bounds] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                switch( indexPath.row) 
                {
                    case 0:
                        [(TCTableViewStatsSplitCell *)cell.drawView setItems: weightHeightValues];
                        [(TCTableViewStatsSplitCell *)cell.drawView setItemTitles: weightHeightTitles];
                        break;
                    case 1:
                        [(TCTableViewStatsSplitCell *)cell.drawView setItems: extraStatsValues];
                        [(TCTableViewStatsSplitCell *)cell.drawView setItemTitles: extraStatsTitles];
                        break;
                    case 2:
                        [(TCTableViewStatsSplitCell *)cell.drawView setItems: extra2StatsValues];
                        [(TCTableViewStatsSplitCell *)cell.drawView setItemTitles: extra2StatsTitles];
                        break;
                }
                
                return cell;
            }
            break;
		case SECTION_GENDER_RATE:
			return genderTableCell;
			break;
		case SECTION_EV_STATS:
			return evTableCell;
			break;
		case SECTION_INFO:
            {    
                UITableViewCellStyle2 *cell = (UITableViewCellStyle2 *)[_tableView dequeueReusableCellWithIdentifier:TABLECELL_STANDARD];
                if (cell == nil) {
                    cell = [[[UITableViewCellStyle2 alloc] initWithReuseIdentifier: TABLECELL_STANDARD] autorelease];
                    
                    //customize the elements so they're a bit bigger
                    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize: 17.0f];
                    cell.textLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                switch( indexPath.row )
                {
                    case 0:
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        cell.textLabel.text = NSLocalizedString( @"Species", nil);
                        cell.detailTextLabel.text = pokemon.species;
                        cell.text2Label.hidden = YES;
                        
                        break;
                    case 1:
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.text2Label.text = nil;
                        
                        cell.textLabel.text = NSLocalizedString( @"Abilities", nil);
                        if( pokemon.ability2ID > 0 )
                            cell.detailTextLabel.text = [NSString stringWithFormat: @"%@, %@", pokemon.ability1Name, pokemon.ability2Name];
                        else	
                            cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", pokemon.ability1Name];
                    
                        if( [pokemon.abilityHiddenName length] > 0 )
                        {
                            cell.text2Label.hidden = NO;
                            cell.text2Label.text = [NSString stringWithFormat: NSLocalizedString(@"%@ (Hidden)", nil), pokemon.abilityHiddenName];
                        }
                        else
                            cell.text2Label.hidden = YES;
                            
                        break;
                    case 2:
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        cell.text2Label.hidden = YES;
                        cell.backgroundColor = [UIColor whiteColor];
                        
                        cell.textLabel.text = NSLocalizedString( @"Egg Groups", nil );
                        if( pokemon.eggGroup2ID > 0 )
                            cell.detailTextLabel.text = [NSString stringWithFormat: @"%@, %@", pokemon.eggGroup1Name, pokemon.eggGroup2Name];
                        else	
                            cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", pokemon.eggGroup1Name];
                        break;
                    }
                
                return cell;
            }
            break;
        case SECTION_EXTERNAL_LINKS:
            return linksTableCell;
            break;
	}
	
    UITableViewCellStyle2 *cell = (UITableViewCellStyle2 *)[_tableView dequeueReusableCellWithIdentifier:TABLECELL_STANDARD];
    if (cell == nil) {
        cell = [[[UITableViewCellStyle2 alloc] initWithReuseIdentifier: TABLECELL_STANDARD] autorelease];
    }    
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if( indexPath.section != SECTION_INFO )
		return;
	
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];

	switch (indexPath.row) {
		case 1:
			[self abilityTransition];
			break;
		case 2:
			[self eggGroupTransition];
			break;
	}
}

#pragma mark -
#pragma mark ActionSheet methods

- (void)eggGroupTransition
{
	//if there is no secondary egg group, just push to the first egg group
	if( pokemon.eggGroup2ID == 0 )
	{
		EggGroupMainViewController *eggController = [[EggGroupMainViewController alloc] initWithEggGroup1ID: pokemon.eggGroup1ID];
		[self.parentViewController.navigationController pushViewController: eggController animated: YES];
		[eggController release];
		
		return;
	}
	
	//at this point, it means there are 2 egg groups, so present the user with a choice
	eggGroupPrompt = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: NSLocalizedString(@"Cancel", nil) destructiveButtonTitle: nil otherButtonTitles: NSLocalizedString(@"Both", nil), pokemon.eggGroup1Name, pokemon.eggGroup2Name, nil];
	[eggGroupPrompt showInView: self.parentViewController.view];
}

- (void)abilityTransition
{
	//if there is no secondary egg group, just push to the first egg group
	if( pokemon.ability2ID == 0 && pokemon.abilityHiddenID == 0 )
	{
		AbilityProfileTabController *abilityController = [[AbilityProfileTabController alloc] initWithDatabaseID: pokemon.ability1ID abilityEntry: nil];
		[self.parentViewController.navigationController pushViewController: abilityController animated: YES];
		[abilityController release];
		
		return;
	}
	
	//at this point, it means there are 2 egg groups, so present the user with a choice
    
	abilityPrompt = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: nil destructiveButtonTitle: nil otherButtonTitles: nil];
	
    NSInteger buttonCount = 1;
    
    [abilityPrompt addButtonWithTitle: pokemon.ability1Name];
    if( [pokemon.ability2Name length] )
    {
        [abilityPrompt addButtonWithTitle: pokemon.ability2Name];
        buttonCount++;
    }
    
    if( [pokemon.abilityHiddenName length] )
    {
        [abilityPrompt addButtonWithTitle: pokemon.abilityHiddenName];
        buttonCount++;
    }
    
    [abilityPrompt addButtonWithTitle: NSLocalizedString(@"Cancel", nil)];
    abilityPrompt.cancelButtonIndex = buttonCount;
    
    [abilityPrompt showInView: self.parentViewController.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger id1=0;
	NSInteger id2=0;
	
	if( [actionSheet isEqual: eggGroupPrompt] )
	{
        //release the prompt object
        //(Won't need it since it closes itself anyway)
		self.eggGroupPrompt = nil;
        
		//find out which button was pressed
		switch (buttonIndex) {
			case 0: //Both
				id1 = pokemon.eggGroup1ID;
				id2 = pokemon.eggGroup2ID;
				break;
			case 1: //first
				id1 = pokemon.eggGroup1ID;
				break;
			case 2: //second
				id1 = pokemon.eggGroup2ID;
				break;
			default: //cancel
				return;
		}
		
		//push the new egg controller
		EggGroupMainViewController *eggController = [[EggGroupMainViewController alloc] initWithEggGroup1ID: id1 eggGroup2ID: id2];
		[self.parentViewController.navigationController pushViewController: eggController animated: YES];
		[eggController release];
	}
	else if( [actionSheet isEqual: abilityPrompt] )
	{
        //release the prompt object
		self.abilityPrompt = nil;
        
		//find out which button was pressed
		switch (buttonIndex) {
			case 0: //first - will always be an ability
				id1 = pokemon.ability1ID;
				break;
			case 1: //second - could be the Pokemon's second ability, or hidden ability
                if( pokemon.ability2ID > 0 )
                    id1 = pokemon.ability2ID;
                else
                    id1 = pokemon.abilityHiddenID;
				break;
            case 2: //third - could be the Pokemon's hidden ability, or the cancel button
                if( pokemon.ability2ID > 0) //if there is a second ability, this is a hidden one
                    id1 = pokemon.abilityHiddenID;
                else //else this is the cancel button
                    return;
                break;
			default: //cancel
				return;
		}
		
		//push the new egg controller
		AbilityProfileTabController *abilityController = [[AbilityProfileTabController alloc] initWithDatabaseID: id1 abilityEntry: nil];
		[self.parentViewController.navigationController pushViewController: abilityController animated: YES];
		[abilityController release];
	}
}

#pragma mark - 
#pragma mark Cry Button
- (void)cryButtonPressed: (id)sender
{ 
    if( cryPlayer == nil )
        cryPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: self.cryFilePath] error: nil];
    
    if( cryPlayer.playing )
    {
        [cryPlayer stop];
        [cryPlayer setCurrentTime: 0.0f];
    }
    
    [cryPlayer prepareToPlay];
    [cryPlayer play];
}

#pragma mark -
#pragma mark Speech
#ifdef PRIVATE_APIS_ARE_COOL
- (void)speechButtonPressed:(id)sender
{
    if( pokedexSpeech == nil )
        pokedexSpeech = [[iPokedexSpeechSynthesizer alloc] init];
    
    NSString *pokemonName = nil;
    if( LANGUAGE_IS_JAPANESE )
        pokemonName = pokemon.nameJP;
    else
        pokemonName = pokemon.namePhonetic;
    
    NSString *pokeDexString = [PokemonEntryFinder pokemonRandomDexTextWithNdexID: pokemon.ndex];
    NSString *speechString = [NSString stringWithFormat: NSLocalizedString( @"%@. The %@. %@", nil ), pokemonName, pokemon.species, pokeDexString];
    
    [pokedexSpeech speakPokedexString: speechString];
}
#endif

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    self.cryPlayer = nil;
    
#ifdef PRIVATE_APIS_ARE_COOL
    self.pokedexSpeech = nil;
#endif
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
	[super viewDidUnload];
}

- (void)dealloc {
    [dexNumbersTitles release];
    [dexNumbersValues release]; 
    [weightHeightTitles release]; 
    [weightHeightValues release]; 
    [extraStatsTitles release];
    [extraStatsValues release];
    
    [genderTableCell release];
    [evTableCell release];
    [linksTableCell release];
    
	[pokemon release];
    [eggGroupPrompt release];
	[abilityPrompt release];
    
    [cryFilePath release];
    [cryPlayer release];
    
#ifdef PRIVATE_APIS_ARE_COOL
    [pokedexSpeech release];
#endif 
    
    [super dealloc];
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"";
}

@end

