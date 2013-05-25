//
//  iPokedexLegacyHandler.m
//  iPokedex
//
//  Created by Timothy Oliver on 3/05/11.
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

#import "iPokedexLegacyHandler.h"
#import "Favorites.h"
#import "PokemonEntryFinder.h"
#import "EggGroupEntryFinder.h"
#import "Bulbadex.h"

#define USERDEFAULTS_FAVORITES @"Favorites"

@implementation iPokedexLegacyHandler

+ (BOOL)migrateFavoritesToNewVersion
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //load the favorites list
    NSMutableDictionary *favorites = [NSMutableDictionary dictionaryWithDictionary: [userDefaults objectForKey: USERDEFAULTS_FAVORITES]];
    if( favorites == nil ) //User hasn't got any favorites saved
        return YES;
    
    //handle Pokemon
    NSMutableArray *favoritePokemon = [NSMutableArray arrayWithArray: [favorites objectForKey: FAVORITES_POKEMON]];
    NSDictionary *newPokemonIDs = [PokemonEntryFinder pokemonWithLegacyDatabaseIDList: favoritePokemon];
    
    if( [newPokemonIDs count] > 0 )
    {
        //go through each entry in the pokemon favorites and replace the old ID with the new one
        for( NSInteger i = 0; i < [favoritePokemon count]; i++  )
        {
            NSNumber *pokemonID = [favoritePokemon objectAtIndex: i];
            NSNumber *newID = [newPokemonIDs objectForKey: pokemonID];
            
            if( newID != nil )
                [favoritePokemon replaceObjectAtIndex: i withObject: newID];
        }
        
        //re-add to the favorites dictionary
        [favorites setObject: favoritePokemon forKey: FAVORITES_POKEMON];
    }

    //handle egg groups
    NSMutableArray *favoriteEggs = [NSMutableArray arrayWithArray: [favorites objectForKey: FAVORITES_EGGGROUPS]];
    NSDictionary *newEggIDs = [EggGroupEntryFinder eggGroupsWithLegacyDatabaseIDList: favoriteEggs];
    
    if( [newEggIDs count] > 0 )
    {
        for( NSInteger i = 0; i < [favoriteEggs count]; i++ )
        {
            NSNumber *eggID = [favoriteEggs objectAtIndex: i];
            NSNumber *newEggID = [newEggIDs objectForKey: eggID];
            
            if( newEggID != nil )
                [favoriteEggs replaceObjectAtIndex: i withObject: newEggID];
        }
        
        [favorites setObject: favoriteEggs forKey: FAVORITES_EGGGROUPS];
    }
    
    //save the new data to user favorites
    [userDefaults setObject: favorites forKey: USERDEFAULTS_FAVORITES];
    [userDefaults synchronize];
    
    return YES;
}

+ (BOOL) shouldSyncronizeCurrentVersion: (NSString *)currentVersion fromVersion: (NSString *)oldVersion
{
    return [iPokedexLegacyHandler migrateFavoritesToNewVersion];
}

@end
