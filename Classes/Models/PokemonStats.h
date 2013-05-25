//
//  PokemonStats.h
//  iPokedex
//
//  Created by Timothy Oliver on 20/01/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#define STAT_HP		1
#define STAT_ATK	2
#define STAT_DEF	3
#define STAT_SPATK	4
#define STAT_SPDEF	5
#define STAT_SPEED	6
#define STAT_TOTAL  7

#define NUM_STATS	7

#import <Foundation/Foundation.h>
#import "Bulbadex.h"

struct PokemonStatsStruct
{
	NSInteger hp;
	NSInteger atk;
	NSInteger def;
	NSInteger spAtk;
	NSInteger spDef;
	NSInteger speed;
    NSInteger total;
};
typedef struct PokemonStatsStruct PokemonStatsStruct;

@interface PokemonStats : NSObject {
	NSInteger databaseID;
	
	PokemonStatsStruct base;
	PokemonStatsStruct ev;
}

-(id) initWithDatabaseID: (NSInteger)_databaseID loadStats: (BOOL)loadNow;
-(void) loadPokemonStats;

@property (nonatomic, assign) NSInteger databaseID;
@property (nonatomic, assign) PokemonStatsStruct base;
@property (nonatomic, assign) PokemonStatsStruct ev;

@end
