//
//  PokemonStats.m
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

#import "PokemonStats.h"

@implementation PokemonStats

@synthesize databaseID, base, ev;

-(id) initWithDatabaseID: (NSInteger)_databaseID loadStats: (BOOL)loadNow
{
	if ( (self = [super init]) )
	{
		self.databaseID = _databaseID;
		
		if( loadNow )
			[self loadPokemonStats];
	}
	
	return self;
}

-(void) loadPokemonStats
{
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//load the pokemon data from the database
	NSString *query = [NSString stringWithFormat: @"SELECT * FROM pokemon_stats WHERE pokemon_id = %d", self.databaseID];
	FMResultSet *rs = [db executeQuery: query];
	
	if( rs == nil )
	{
		NSLog( @"PokemonStats: ID %d doesn't exist.", self.databaseID );
		return;
	}
	
	PokemonStatsStruct _baseStats;
	PokemonStatsStruct _evStats;
	
    //init the structs to 0
    memset( &_baseStats, 0, sizeof(PokemonStatsStruct) );
    memset( &_evStats, 0, sizeof(PokemonStatsStruct) );
    
	while( [rs next] )
	{
		NSInteger stat_id = [rs intForColumn: @"stat_id"];
		NSInteger base_stat = [rs intForColumn: @"base_stat"];
		NSInteger ev_stat = [rs intForColumn: @"ev"];
		
		switch (stat_id) {
			case STAT_HP:
				_baseStats.hp = base_stat;
				_evStats.hp = ev_stat;
				break;
			case STAT_ATK:
				_baseStats.atk = base_stat;
				_evStats.atk = ev_stat;
				break;
			case STAT_DEF:
				_baseStats.def = base_stat;
				_evStats.def = ev_stat;
				break;
			case STAT_SPATK:
				_baseStats.spAtk = base_stat;
				_evStats.spAtk = ev_stat;
				break;
			case STAT_SPDEF:
				_baseStats.spDef = base_stat;
				_evStats.spDef = ev_stat;
				break;
			case STAT_SPEED:
				_baseStats.speed = base_stat;
				_evStats.speed = ev_stat;
				break;
            case STAT_TOTAL:
                _baseStats.total = base_stat;
                _evStats.total = ev_stat;
                break;
			default:
				break;
		}
	}
	
	self.base = _baseStats;
	self.ev = _evStats;
}

@end
