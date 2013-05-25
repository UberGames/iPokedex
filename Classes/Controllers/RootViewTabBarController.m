//
//  RootViewController.m
//  ;
//
//  Created by Timothy Oliver on 16/11/10.
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

#import "GANTracker.h"
#import "RootViewTabBarController.h"
#import "UIImage+TabIcon.h"
#import "UIViewController+TagTitle.h"

@implementation RootViewTabBarController

#pragma mark ViewController Class Lifecycle 

-(id) initWithCoder:(NSCoder *)aDecoder
{
	if( (self = [super initWithCoder: aDecoder]) )
	{
		//string identifier used to save tab order to disk
		self.saveIdentifier = @"iPokedexRoot";
		self.persistantTabOrder = YES;
        self.delegate = self;
        
        //init the tab objects
        //Pokémon tab
        pokemonViewController   = [[PokemonListViewController alloc] init];
        
        //Moves tab
        moveViewController      = [[MoveListViewController alloc] init];
        
        //Favorites tab
        favoritesViewController = [[FavoritesListViewController alloc] init];

        //Abilities
        abilityViewController   = [[AbilityListViewController alloc] init];
        
        //Egg Groups
        eggGroupsViewController = [[EggGroupsListViewController alloc] init];
        
        //Settings
        settingsViewController  = [[SettingsViewController alloc] init];
    }
	
	return self;
}

- (void)viewDidLoad
{ 
    [super viewDidLoad]; 
    
    self.viewControllers = [NSArray arrayWithObjects: pokemonViewController, moveViewController, abilityViewController, favoritesViewController, eggGroupsViewController, settingsViewController, nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
}

- (void)dealloc {	
    [super dealloc];

    [pokemonViewController release];
    [abilityViewController release];
    [moveViewController release];
    [favoritesViewController release];
    [eggGroupsViewController release];
    [settingsViewController release];
}

#pragma mark TabController Events
- (void)tabBarItemDidAppear: (UITabBarItem *)tabBarItem;
{
    UIViewController *controller = [self viewControllerForTabBarItem: tabBarItem];
    
 	//log the access of this tag to Google Analytics
	if ( [controller tagTitle] )
	{
		NSString *logTitle = [NSString stringWithFormat: @"/iPokédex/%@", [controller tagTitle]];
		[[GANTracker sharedTracker] trackPageview: logTitle withError: nil];
		//NSLog( @"Logged GAN Dispatch: %@", logTitle );
	}
}

@end
