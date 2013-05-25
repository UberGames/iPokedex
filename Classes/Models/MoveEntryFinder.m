//
//  MoveEntryFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 28/12/10.
//  Copyright 2010 UberGames. All rights reserved.
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

#import "MoveEntryFinder.h"
#import "Bulbadex.h"

@interface MoveEntryFinder ()

@end

@implementation MoveEntryFinder

@synthesize typeID, categoryID, generationID, pokemonID, versions, sortedOrder;

- (NSMutableArray *) entriesFromDatabase
{
	BOOL multiple_filter = NO; //used to append 'AND' on multiple filters
	
	//start building the query
	NSString *query = @"SELECT m.* FROM moves AS m";
	
	if (typeID > 0 || generationID > 0 || categoryID > 0)
		query = [query stringByAppendingString: @" WHERE "];
	
	if( typeID > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"type_id = %i", typeID];
		multiple_filter = YES; 
	}
	
	if( categoryID > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"category_id = %i", categoryID];
		multiple_filter = YES; 
	}
	
	if( generationID > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"generation_id <= %i", generationID];
	}
	
	if( sortedOrder == MoveFinderSortByPP )
		query = [query stringByAppendingString: @" ORDER BY m.pp ASC" ];
	else if (sortedOrder == MoveFinderSortByPower )
		query = [query stringByAppendingString: @" ORDER BY m.power ASC" ];
	else //order by name
		query = [query stringByAppendingFormat: @" ORDER BY m.%@ ASC", TCLocalizedColumn(@"name") ];

	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *moveList = [[NSMutableArray alloc] init];
	while ( [results next] ) {
		MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results];
		
		/*move.name				= [results stringForColumn: @"name" ];
		move.nameAlt				= [results stringForColumn: @"name_jp" ];
		move.elementalTypeID	= [results intForColumn: @"type_id" ];
		move.categoryID			= [results intForColumn: @"category_id" ];
		move.accuracy			= [results intForColumn: @"accuracy" ];
		move.power              = [results intForColumn: @"power" ];
		move.PP					= [results intForColumn: @"pp" ];*/
		
		[moveList addObject: move];
		[move release];
	}
	
	return [moveList autorelease];
}

+ (NSInteger) databaseIDOfMoveWithName: (NSString *)name
{
    NSString *query = [NSString stringWithFormat: @"SELECT id FROM moves WHERE name = '%@' LIMIT 1", name];
	
    //perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
    if( results == nil )
        return 0;
    
    [results next];
    return [results intForColumn: @"id" ];
}

+(MoveListEntry *) moveWithDatabaseID: (NSInteger) databaseID
{
	NSString *query = [NSString stringWithFormat: @"SELECT m.* FROM moves AS m WHERE id = %d LIMIT 1", databaseID];
	
	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
	//laod the entry into the database
	[results next];
	
	//init the entry
	MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results];
	
	return [move autorelease];
}

+(NSArray *) movesWithDatabaseIDList: (NSArray *) IDList
{
	NSString *query = @"SELECT m.* FROM moves AS m WHERE ";
    
    //add the id numbers
    for( NSNumber *idNumber in IDList )
        query = [query stringByAppendingFormat: @"id = %d OR ", [idNumber intValue]];

    //remove the final 'OR' section
    query = [query substringToIndex: ([query length])-4];
    query = [query stringByAppendingString: @" ORDER BY m.name ASC"];
    
	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
    //add them to a dictionary so we can re-order them
    NSMutableDictionary *unorderedEntryList = [NSMutableDictionary new];
    
	//laod the entry into the database
	while( [results next] )
    {
        //init the entry
        MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results];
        [unorderedEntryList setObject: move forKey: [NSNumber numberWithInt: move.dbID]];
        [move release];
    }
    
    //add them to the DB in the right order now
    NSMutableArray *entryList = [NSMutableArray new];
    for( NSNumber *idNumber in IDList )
        [entryList addObject: [unorderedEntryList objectForKey: idNumber]];
    
    [unorderedEntryList release];
	
	return [entryList autorelease];
}

+ (NSInteger) generationOfMoveWithDatabaseID: (NSInteger) dbID
{
	if( dbID <= 0 )
		return NO;
	
	NSString *query = [NSString stringWithFormat: @"SELECT generation_id FROM moves WHERE id = %d LIMIT 1", dbID];
	
	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	[rs next];
	
	return [rs intForColumn: @"generation_id"];
}

//--------------------------------------------------------------------------------------------------------

-(NSArray *) availableLearnCategoriesFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT * FROM pokemon_learn_categories WHERE pokemon_id = %d AND generation_id = %d LIMIT 1", self.pokemonID, self.generationID ];

	FMResultSet *rs = [db executeQuery: query];
	if( rs == nil )
		return nil;
	
	NSMutableArray *categories = [[NSMutableArray alloc] init];
	
	[rs next];
	//Level moves 
	[categories addObject: [NSNumber numberWithBool: ([rs intForColumn: @"level"]>0)]];
	//TM/HM
	[categories addObject: [NSNumber numberWithBool: ([rs intForColumn: @"machines"]>0)]];
	//tutor
	[categories addObject: [NSNumber numberWithBool: ([rs intForColumn: @"tutor"]>0)]];	
	//breed
	[categories addObject: [NSNumber numberWithBool: ([rs intForColumn: @"breed"]>0)]];

	return [categories autorelease];
}

-(NSArray *) pokemonLevelMovesFromDatabase
{	
	NSString *query = [NSString stringWithFormat: @"SELECT m.*, pm.level, pm.exclusive_version_group_id \
													FROM moves AS m, pokemon_moves AS pm \
													WHERE pm.pokemon_id = %d AND \
													pm.move_method_id = 1 AND \
													pm.move_id = m.id AND \
													pm.generation_id = %d \
													ORDER BY pm.level ASC, pm.exclusive_version_group_id ASC, pm.move_order ASC", self.pokemonID, self.generationID];
	
	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *moveList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results ];
		
		move.level						= [results intForColumn: @"level"];
		move.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		if( move.level == 1 )
			move.caption = NSLocalizedString( @"Start", @"Starting Level" );
		else
			move.caption = [NSString stringWithFormat: NSLocalizedString(@"Level %d", @"Level"), move.level];

		//check to merge 
		if( [self mergeExclusiveEntryWithList: moveList entry: move] == NO )
			[moveList addObject: move];
		
		[move release];
	}
	
	return [moveList autorelease];
}

-(NSArray *) pokemonTechnicalMachineMovesFromDatabase
{	
	NSString *query = [NSString stringWithFormat: @"SELECT m.*, tm.number AS 'tm_number', tm.type AS 'tm_type', pm.exclusive_version_group_id \
                                                   FROM moves AS m, pokemon_moves AS pm, machines AS tm \
                                                   WHERE tm.move_id = pm.move_id AND \
                                                   tm.generation_id = pm.generation_id AND \
                                                   pm.pokemon_id = %d AND \
                                                   pm.move_method_id = 4 AND \
                                                   pm.move_id = m.id AND \
                                                   pm.generation_id= %d \
                                                   ORDER BY tm_type DESC, tm_number ASC, pm.exclusive_version_group_id ASC", self.pokemonID, self.generationID];
	
	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *moveList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results ];
		move.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
        
		NSString *machineType = [results stringForColumn: @"tm_type"];
		NSInteger machineNum = [results intForColumn: @"tm_number"];
	
		if( [machineType isEqualToString: @"hm" ] )
			move.caption = [NSString stringWithFormat: @"%@%@%d", NSLocalizedString( @"HM", nil), (machineNum < 10 ? @"0" : @""), machineNum];
		else
		   move.caption = [NSString stringWithFormat: @"%@%@%d", NSLocalizedString( @"TM", nil), (machineNum < 10 ? @"0" : @""), machineNum];
		
		//check to merge 
		if( [self mergeExclusiveEntryWithList: moveList entry: move] == NO )
			[moveList addObject: move];
		
		[move release];
	}
	
	return [moveList autorelease];
}

-(NSArray *) pokemonTutorMovesFromDatabase
{	
	NSString *query = [NSString stringWithFormat: @"SELECT m.*, pm.level, pm.exclusive_version_group_id \
					   FROM moves AS m, pokemon_moves AS pm \
					   WHERE pokemon_id = %d AND \
					   pm.move_method_id = 3 AND \
					   pm.move_id = m.id AND \
					   pm.generation_id	= %d \
					   ORDER BY m.name ASC, pm.exclusive_version_group_id ASC", self.pokemonID, self.generationID];
	
	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )	
		return nil;
	
	NSMutableArray *moveList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results ];
		
		move.level						= [results intForColumn: @"level"];
		move.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		//check to merge 
		if( [self mergeExclusiveEntryWithList: moveList entry: move] == NO )
			[moveList addObject: move];
		
		[move release];
	}
	
	return [moveList autorelease];
}

-(NSArray *) pokemonEggMovesFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT m.*, pm.level, pm.exclusive_version_group_id \
					   FROM moves AS m, pokemon_moves AS pm \
					   WHERE pokemon_id = %d AND \
					   pm.move_method_id = 2 AND \
					   pm.move_id = m.id AND \
					   pm.generation_id	= %d \
					   ORDER BY m.name ASC, pm.exclusive_version_group_id ASC", self.pokemonID, self.generationID];
	
	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *moveList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		MoveListEntry *move = [[MoveListEntry alloc] initWithResultSet: results ];
		
		move.level						= [results intForColumn: @"level"];
		move.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		//check to merge 
		if( [self mergeExclusiveEntryWithList: moveList entry: move] == NO )
			[moveList addObject: move];
		
		[move release];
	}
	
	return [moveList autorelease];
}

-(void) dealloc
{
	[versions release];
	[super dealloc];
}

@end

@implementation MoveListEntry

@synthesize typeIcon, categoryIcon, elementalTypeID, categoryID, accuracy, accuracyValue, power, powerValue, PP, PPValue;

- (id) initWithResultSet: (FMResultSet *)results
{
	if( (self = [super init]) )
	{
		self.dbID				= [results intForColumn: @"id"];
		self.elementalTypeID	= [results intForColumn: @"type_id"];
		self.categoryID			= [results intForColumn: @"category_id"];
		self.accuracy			= [results intForColumn: @"accuracy"];
		self.PP					= [results intForColumn: @"pp"];
        self.power              = [results intForColumn: @"power"];
        
        if( LANGUAGE_IS_JAPANESE )
        {
            self.nameAlt	= [results stringForColumn: @"name"];
            self.name		= [results stringForColumn: @"name_jp"];
        }
        else
        {
            self.name		= [results stringForColumn: @"name"];
            self.nameAlt	= [results stringForColumn: @"name_jp"];
        }
    }
	
	return self;
}

#pragma mark Manual Accessors
-(void) setPower:(NSInteger)newPower
{	
	power = newPower;
	
    //if it's 1, it means there is a special clause for its damage
    if( power == 0 ) //No damage
        self.powerValue = @"-";
    else if ( power == 1 ) //special case
        self.powerValue = @"→";
    else
        self.powerValue = [NSString stringWithFormat: @"%d", power ];

}

-(void) setAccuracy:(NSInteger)newAccuracy
{	
	accuracy = newAccuracy;
	
	if( accuracy > 0 )
		self.accuracyValue = [NSString stringWithFormat: @"%i%%", accuracy];
	else 
		self.accuracyValue = @"-";
	
}

-(void) setPP:(NSInteger)newPP
{	
	PP = newPP;
	
	if ( PP > 0 )
		self.PPValue = [NSString stringWithFormat: @"%d", PP];
	else 
		self.PPValue = @"-";
	
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"MoveListEntry: %@", self.name];
}

- (void) dealloc
{	
	[typeIcon release];
	[categoryIcon release];
	
	[powerValue release];
	[accuracyValue release];
	[PPValue release];
	
	[super dealloc];
}

@end