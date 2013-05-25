//
//  MoveProfileTabController.m
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

#import "MoveProfileTabController.h"
#import "Favorites.h"
#import "UIViewController+TagTitle.h"

@implementation MoveProfileTabController

@synthesize dbID, webTitle;

- (id)initWithDatabaseID: (NSInteger) databaseID moveEntry: (MoveListEntry *)_move
{
	if( (self = [super init]) )
	{
		//save the move DB ID
		self.dbID = databaseID;
		self.delegate = self;
        
		//load Move title info
		MoveListEntry *move;
		if( _move == nil )
			move = [MoveEntryFinder moveWithDatabaseID: dbID];
		else 
			move = _move;
		
		//set the view title
		self.title = move.name;
		self.webTitle = [move webName];
        
		//Init the subview controllers
        
        //Main View Controller
		mainViewController = [[MoveProfileMainViewController alloc] initWithDatabaseID: dbID];
		//Pokemon List View Controller
        pokemonViewController = [[MoveProfilePokemonViewController alloc] initWithDatabaseID: dbID];
	}
	
	return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //insert the subcontrollers into the tab controller
    self.viewControllers = [NSArray arrayWithObjects: mainViewController, pokemonViewController, nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //set up the favorites bar
    self.rightBarButtonItem = [[Favorites sharedFavorites] barButtonForMoveWithMoveID: dbID target: self];
}

- (void)dealloc {
    [mainViewController release];
    [pokemonViewController release];
    
    [super dealloc];
}

#pragma mark Favorites
-(void) favoritesTapped: (id)sender
{
    //toggle the favorites
    BOOL result = [[Favorites sharedFavorites] toggleFavoriteMoveWithMoveID: dbID fromController: self];
    //update the icon
    [[Favorites sharedFavorites] toggleFavoriteIconInBarButton: self.rightBarButtonItem withResult: result];
}

#pragma mark TabController Events
- (void)tabBarItemDidAppear: (UITabBarItem *)tabBarItem;
{
    UIViewController *controller = [self viewControllerForTabBarItem: tabBarItem];
    NSString *tagTitle = [controller tagTitle];
    
    NSString *logTitle = [NSString stringWithFormat: @"/Moves/%@", webTitle];
    if( [tagTitle length] > 0 )
        logTitle = [logTitle stringByAppendingFormat: @"/%@", tagTitle];

    //add to next Google Analytics Batch
    [[GANTracker sharedTracker] trackPageview: logTitle withError: nil];
    
    //NSLog( @"Logged GAN Dispatch: %@", logTitle );
}

@end
