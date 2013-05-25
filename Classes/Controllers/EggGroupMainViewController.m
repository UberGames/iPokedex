//
//  EggGroupMainViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/03/11.
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

#define NO_EGGS 0 

#import "EggGroupMainViewController.h"
#import "GANTracker.h"
#import "Favorites.h"

@implementation EggGroupMainViewController

@synthesize egg1ID, egg2ID;

#pragma mark -
#pragma mark Initialization

- (id)initWithEggGroup1ID: (NSInteger) group1ID
{
	if( (self = [super init]) )
	{
		self.egg1ID = group1ID;
	}
	
	return self;
}

- (id)initWithEggGroup1ID: (NSInteger) group1ID eggGroup2ID: (NSInteger)group2ID
{
	if( (self = [super init]) )
	{
		self.egg1ID = group1ID;
		self.egg2ID = group2ID;
	}
	
	return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    deferIconLoading = YES;
    
	pokemonFinder.eggGroup1ID = egg1ID;
	pokemonFinder.eggGroup2ID = egg2ID;
    
    //force the regiondex back to 0 (in case settings is overriding it)
	pokemonFinder.dexId = 0;
    
	self.title = [EggGroupEntryFinder titleWithEggGroup1ID: egg1ID eggGroup2ID: egg2ID];
    
    if( egg1ID == 15 )
        self.tableMessage = NSLocalizedString( @"No Eggs Pokémon cannot be bred.", nil);
    else if ( egg1ID == 13 && egg2ID == 0 )
        self.tableMessage = NSLocalizedString( @"Ditto can breed with any other egg group (excluding No Eggs).", nil );
    else
        self.tableMessage = @"";
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //set up the favorites bar
    if( egg2ID == 0 )
        self.navigationItem.rightBarButtonItem = [[Favorites sharedFavorites] barButtonForEggGroupWithEggGroupID: egg1ID target: self];
}

#pragma mark Favorites
-(void) favoritesTapped: (id)sender
{
    //toggle the favorites
    BOOL result = [[Favorites sharedFavorites] toggleFavoriteEggGroupWithEggGroupID: egg1ID fromController: self];
    //update the icon
    [[Favorites sharedFavorites] toggleFavoriteIconInBarButton: self.navigationItem.rightBarButtonItem withResult: result];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    NSString *webName = [self.title stringByReplacingOccurrencesOfString: @" " withString: @"_"];
    NSString *logTitle = [NSString stringWithFormat: @"/Egg_Groups/%@", webName];
    [[GANTracker sharedTracker] trackPageview: logTitle withError: nil];
    //NSLog( @"Logged GAN Dispatch: %@", logTitle );
}

@end

