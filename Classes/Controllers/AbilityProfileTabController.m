//
//  AbilityProfileTabController.m
//  iPokedex
//
//  Created by Timothy Oliver on 12/03/11.
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

#import "AbilityProfileTabController.h"
#import "Favorites.h"
#import "UIViewController+TagTitle.h"

@implementation AbilityProfileTabController

@synthesize dbID, webTitle;

- (id) initWithDatabaseID: (NSInteger) databaseID abilityEntry: (ListEntry *)_ability
{
	if( (self = [super init]) )
	{
		//save the move DB ID
		self.dbID = databaseID;
        self.delegate = self;
		
		//load Move title info
		ListEntry *ability;
		if( _ability == nil )
			ability = [AbilityEntryFinder abilityWithDatabaseID: dbID];
		else 
			ability = _ability;
		
		//set the view title
		self.title = ability.name;
		self.webTitle = [ability webName];
        
        //Init the subview controllers
		//Main
        mainViewController = [[AbilityProfileMainViewController alloc] initWithDatabaseID: dbID];
		//Pokemon
		pokemonViewController = [[AbilityProfilePokemonViewController alloc] initWithDatabaseID: dbID];
	}
	
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //insert the subcontrollers into the tab controller
    self.viewControllers = [NSArray arrayWithObjects: mainViewController, pokemonViewController, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //set up the favorites bar
    self.rightBarButtonItem = [[Favorites sharedFavorites] barButtonForAbilityWithAbilityID: dbID target: self];
}

- (void)dealloc {
	[webTitle release];
    [mainViewController release];
    [pokemonViewController release];
    
    [super dealloc];
}

#pragma mark Favorites
- (void)favoritesTapped: (id)sender
{
    //toggle the favorites
    BOOL result = [[Favorites sharedFavorites] toggleFavoriteAbilityWithAbilityID: dbID fromController: self];
    //update the icon
    [[Favorites sharedFavorites] toggleFavoriteIconInBarButton: self.rightBarButtonItem withResult: result];
}

#pragma mark TabController Events
#pragma mark TabController Events
- (void)tabBarItemDidAppear: (UITabBarItem *)tabBarItem;
{
    UIViewController *controller = [self viewControllerForTabBarItem: tabBarItem];
    NSString *tagTitle = [controller tagTitle];
    
    NSString *logTitle = [NSString stringWithFormat: @"/Ability/%@", webTitle];
    if( [tagTitle length] > 0 )
        logTitle = [logTitle stringByAppendingFormat: @"/%@", tagTitle];
    
    //add to next Google Analytics Batch
    [[GANTracker sharedTracker] trackPageview: logTitle withError: nil];
    
    //NSLog( @"Logged GAN Dispatch: %@", logTitle );
}

@end
