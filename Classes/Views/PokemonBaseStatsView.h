//
//  PokemonBaseStatsView.h
//  iPokedex
//
//  Created by Timothy Oliver on 25/01/11.
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

#define BASE_STATS_CELL_HEIGHT 198

@interface PokemonBaseStatsView : UIView {
	
	NSArray *stats;
	NSArray *statLvl50Stats;
	NSArray *statLvl100Stats;
	
	NSInteger hp;
	NSInteger atk;
	NSInteger def;
	NSInteger spAtk;
	NSInteger spDef;
	NSInteger speed;
    NSInteger total;
}

//@property (nonatomic, retain) NSArray *statTitleLabels;
@property (nonatomic, retain) NSArray *stats;
@property (nonatomic, retain) NSArray *statLvl50Stats;
@property (nonatomic, retain) NSArray *statLvl100Stats;

@property (nonatomic, assign) NSInteger hp;
@property (nonatomic, assign) NSInteger atk;
@property (nonatomic, assign) NSInteger def;
@property (nonatomic, assign) NSInteger spAtk;
@property (nonatomic, assign) NSInteger spDef;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger total;

@end
