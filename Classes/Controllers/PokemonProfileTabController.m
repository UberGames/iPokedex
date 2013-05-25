    //
//  PokemonInfoTabController.m
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

#define EGORAPTOR_CHARMANDER 4

#import "PokemonProfileTabController.h"
#import "Favorites.h"
#import "UIImage+TabIcon.h"
#import "GANTracker.h"
#import "UIDevice+VersionTracker.h"
#import "UIViewController+TagTitle.h"

//Move along. Nothing to see here
#import "Egoraptor.h"

@interface PokemonProfileTabController ()

- (void)CHARMANDER;

@end

@implementation PokemonProfileTabController

@synthesize dbID;
@synthesize mainViewController;
@synthesize egoraptorAcknowledger;
@synthesize webTitle;

-(id)initWithDatabaseID: (NSInteger) databaseID pokemonEntry: (PokemonListEntry *)_pokemon
{
	if( (self = [super init]) )
	{
		//save the pokemon DB ID
		self.dbID = databaseID;
        self.delegate = self;

		//load Pokemon title info
		PokemonListEntry *pokemon;
		if( _pokemon == nil )
			pokemon = [PokemonEntryFinder pokemonWithDatabaseID: self.dbID];
		else 
			pokemon = _pokemon;

		BOOL hasEvolutions = [PokemonEntryFinder pokemonHasEvolutionsWithDatabaseID: self.dbID];
		
		//set the view title
		self.title = pokemon.name;
        self.webTitle = [pokemon webName];
        
		//Init the subview controllers
        
        //Main Profile
		mainViewController = [[PokemonProfileMainViewController alloc] initWithDatabaseID: dbID];
		
        //Stats
		statsViewController = [[PokemonProfileStatsViewController alloc] initWithDatabaseID: dbID];
		
        //Moves
		movesViewController = [[PokemonProfileMovesViewController alloc] initWithDatabaseID: dbID];	
	
        //Evolutions
		evolutionsViewController = [[PokemonProfileEvolutionsViewController alloc] initWithDatabaseID: dbID];
		evolutionsViewController.tabBarItem.enabled = hasEvolutions;
		
        //Pokedex
		pokedexViewController = [[PokemonProfilePokedexViewController alloc] initWithDatabaseID: dbID];
	}
	
	return self;	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Insert the controllers into the tab bar
    self.viewControllers = [NSArray arrayWithObjects: mainViewController, statsViewController, movesViewController, evolutionsViewController, pokedexViewController, nil];
    
    //What is this? I don't even
    if( dbID == EGORAPTOR_CHARMANDER && [[UIDevice currentDevice] isIOS3] == NO )
    {
        egoraptorAcknowledger = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(CHARMANDER)];
        egoraptorAcknowledger.numberOfTapsRequired = 5;
        
        [self.view addGestureRecognizer: egoraptorAcknowledger];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //set up the favorites bar
    self.rightBarButtonItem = [[Favorites sharedFavorites] barButtonForPokemonWithPokemonID: dbID target: self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    //if user set autoplay cries (and we are currently showing the Pokémon tab), trigger that cry now
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"autoplayCries"] && 
        cryHasBeenAutoPlayed == NO)
    {
        [mainViewController cryButtonPressed: self];
        cryHasBeenAutoPlayed = YES;
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mainViewController release];
    [statsViewController release];
    [movesViewController release];
    [evolutionsViewController release];
    [pokedexViewController release];
    [egoraptorAcknowledger release];
    [webTitle release];
    
    [super dealloc];
}

#pragma mark Favorites
-(void) favoritesTapped: (id)sender
{
    //toggle the favorites
    BOOL result = [[Favorites sharedFavorites] toggleFavoritePokemonWithPokemonID: dbID fromController: self];
    //update the icon
    [[Favorites sharedFavorites] toggleFavoriteIconInBarButton: self.rightBarButtonItem withResult: result];
}

#pragma mark TabController Events
- (void)tabBarItemDidAppear: (UITabBarItem *)tabBarItem;
{
    UIViewController *controller = [self viewControllerForTabBarItem: tabBarItem];
    NSString *tagTitle = [controller tagTitle];
    
    NSString *logTitle = [NSString stringWithFormat: @"/Pokémon/%@", webTitle];
    if( [tagTitle length] > 0 )
        logTitle = [logTitle stringByAppendingFormat: @"/%@", tagTitle];
    
    //add to next Google Analytics Batch
    [[GANTracker sharedTracker] trackPageview: logTitle withError: nil];
    
    //NSLog( @"Logged GAN Dispatch: %@", logTitle );
}

- (void)CHARMANDER
{
    [[Egoraptor sharedRaptor] performAwesomeness];
}
                                     
@end
