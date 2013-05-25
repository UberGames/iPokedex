//
//  PokemonInfoTabController.h
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

#import <UIKit/UIKit.h>
#import "TCTabBarController.h"
#import "PokemonProfileMainViewController.h"
#import "PokemonProfileStatsViewController.h"
#import "PokemonProfileMovesViewController.h"
#import "PokemonProfileEvolutionsViewController.h"
#import "PokemonProfilePokedexViewController.h"
#import "PokemonEntryFinder.h"

@interface PokemonProfileTabController : TCTabBarController <UINavigationBarDelegate, UITabBarDelegate, TCTabBarControllerDelegate> {
	NSInteger dbID;
    UITapGestureRecognizer *egoraptorAcknowledger;
    
    NSString *webTitle;
    
    //make sure we only play the cry once. It gets reeeeally annoying after that
    BOOL cryHasBeenAutoPlayed;
    
    PokemonProfileMainViewController        *mainViewController;
    PokemonProfileStatsViewController       *statsViewController;
    PokemonProfileMovesViewController       *movesViewController;
    PokemonProfileEvolutionsViewController  *evolutionsViewController;
    PokemonProfilePokedexViewController     *pokedexViewController;
}

-(id)initWithDatabaseID: (NSInteger) databaseID pokemonEntry: (PokemonListEntry *)_pokemon;

@property (nonatomic, assign) NSInteger dbID;
@property (nonatomic, retain) PokemonProfileMainViewController *mainViewController;
@property (nonatomic, retain) NSString *webTitle;

@property (nonatomic, retain) UITapGestureRecognizer *egoraptorAcknowledger;

@end
