//
//  MoveProfilePokemonViewController.h
//  iPokedex
//
//  Created by Tim Oliver on 4/03/11.
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

#import <UIKit/UIKit.h>
#import "TCSegmentedListController.h"
#import "MoveEntryFinder.h"
#import "PokemonEntryFinder.h"
#import "TechnicalMachineFinder.h"
#import "Generations.h"
#import "GameVersions.h"
#import "ElementalTypes.h"
#import "PokemonTableCellContentView.h"
#import "PokemonProfileTabController.h"

@interface MoveProfilePokemonViewController : TCSegmentedListController {
	NSInteger dbID;
	NSInteger moveGeneration;
	
	NSDictionary *elementalTypes;
	NSDictionary *generations;
	
	PokemonEntryFinder *pokemonFinder;
	TechnicalMachineFinder *tmFinder;
	
	TechnicalMachineListEntry *tmHeaderEntry;
	
	UIView *headerBGView;
    
    UIImage *defaultIcon;
}

- (id)initWithDatabaseID: (NSInteger)databaseID;

@property (nonatomic, assign) NSInteger dbID;
@property (nonatomic, assign) NSInteger moveGeneration;

@property (nonatomic, retain) NSDictionary *elementalTypes;
@property (nonatomic, retain) NSDictionary *generations;

@property (nonatomic, retain) PokemonEntryFinder *pokemonFinder;
@property (nonatomic, retain) TechnicalMachineFinder *tmFinder;
@property (nonatomic, retain) TechnicalMachineListEntry *tmHeaderEntry;

@property (nonatomic, retain) UIView *headerBGView;

@property (nonatomic, retain) UIImage *defaultIcon;

@end
