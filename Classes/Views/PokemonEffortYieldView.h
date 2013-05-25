//
//  PokemonEffortYieldView.h
//  iPokedex
//
//  Created by Timothy Oliver on 16/01/11.
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
#import "PokemonStats.h"
#import "RoundedRectView.h"

#define EFFORT_YIELD_CELL_HEIGHT 80

@interface PokemonEffortYieldView : UIView {
	NSInteger hp;
	NSInteger atk;
	NSInteger def;
	NSInteger spAtk;
	NSInteger spDef;
	NSInteger speed;
	
    NSArray *titleTexts;
    NSArray *titleImages;
    
	NSArray *valueStrings;
    
    UIImage *hpImage;
    UIImage *atkImage;
    UIImage *defImage;
    UIImage *spAtkImage;
    UIImage *spDefImage;
    UIImage *speedImage;
}

@property (nonatomic, assign) NSInteger hp;
@property (nonatomic, assign) NSInteger atk;
@property (nonatomic, assign) NSInteger def;
@property (nonatomic, assign) NSInteger spAtk;
@property (nonatomic, assign) NSInteger spDef;
@property (nonatomic, assign) NSInteger speed;

@property (nonatomic, retain) NSArray *titleTexts;
@property (nonatomic, retain) NSArray *titleImages;

@property (nonatomic, retain) NSArray *valueStrings;

@property (nonatomic, retain) UIImage *hpImage;
@property (nonatomic, retain) UIImage *atkImage;
@property (nonatomic, retain) UIImage *defImage;
@property (nonatomic, retain) UIImage *spAtkImage;
@property (nonatomic, retain) UIImage *spDefImage;
@property (nonatomic, retain) UIImage *speedImage;

@end
