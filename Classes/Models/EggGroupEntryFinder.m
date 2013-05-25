//
//  EggGroupEntryFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/03/11.
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

#import "EggGroupEntryFinder.h"

@implementation EggGroupEntryFinder

+ (NSArray *) eggGroupsFromDatabase
{
	NSString *query = @"SELECT * FROM egg_groups ORDER BY list_order ASC";
	
	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	if ( rs == nil )
		return nil;
	
	NSMutableArray *groups = [[NSMutableArray alloc] init];
	while ( [rs next] )
	{
		ListEntry *entry = [[ListEntry alloc] initWithResultSet: rs];
		[groups addObject: entry];
		[entry release];
	}
	
	return [groups autorelease];
}

+ (NSArray *) eggGroupsWithDatabaseIDList: (NSArray *)IDList
{
    NSString *query = @"SELECT * FROM egg_groups WHERE ";
    
    //add the id numbers
    for( NSNumber *idNumber in IDList )
        query = [query stringByAppendingFormat: @"id = %d OR ", [idNumber intValue]];
    
    //remove the final 'OR' section
    query = [query substringToIndex: ([query length])-4];
    //append the closing query statements
    query = [query stringByAppendingString: @" ORDER BY id ASC"];

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
        [unorderedEntryList setObject: entry forKey: [NSNumber numberWithInt: entry.dbID]];
        [entry release];
    }

    NSMutableArray *entryList = [[NSMutableArray alloc] init];
    
    for( NSNumber *idNumber in IDList )
        [entryList addObject: [unorderedEntryList objectForKey: idNumber]];
    
    [unorderedEntryList release];
    
	return [entryList autorelease];
}

+ (NSDictionary *) eggGroupsWithLegacyDatabaseIDList: (NSArray *)IDList
{
    NSString *query = @"SELECT * FROM egg_groups WHERE ";
    
    //add the id numbers
    for( NSNumber *idNumber in IDList )
        query = [query stringByAppendingFormat: @"legacy_id = %d OR ", [idNumber intValue]];
    
    //remove the final 'OR' section
    query = [query substringToIndex: ([query length])-4];
    //append the closing query statements
    //query = [query stringByAppendingString: @" ORDER BY id ASC"];
    
	//perform the query
	FMResultSet *results = [[[Bulbadex sharedDex] db] executeQuery: query];
	
	if( [[[Bulbadex sharedDex] db] hadError] )
		return nil;
	
    NSMutableDictionary *entryList = [[NSMutableDictionary alloc] init];
    
	//laod the entry into the database
	while ([results next])
    {
        NSInteger newID = [results intForColumn: @"id"];
        NSInteger oldID = [results intForColumn: @"legacy_id"];
        
        [entryList setObject: [NSNumber numberWithInt: newID] forKey: [NSNumber numberWithInt: oldID] ];
    }
    
	return [entryList autorelease];
}

+ (NSString *) titleWithEggGroup1ID: (NSInteger)group1 eggGroup2ID: (NSInteger)group2
{
	NSString *query = [NSString stringWithFormat: @"SELECT * FROM egg_groups WHERE id = %d ", group1];
	
	if( group2 > 0 )
	{
		query = [query stringByAppendingFormat: @"OR id = %d ", group2];
		query = [query stringByAppendingString: @"LIMIT 2"];
	}
	else {
		query = [query stringByAppendingString: @"LIMIT 1"];
	}

	FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
	if ( rs == nil )
		return nil;
	
	NSString *title = @"";
	while ( [rs next] )
	{
		ListEntry *entry = [[ListEntry alloc] initWithResultSet: rs];
		title = [title stringByAppendingFormat: @"%@+", entry.name];
		[entry release];
	}
	
	//remove the trailing +
	title = [title substringToIndex: [title length]-1];
	
	return title;
}

@end
