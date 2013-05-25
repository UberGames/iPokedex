//
//  AbilityEntryFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 12/03/11.
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

#import "AbilityEntryFinder.h"

@implementation AbilityEntryFinder

+ (NSArray *) abilitiesFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT a.*, f.%@ AS flavor_text \
                                                    FROM abilities AS a, ability_flavor_text AS f, ability_generation_flavor_text AS gf \
                                                    WHERE gf.generation_id = 5 AND gf.ability_id = a.id AND gf.flavor_text_id = f.id \
                                                    ORDER BY a.%@", TCLocalizedColumn( @"flavor_text" ), TCLocalizedColumn(@"name")];
	
	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	if ( rs == nil )
		return nil;
	
	NSMutableArray *abilities = [[NSMutableArray alloc] init];
	while ( [rs next] )
	{
		ListEntry *entry = [[ListEntry alloc] initWithResultSet: rs];
        entry.caption = [rs stringForColumn: @"flavor_text"];
        
		[abilities addObject: entry];
		[entry release];
	}
	
	return [abilities autorelease];
}

+ (NSInteger) databaseIDOfAbilityWithName: (NSString *)name
{
    NSString *query = [NSString stringWithFormat: @"SELECT id FROM abilities WHERE name = '%@' LIMIT 1", name];
	
    //perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
    if( results == nil )
        return 0;
    
    [results next];
    return [results intForColumn: @"id" ]; 
}

+ (ListEntry *)abilityWithDatabaseID: (NSInteger) databaseID
{
    NSString *query = [NSString stringWithFormat: @"SELECT a.*, f.%@ AS flavor_text AS flavor_text \
                                                    FROM abilities AS a, ability_flavor_text AS f, ability_generation_flavor_text AS gf \
                                                    WHERE gf.generation_id = 5 AND gf.ability_id = a.id AND gf.flavor_text_id = f.id AND a.id = %d \
                                                    ORDER BY a.name;", TCLocalizedColumn( @"flavor_text" ), databaseID];
	
	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	if ( rs == nil )
		return nil;
	
	[rs next];
    
    ListEntry *entry = [[ListEntry alloc] initWithResultSet: rs];
    entry.caption = [rs stringForColumn: @"flavor_text"];
	
	return [entry autorelease];
}

+(NSArray *) abilitiesWithDatabaseIDList: (NSArray *) IDList
{
	NSString *query = [NSString stringWithFormat: @"SELECT a.*, f.%@ AS flavor_text \
                            FROM abilities AS a \
                            LEFT JOIN ability_generation_flavor_text AS gf ON gf.ability_id = a.id \
                            LEFT JOIN ability_flavor_text AS f ON gf.flavor_text_id = f.id \
                            WHERE gf.generation_id = 5 AND (", TCLocalizedColumn( @"flavor_text" )];
    
    //add the id numbers
    for( NSNumber *idNumber in IDList )
        query = [query stringByAppendingFormat: @"a.id = %d OR ", [idNumber intValue]];
    
    //remove the final 'OR' section
    query = [query substringToIndex: ([query length])-4];
    //append the closing query statements
    query = [query stringByAppendingString: @")"];

	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
    NSMutableDictionary *unorderedEntryList = [NSMutableDictionary new];
    
	//laod the entry into the database
	while ([results next])
    {
        //init the entry
        ListEntry *entry = [[ListEntry alloc] initWithResultSet: results];
        entry.caption = [results stringForColumn: @"flavor_text"];
        [unorderedEntryList setObject: entry forKey: [NSNumber numberWithInt: entry.dbID]];
        [entry release];
    }
    
    NSMutableArray *entryList = [[NSMutableArray alloc] init];
    
    for( NSNumber *idNumber in IDList )
        [entryList addObject: [unorderedEntryList objectForKey: idNumber]];
    
    [unorderedEntryList release];
    
	return [entryList autorelease];
}

@end
