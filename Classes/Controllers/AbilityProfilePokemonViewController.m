//
//  AbilityProfilePokemonViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 13/03/11.
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

#import "AbilityProfilePokemonViewController.h"
#import "UIImage+TabIcon.h"

@implementation AbilityProfilePokemonViewController

@synthesize abilityID;

- (id)initWithDatabaseID: (NSInteger) _abilityID
{
	if( (self = [super init]) )
	{
		self.abilityID = _abilityID;
        
        self.tabBarItem.title = NSLocalizedString( @"Pokémon", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Pokeball"];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	pokemonFinder.abilityID = abilityID;
    //override any default sort settings
    pokemonFinder.dexId = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"Pokémon";
}

@end
