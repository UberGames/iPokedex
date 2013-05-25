//
//  PokemonTabViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 18/11/10.
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

#import "TCSearchableListViewController.h"
#import "PokemonEntryFinder.h"

@interface PokemonListViewController : TCSearchableListViewController {
	UIImage *defaultIcon;
	
	//the object that will query the database for results
	PokemonEntryFinder *pokemonFinder;
	
	NSDictionary *regions;
	NSDictionary *types;
	NSArray *sortOrder;

	PokemonEntryCaption entryCaption;
	PokemonEntryCaption searchEntryCaption;
    
    BOOL smugleafMode; //derp
}

@property (nonatomic, retain) UIImage *defaultIcon;
@property (nonatomic, retain) NSDictionary *regions;
@property (nonatomic, retain) NSDictionary *types;
@property (nonatomic, retain) NSArray *sortOrder;
@property (retain, nonatomic) PokemonEntryFinder *pokemonFinder;
@property (nonatomic, assign) PokemonEntryCaption entryCaption;
@property (nonatomic, assign) PokemonEntryCaption searchEntryCaption;

@end
