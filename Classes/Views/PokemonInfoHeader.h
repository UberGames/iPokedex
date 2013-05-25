//
//  PokemonInfoHeader.h
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
#import "TCBeveledButton.h"

@interface PokemonInfoHeader : UIView {
	UIImage *pokemonPic;
	
	NSString *pokemonName;
	NSString *pokemonLangName;
	NSString *pokemonForme;
	
	UIImage *type1Image;
	UIImage *type2Image;
	
	NSString *nDex;
    
    TCBeveledButton *cryButton;
    
#ifdef PRIVATE_APIS_ARE_COOL
    TCBeveledButton  *speechButton;
#endif
}

@property (nonatomic, retain) UIImage *pokemonPic;

@property (nonatomic, retain) NSString *pokemonName;
@property (nonatomic, retain) NSString *pokemonLangName;
@property (nonatomic, retain) NSString *pokemonForme;

@property (nonatomic, retain) UIImage *type1Image;
@property (nonatomic, retain) UIImage *type2Image;

@property (nonatomic, retain) NSString *nDex;

@property (nonatomic, retain) TCBeveledButton *cryButton;

#ifdef PRIVATE_APIS_ARE_COOL
@property (nonatomic, retain) TCBeveledButton *speechButton;
#endif

@end
