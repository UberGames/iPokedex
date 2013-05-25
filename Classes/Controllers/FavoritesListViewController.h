//
//  NewFavoritesListViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 15/06/11.
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

#import <Foundation/Foundation.h>
#import "TCSegmentedListController.h"

typedef enum {
    FavoritesTypePokemon=0,
    FavoritesTypeMoves,
    FavoritesTypeAbilities,
    FavoritesTypeEggGroups,
    
    FavoritesTypeMax
} FavoritesTypes;

@interface FavoritesListViewController : TCSegmentedListController  {
    //Data needed to render information about Pokemon and moves
	NSDictionary *elementalTypes;
    NSDictionary *moveCategories;
	
	//Used to tell which section conforms to which favorite type
	NSMutableArray *sectionTypes;
}

@property (nonatomic, retain) NSDictionary *elementalTypes;
@property (nonatomic, retain) NSDictionary *moveCategories;

@property (nonatomic, retain) NSMutableArray *sectionTypes;

@end
