//
//  PokemonTableCellContentView.h
//  iPokedex
//
//  Created by Timothy Oliver on 9/02/11.
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
#import "TableCellContentView.h"

#define POKEMON_DEXTYPES_WIDTH 80

@interface PokemonTableCellContentView : TableCellContentView {
    
	UIImage		*type1Image;
	UIImage		*type2Image;
	
	NSInteger	nDexNum;
	NSInteger	regionDexNum;
	NSString	*dexNumValue;
}

@property (nonatomic, retain) UIImage   *type1Image;
@property (nonatomic, retain) UIImage   *type2Image;
@property (nonatomic, assign) NSInteger nDexNum;
@property (nonatomic, assign) NSInteger regionDexNum;
@property (nonatomic, retain) NSString  *dexNumValue;

@end
