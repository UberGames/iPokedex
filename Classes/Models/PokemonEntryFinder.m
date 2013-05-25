//
//  PokemonFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 23/11/10.
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

#import "Pokemon.h"
#import "PokemonEntryFinder.h"
#import "Bulbadex.h"
#import "ElementalTypes.h"
#import "UIImage+ImageLoading.h"

#define DEX_KANTO 1
#define DEX_JOHTO 2
#define DEX_HOENN 3
#define DEX_SINNOH 4
#define DEX_UNOVA 5

@interface PokemonEntryFinder ()

@end

@implementation PokemonEntryFinder

@synthesize generationID, moveID, dexId, typeId, sortedOrder, eggGroup1ID, eggGroup2ID, abilityID;

- (id)init
{
	if ( (self = [super init]) )
	{
		self.eggGroup1ID = -1; //account for the fact that no eggs egggroup is 0 (fixme?)
	}
	
	return self;
}

- (NSArray *) entriesFromDatabase
{
	BOOL multiple_filter = NO; //used to append 'AND' on multiple filters
	NSString *targetDex = @"ndex";
		
	//start building the query
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, rn.real_name, f.name AS forme_name, f.name_jp AS forme_name_jp, f.short_name AS forme_short_name \
                        FROM pokemon AS p \
                        LEFT JOIN pokemon_formes AS f ON f.pokemon_id = p.id \
                        LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id" ];
    
	if( generationID > 0 || dexId > 0 || typeId > 0 || eggGroup1ID >= 0 || eggGroup2ID > 0 || abilityID > 0 )
		query = [query stringByAppendingString: @" WHERE "];
	
	if( typeId > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"(type1_id = %i OR type2_id = %i)", typeId, typeId];
		multiple_filter = YES; 
	}
	
	if( generationID > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"generation_id = %i", generationID];
		multiple_filter = YES; 
	}
	
	if( dexId > 0 )
	{
		//based on the ID specified, get the name of pokemon
		switch ( dexId ) {
			case DEX_KANTO:
				targetDex = @"kdex";
				break;
			case DEX_JOHTO:
				targetDex = @"jdex";
				break;
			case DEX_HOENN:
				targetDex = @"hdex";
				break;
			case DEX_SINNOH:
				targetDex = @"sdex";
				break;
            case DEX_UNOVA: 
                targetDex = @"udex";
                break;
			default:
				break;
		}			
		
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"%@ != ''", targetDex];
		multiple_filter = YES; 
	}	
	
	//egg groups
	if( eggGroup1ID >= 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		
		//No Eggs specific
		if( eggGroup1ID == 0 )
		{
			query = [query stringByAppendingFormat: @"(p.egg_group1_id = 0)", eggGroup1ID, eggGroup1ID];
		}
		else
		{
			query = [query stringByAppendingFormat: @"(p.egg_group1_id = %d OR p.egg_group2_id = %d OR p.egg_group1_id = 13", eggGroup1ID, eggGroup1ID]; //14 == Ditto Group. Crazy Sex Machine
		
			if( eggGroup2ID > 0 )
				query = [query stringByAppendingFormat: @" OR p.egg_group1_id = %d OR p.egg_group2_id = %d", eggGroup2ID, eggGroup2ID];
				
			query = [query stringByAppendingString: @")"];
		}
	}
    
    if( abilityID > 0 )
    {
        if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
        query = [query stringByAppendingFormat: @"(ability1_id = %d OR ability2_id = %d OR abilitydream_id = %d)", abilityID, abilityID, abilityID];
    }
    
	if( sortedOrder == PokemonFinderSortByName )
		query = [query stringByAppendingFormat: @" ORDER BY %@ ASC", TCLocalizedColumn( @"name" ) ];
	else 
		query = [query stringByAppendingFormat: @" ORDER BY %@ ASC", targetDex ];

	//perform the query 
	FMResultSet *results = [db executeQuery: query];
    
	if( [db hadError] )
		return nil;
	
	NSMutableArray *pokemonList = [[NSMutableArray alloc] init];
	while ( [results next] ) {
		PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];
		pokemon.species			= [results stringForColumn: TCLocalizedColumn(@"species") ];
        
		//only update region dex if it has been changed
		if( [targetDex isEqualToString: @"ndex"] == NO )
		{
			pokemon.regionDexNumber = [results intForColumn: targetDex ];
			pokemon.dexText	= [Pokemon formatDexNumberWithInt: pokemon.regionDexNumber prependHash: YES];
		}
		else {
			pokemon.dexText	= [Pokemon formatDexNumberWithInt: pokemon.nDexNumber prependHash: YES];
		}
		
		[pokemonList addObject: pokemon];
		[pokemon release];
	}
    
	return (NSArray *)[pokemonList autorelease];
}
    
+(PokemonListEntry *) pokemonWithDatabaseID: (NSInteger) databaseID
{
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, "
                       "rn.real_name AS real_name, "
					   "f.name AS forme_name, f.name_jp AS forme_name_jp, "
					   "f.short_name AS forme_short_name "
					   "FROM pokemon AS p "
					   "LEFT JOIN pokemon_formes AS f ON p.forme_id = f.id "
                       "LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id "
					   "WHERE p.id = %d LIMIT 1", databaseID];
	
	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
	//laod the entry into the database
	[results next];
	
	//init the entry
	PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];
	
	return [pokemon autorelease];
}

+ (NSInteger) databaseIDOfPokemonWithName: (NSString *)name
{
    NSString *query = [NSString stringWithFormat: @"SELECT id FROM pokemon WHERE name = '%@' LIMIT 1", name];
	
    //perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
    if( results == nil )
        return 0;
    
    [results next];
    return [results intForColumn: @"id" ];
}

+ (NSArray *) pokemonWithDatabaseIDList: (NSArray *)IDList
{
    if( IDList == nil )
        return nil;
    
    NSString *query = [NSString stringWithFormat: @"SELECT p.*, "
                       "rn.real_name AS real_name, "
					   "f.name AS forme_name, f.name_jp AS forme_name_jp, "
					   "f.short_name AS forme_short_name "
					   "FROM pokemon AS p "
					   "LEFT JOIN pokemon_formes AS f ON p.id = f.pokemon_id "
                       "LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id "
					   "WHERE "];
	
    for ( NSNumber *pokemonID in IDList )
        query = [query stringByAppendingFormat: @"p.id = %d OR ", [pokemonID intValue]];
    
    //remove the final 'OR'
    query = [query substringToIndex: ([query length])-4];
    //query = [query stringByAppendingString: @" ORDER BY p.pokemon_order ASC"];

	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
    //add them to a dictionary so we can re-order them
    NSMutableDictionary *pokemonUnorderedList = [NSMutableDictionary new];
    
	//laod the entry into the database
	while( [results next] )
    {
        //init the entry
        PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];
        [pokemonUnorderedList setObject: pokemon forKey: [NSNumber numberWithInt: pokemon.dbID]];
        [pokemon release];
    }
     
    //add them to the DB in the right order now
    NSMutableArray *pokemonList = [[NSMutableArray alloc] init];
    for ( NSNumber *pokemonID in IDList )
        [pokemonList addObject: [pokemonUnorderedList objectForKey: pokemonID]];
    
    [pokemonUnorderedList release];
         
	return [pokemonList autorelease];
}

+ (NSDictionary *) pokemonWithLegacyDatabaseIDList: (NSArray *)IDList
{
    if( IDList == nil )
        return nil;
    
    NSString *query = @"SELECT p.id, p.legacy_id FROM pokemon AS p WHERE ";
	
    for ( NSNumber *pokemonID in IDList )
        query = [query stringByAppendingFormat: @"p.legacy_id = %d OR ", [pokemonID intValue]];
    
    //remove the final 'OR'
    query = [query substringToIndex: ([query length])-4];
    //query = [query stringByAppendingString: @" ORDER BY p.pokemon_order ASC"];
    
	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
    NSMutableDictionary *pokemonList = [[NSMutableDictionary alloc] init];
    
	//load the entry into the database
	while( [results next] )
    {
        NSInteger newID = [results intForColumn: @"id"];
        NSInteger oldID = [results intForColumn: @"legacy_id"];
        
        [pokemonList setObject: [NSNumber numberWithInt: newID] forKey: [NSNumber numberWithInt: oldID]];
    }
    
	return [pokemonList autorelease];
}

+ (NSDictionary *) pokemonEvolutionsWithDatabaseID: (NSInteger) dbID
{
	if( dbID == 0 )
		return nil;
	
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
    //Take the databaseID, and use it to derive the Pokemon that is the base/baby form of it
    NSString *query = [NSString stringWithFormat: @"SELECT p.id FROM pokemon AS p \
                                                    WHERE (p.id = (SELECT evolution_parent_pokemon_id FROM pokemon WHERE id = (SELECT evolution_parent_pokemon_id FROM pokemon WHERE id = %d ) ) OR \
                                                    p.id = (SELECT evolution_parent_pokemon_id FROM pokemon WHERE id = %d ) OR \
                                                    p.id = %d ) AND \
                                                    p.evolution_parent_pokemon_id IS NULL", dbID, dbID, dbID];
    
    FMResultSet *rs = [db executeQuery: query];
    if( rs == nil )
        return nil;
    
    NSMutableArray *pokemonEvolutionIdList = [[NSMutableArray alloc] init];
    
    [rs next];
    NSInteger baseFormID = [rs intForColumn: @"id"];
    
    //add the base form to the master list
    [pokemonEvolutionIdList addObject: [NSNumber numberWithInt: baseFormID]];
    
    //get an array of the first evolution form ids
    query = [NSString stringWithFormat: @"SELECT p.id FROM pokemon AS p WHERE p.evolution_parent_pokemon_id = %d ORDER BY p.ndex", baseFormID];
    rs = [db executeQuery: query];
    
    NSMutableArray *firstFormIdList = [[NSMutableArray alloc] init];
    NSMutableArray *secondFormIdList = [[NSMutableArray alloc] init];
    
    if( rs )
    {
        //make a list of all of the first form evolutions
        while( [rs next] )
            [firstFormIdList addObject: [NSNumber numberWithInt: [rs intForColumn: @"id"]]];
        
        //finally perform a query for any second level evolution forms using these iDs
        if( [firstFormIdList count] > 0 )
        {
            //create a second form array
            NSString *whereQuery = @"";
            for ( NSNumber* pokemonId in firstFormIdList)
                whereQuery = [whereQuery stringByAppendingFormat: @"p.evolution_parent_pokemon_id = %d OR ", [pokemonId intValue]];
            
            //remove the final 'OR'
            whereQuery = [whereQuery substringToIndex: ([whereQuery length])-3];
            
            //build the query
            query = [NSString stringWithFormat: @"SELECT p.id FROM pokemon AS p WHERE %@ ORDER BY p.ndex", whereQuery];
            
            //execute
            rs = [db executeQuery: query];
            if (rs) {
                    
                //add these pokemon to the second form
                while( [rs next] )
                    [secondFormIdList addObject: [NSNumber numberWithInt: [rs intForColumn: @"id"]]];
    
            }
        }
        
        //combine the final lists
        [pokemonEvolutionIdList addObjectsFromArray: firstFormIdList];
        [pokemonEvolutionIdList addObjectsFromArray: secondFormIdList];
    }
    
    NSString *whereQuery = @"";
    for ( NSNumber *pokemonID in pokemonEvolutionIdList )
        whereQuery = [whereQuery stringByAppendingFormat: @"p.id = %d OR ", [pokemonID intValue]];
    
    //remove the last OR
    whereQuery = [whereQuery substringToIndex: [whereQuery length]-3];
    
    //release the master array
    [pokemonEvolutionIdList release];
    
	query = [NSString stringWithFormat: @"SELECT p.id, p.name, p.%@, p.ndex, p.evolution_parent_pokemon_id, p.type1_id, p.type2_id, \
                                            rn.real_name AS 'real_name', \
                                            f.name AS 'forme_name', f.name_jp AS 'forme_name_jp', f.short_name AS 'forme_short_name', \
                                             p.is_baby, bi.%@ AS 'baby_item', \
                                             ep.identifier AS 'evolution_parameter_type', p.evolution_parameter, \
                                             m.%@ AS 'evolution_method', \
                                            i.%@ AS 'item_name', \
                                             pp.%@ AS 'party_pokemon_name', \
                                             mo.%@ AS 'move_name', \
                                             l.%@ AS 'location_name' \
                                             FROM pokemon AS p \
                                             LEFT JOIN pokemon_formes AS f ON p.id = f.pokemon_id \
                                             LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id \
                                             LEFT JOIN items AS bi ON (p.is_baby = 1 AND bi.id = p.baby_breed_item_id ) \
                                             LEFT JOIN evolution_methods AS m ON m.id = p.evolution_method_id \
                                             LEFT JOIN evolution_parameters AS ep ON ep.id = m.parameter_id \
                                             LEFT JOIN items AS i ON (ep.identifier = 'item' AND p.evolution_parameter = i.id ) \
                                             LEFT JOIN pokemon AS pp ON (ep.identifier = 'pokemon' AND p.evolution_parameter = pp.id ) \
                                             LEFT JOIN evolution_locations AS l ON (ep.identifier = 'location' AND p.evolution_parameter = l.id ) \
                                             LEFT JOIN moves AS mo ON (ep.identifier = 'move' AND p.evolution_parameter = mo.id ) \
                                             WHERE %@ \
                                             ORDER BY p.is_baby DESC, p.ndex ASC", 
                                                                                            TCLocalizedColumn(@"name"), //pokemon name
                                                                                            TCLocalizedColumn(@"name"), //baby item name
                                                                                            TCLocalizedColumn(@"name"), //evolution name
                                                                                            TCLocalizedColumn(@"name"), //item
                                                                                            TCLocalizedColumn(@"name"), //party name
                                                                                            TCLocalizedColumn(@"name"), //move name
                                                                                            TCLocalizedColumn(@"name"), //location name
                                                                                            whereQuery];

	//execute the query
	rs = [db executeQuery: query];
    
	NSMutableDictionary *evolutions = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *pokemonSections = [[NSMutableDictionary alloc] init];
	NSArray *sectionKeys = [NSArray arrayWithObjects:	POKEMON_EVOLUTION_BASE_KEY,
														POKEMON_EVOLUTION_FIRST_KEY,
														POKEMON_EVOLUTION_SECOND_KEY, nil ];
	
	while ( [rs next] )
	{
		PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: rs];
		
		//construct the evolution caption
		if( [rs intForColumn: @"is_baby"] == 0 )
		{
			NSString *parameterType = [rs stringForColumn: @"evolution_parameter_type"]; 
			
			if( [parameterType length] > 0) 
			{
				NSString *parameter = @"";
				
				//merge the paramter with the descriptor text
				//find out what it is first
				if( [parameterType isEqualToString: @"pokemon"] )
					parameter = [rs stringForColumn: @"party_pokemon_name"];
				else if( [parameterType isEqualToString: @"item"] )
					parameter = [rs stringForColumn: @"item_name"];
				else if( [parameterType isEqualToString: @"location"] )
					parameter = [rs stringForColumn: @"location_name"];
				else if( [parameterType isEqualToString: @"move"] )
					parameter = [rs stringForColumn: @"move_name"];
				else if( [parameterType isEqualToString: @"level"] )
					parameter = [rs stringForColumn: @"evolution_parameter"];
				
                if( [parameter length] )
                    pokemon.caption = [NSString stringWithFormat: [rs stringForColumn: @"evolution_method"], parameter];
                else
                    pokemon.caption = [rs stringForColumn: @"evolution_method"];
			}
			else 
			{
				//just copy it
				pokemon.caption = [rs stringForColumn: @"evolution_method"];
			}
			
			//add the pokemon to the dictionary
            //determine which section to put it in
            NSInteger insertIndex = 0;
            
            //set a sequential order for each pokemon to come through here (which will be used to sort these lists later
            if( pokemon.dbID == baseFormID )
                insertIndex = 1;
            else if ( [secondFormIdList indexOfObject: [NSNumber numberWithInt: pokemon.dbID]] != NSNotFound ) 
                insertIndex = 3;
            else
                insertIndex = 2;
            
            //set up a section array to place the pokemon
			NSMutableArray *section = [pokemonSections objectForKey: [NSNumber numberWithInt: insertIndex]];
			if( section == nil )
				section = [[[NSMutableArray alloc] init] autorelease];
			
			[section addObject: pokemon];
			[pokemonSections setObject: section forKey: [NSNumber numberWithInt: insertIndex]];			
		}
		else 
		{
			NSString *babyItem = [rs stringForColumn: @"baby_item"];
			
			if( babyItem )
				pokemon.caption = [NSString stringWithFormat: NSLocalizedString( @"Breed with %@", @"Baby breeding"), babyItem];
			
			[evolutions setObject: pokemon forKey: POKEMON_EVOLUTION_BABY_KEY ];
		}
                                     
        [pokemon release];
	}

    //clean up the sorting arrays
    [firstFormIdList release];
    [secondFormIdList release];
    
	//loop through each section and apply it to the dictionary in sequential order
	if( [pokemonSections count] > 0 )
	{
		NSArray *keys = [[pokemonSections allKeys] sortedArrayUsingSelector: @selector( compare: )];
		
		NSInteger i = 0;
		for ( NSNumber *key in keys )
			[evolutions setObject: [pokemonSections objectForKey: key] forKey: [sectionKeys objectAtIndex: i++]];
	}
	[pokemonSections release];

	return [evolutions autorelease];
}

+ (BOOL) pokemonHasEvolutionsWithDatabaseID: (NSInteger) dbID
{
	if( dbID <= 0 )
		return NO;
	
	NSString *query = [NSString stringWithFormat: @"SELECT COUNT(id) AS count FROM pokemon \
													WHERE (id = %d AND evolution_parent_pokemon_id != '') OR \
													evolution_parent_pokemon_id = %d LIMIT 1;", dbID, dbID];
	
	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	[rs next];
	
	return ( [rs intForColumn: @"count"] > 0 );
}

+ (NSInteger) generationOfPokemonWithDatabaseID: (NSInteger) dbID
{
	if( dbID <= 0 )
		return NO;
	
	NSString *query = [NSString stringWithFormat: @"SELECT generation_id FROM pokemon WHERE id = %d LIMIT 1", dbID];
	
	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	[rs next];
	
	return [rs intForColumn: @"generation_id"];
}

+ (NSDictionary *) dexSectionIndexEntriesWithEntries: (NSArray *)entries
{
	NSMutableDictionary *entryList = [[NSMutableDictionary alloc] init];
	
	NSInteger numberOffset = ceil([entries count] / POKEMON_NUM_DEX_SECTION_INDICIES);
    
	for ( NSInteger i = 0; i <= POKEMON_NUM_DEX_SECTION_INDICIES; i++ ) {
        //exit if we exceed the bounds of the array
        if( (numberOffset * i) > [entries count]-1)
            break;
        
		//grab the pokemon and get it's dex number
		PokemonListEntry *pokemon = (PokemonListEntry *)[entries objectAtIndex: (numberOffset * i)];	
		[entryList setObject: [NSNumber numberWithInt: numberOffset*i] 
					forKey: [NSString stringWithFormat: @"%@", pokemon.dexText ]];
	}
	
	return [entryList autorelease];
}

+ (NSArray *) dexSectionIndexTitlesWithDictionary:(NSDictionary *)entries search: (BOOL) search
{
	NSMutableArray *titles = [[NSMutableArray alloc] init];
	
	//add a search bar if required
	if( search )
		[titles	addObject: @"{search}" ];
	
	[titles addObjectsFromArray: [[entries allKeys] sortedArrayUsingSelector: @selector( caseInsensitiveCompare: )]];
	
	return [titles autorelease];
}

+ (NSArray *) dexSectionIndexIndiciesWithDictionary: (NSDictionary *)entries titleList: (NSArray *)titleList
{
	NSMutableArray *sectionIndicies = [[NSMutableArray alloc] init];
	
	for( NSString *title in titleList )
	{
		if( [title compare: @"{search}"] == NSOrderedSame ) { continue; }
		
		[sectionIndicies addObject: [entries objectForKey: title] ];
	}
	
	return [sectionIndicies autorelease];
}

//---------------------------------------------------------------------------------------------------------------------
//Move Page finders

-(NSArray *) moveLevelPokemonFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, \
                                                        rn.real_name AS real_name, \
														f.name AS 'forme_name', f.name_jp AS 'forme_name_jp', f.short_name AS 'forme_short_name', \
														pm.level, pm.exclusive_version_group_id \
													FROM pokemon AS p, pokemon_moves AS pm \
													LEFT JOIN pokemon_formes AS f ON p.id = f.pokemon_id \
                                                    LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id \
													WHERE pm.move_id = %d AND \
															pm.move_method_id = 1 AND \
															pm.pokemon_id = p.id AND \
															pm.generation_id = %d \
													ORDER BY p.ndex ASC, f.pokemon_id ASC, pm.exclusive_version_group_id ASC, pm.move_order ASC", 
                       self.moveID, self.generationID];

	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *pokemonList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];
		
		pokemon.level					= [results intForColumn: @"level"];
		pokemon.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		if( pokemon.level == 1 )
			pokemon.caption = NSLocalizedString( @"Start", @"Starting Level" );
		else
			pokemon.caption = [NSString stringWithFormat: NSLocalizedString(@"Level %d", @"Level"), pokemon.level];
		
		//check to merge 
		if( [self mergeExclusiveEntryWithList: pokemonList entry: pokemon] == NO )
			[pokemonList addObject: pokemon];
		
		[pokemon release];
	}
	
	return [pokemonList autorelease];
}

-(NSArray *) moveTMPokemonFromDatabase
{	
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, \
                                                    rn.real_name AS 'real_name', \
													f.name AS 'forme_name', f.name_jp AS 'forme_name_jp', f.short_name AS 'forme_short_name', \
													tm.number AS 'tm_number', tm.type AS 'tm_type', \
													pm.exclusive_version_group_id \
												   FROM pokemon AS p, pokemon_moves AS pm, machines AS tm \
													LEFT JOIN pokemon_formes AS f ON p.id = f.pokemon_id \
                                                    LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id \
												   WHERE tm.move_id = pm.move_id AND \
												   tm.generation_id = pm.generation_id AND \
													pm.move_id = %d AND \
												   pm.move_method_id = 4 AND \
												   pm.pokemon_id = p.id AND \
												   pm.generation_id= %d \
												   ORDER BY tm.exclusive_version_group_id ASC, tm_type DESC, tm_number ASC", 
                       self.moveID, self.generationID];
	
	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *pokemonList = [[NSMutableArray alloc] init];

	while ( [results next] ) {		
		PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];
		pokemon.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		if( [self mergeExclusiveEntryWithList: pokemonList entry: pokemon] == NO )
			[pokemonList addObject: pokemon];
		
		[pokemon release];
	}
	
	return [pokemonList autorelease];
}

-(NSArray *) moveTutorPokemonFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, \
                                                            rn.real_name AS real_name, \
															f.name AS 'forme_name', f.name_jp AS 'forme_name_jp', f.short_name AS 'forme_short_name', \
															pm.exclusive_version_group_id \
												   FROM pokemon AS p, pokemon_moves AS pm \
													LEFT JOIN pokemon_formes AS f ON p.id = f.pokemon_id \
                                                    LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id \
												   WHERE pm.move_id = %d AND \
													pm.move_method_id = 3 AND \
													pm.pokemon_id = p.id AND \
													pm.generation_id = %d \
												   ORDER BY p.ndex ASC, pm.exclusive_version_group_id ASC", 
                       self.moveID, self.generationID];

	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )	
		return nil;
	
	NSMutableArray *pokemonList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];
		
		pokemon.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		//check to merge 
		if( [self mergeExclusiveEntryWithList: pokemonList entry: pokemon] == NO )
			[pokemonList addObject: pokemon];
		
		[pokemon release];
	}
	
	return [pokemonList autorelease];
}

-(NSArray *) moveBreedPokemonFromDatabase
{	
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, \
                                                            rn.real_name AS 'real_name', \
														    f.name AS 'forme_name', f.name_jp AS 'forme_name_jp', f.short_name AS 'forme_short_name', \
															pm.exclusive_version_group_id \
													   FROM pokemon AS p, pokemon_moves AS pm \
														LEFT JOIN pokemon_formes AS f ON p.id = f.pokemon_id \
                                                        LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id \
													   WHERE pm.move_id = %d AND \
														   pm.move_method_id = 2 AND \
														   pm.pokemon_id = p.id AND \
														   pm.generation_id	= %d \
													   ORDER BY p.ndex ASC, pm.exclusive_version_group_id ASC", 
                       self.moveID, self.generationID];
	
	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *pokemonList = [[NSMutableArray alloc] init];
	while ( [results next] ) {		
		PokemonListEntry *pokemon = [[PokemonListEntry alloc] initWithDatabaseResults: results];

		pokemon.exclusiveVersionGroupID	= [results intForColumn: @"exclusive_version_group_id"];
		
		//check to merge 
		if( [self mergeExclusiveEntryWithList: pokemonList entry: pokemon] == NO )
			[pokemonList addObject: pokemon];
		
		[pokemon release];
	}
	
	return [pokemonList autorelease];
}

-(NSArray *) availableLearnCategoriesFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT * FROM move_learn_categories WHERE move_id = %d AND generation_id = %d LIMIT 1", self.moveID, self.generationID ];

	FMResultSet *rs = [self.db executeQuery: query];
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

+ (NSString *) pokemonRandomDexTextWithNdexID: (NSInteger) ndexID
{
    NSString *query = [NSString stringWithFormat: @"SELECT f.%@ AS flavor_text FROM pokemon_flavor_text AS f, \
                                                            pokemon_version_flavor_text AS vf \
                                                    WHERE vf.flavor_text_id = f.id AND vf.ndex = %d \
                                                    ORDER BY RANDOM() LIMIT 1", TCLocalizedColumn(@"flavor_text"), ndexID];

    FMDatabase *db = [[Bulbadex sharedDex] db];
    
    FMResultSet *rs = [db executeQuery: query];
	if( rs == nil )
		return nil;
    
    [rs next];
    return [rs stringForColumn: @"flavor_text"];
}

//---------------------------------------------------------------------------------------------------------------------

-(void) reset
{
	generationID = 0;
	dexId = 0;
	typeId = 0;
	sortedOrder = PokemonFinderSortByNumber;
}

@end

@implementation PokemonListEntry

@synthesize
	nDexNumber, 
	regionDexNumber,  
	species, 
	type1Id, 
	type2Id,
	type1Icon, 
	type2Icon, 
	dexText,
	icon,
	iconLoaded,
	formeName,
    formeNameAlt,
	formeShortName;

#pragma mark PokemonEntry Initialization
- (id) initWithDatabaseID: (NSInteger) databaseId
{
	if ( (self = [super init]) )
	{
		self.dbID = databaseId;
		self.iconLoaded = NO;
	}
	
	return self;
}

-(id) initWithDatabaseResults: (FMResultSet *)results
{
	if( (self = [super init]) )
	{
		self.dbID			= [results intForColumn: @"id"];
		self.nDexNumber		= [results intForColumn: @"ndex" ];
		self.type1Id			= [results intForColumn: @"type1_id" ];
		self.type2Id			= [results intForColumn: @"type2_id" ];
		self.dexText	= [Pokemon formatDexNumberWithInt: self.nDexNumber prependHash: YES];
		
        if( LANGUAGE_IS_JAPANESE )
        {
            self.nameAlt	= [results stringForColumn: @"name" ];
            self.name		= [results stringForColumn: @"name_jp" ]; 
            
            self.formeName = [results stringForColumn: @"forme_name_jp"];
            self.formeNameAlt = [results stringForColumn: @"forme_name"];
        }
        else
        {
            self.name		= [results stringForColumn: TCLocalizedColumn(@"name") ];
            self.nameAlt	= [results stringForColumn: @"name_jp" ]; 
            
            self.formeName = [results stringForColumn: TCLocalizedColumn(@"forme_name")];
            self.formeNameAlt = [results stringForColumn: @"forme_name_jp"];
        }
        
        NSNumber *realNameMode = [[NSUserDefaults standardUserDefaults] objectForKey: @"realNameMode"];
        if( realNameMode && [realNameMode intValue] )
        {
            NSString *realName = [results stringForColumn: @"real_name"];
            if( [realName length] > 0 )
            {
                if( LANGUAGE_IS_JAPANESE == NO )
                    self.name = realName;
                else
                    self.nameAlt = realName;
            }
        }
        
		//set forme info
		self.formeShortName = [results stringForColumn: @"forme_short_name"];
	}
	
	return self;
}

- (NSString *) name
{
	if( self.formeName != nil )
		return [NSString stringWithFormat: @"%@ (%@)", name, formeName];
	else 
		return name;
}

-(void) setSpecies: (NSString *)newSpecies
{
	if( [newSpecies isEqual: species] )
		return;
	
	[species release];
	species = [[[NSString alloc] initWithFormat: NSLocalizedString( @"%@ Pokémon", nil ), newSpecies] retain];
}

- (void) loadIcon
{
	if( iconLoaded )
		return;
    
	NSString *file;
	
	//get the icon file name
	if( self.formeName == nil )
		file = [NSString stringWithFormat: @"Images/Pokemon/Small/%i.png", nDexNumber];
	else
		file = [NSString stringWithFormat: @"Images/Pokemon/Small/%i-%@.png", nDexNumber, formeShortName];
	
	icon = [[UIImage alloc] initWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: file]];

    iconLoaded = YES;
}

- (NSString *)webName
{
    NSString *forme = nil;
    
    if( LANGUAGE_IS_JAPANESE )
        forme = self.formeNameAlt;
    else
        forme = self.formeName;
    
    if( [forme length] > 0 )
    {
        forme = [forme stringByReplacingOccurrencesOfString: @" " withString: @"_"];
        return [NSString stringWithFormat: @"%@_%@", [super webName], forme];
    }
        
    return [super webName];
}

- (void)unloadIcon
{
    self.icon = nil;
    iconLoaded = NO;
}

#pragma mark PokemonEntry Memory Management

- (void) dealloc
{
	[species release];
    [dexText release];
	[formeName release];
    [formeNameAlt release];
	[formeShortName release];
	[icon release];
    [type1Icon release];
    [type2Icon release];
	
	[super dealloc];
}

@end

