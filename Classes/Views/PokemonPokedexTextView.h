//
//  PokemonPokedexTextView.h
//  iPokedex
//
//  Created by Timothy Oliver on 17/02/11.
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
#import "TextBoxContentView.h"

#define POKEDEX_GAMELABELS_HEIGHT 23
#define POKEDEX_TEXT_PADDING 15


#define POKEDEX_TITLE_FONT_SIZE 17.0f
#define POKEDEX_FONT_SIZE 17.0f

@interface PokemonPokedexTextView : TextBoxContentView {

	NSArray *versionNames;
	NSArray *versionColors;
}

+ (CGFloat) cellHeightWithWidth: (CGFloat)width text: (NSString *)text;

@property (nonatomic, retain) NSArray *versionNames;
@property (nonatomic, retain) NSArray *versionColors;

@end
