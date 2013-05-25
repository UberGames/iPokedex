//
//  Generations.m
//  iPokedex
//
//  Created by Timothy Oliver on 22/12/10.
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

#import "Generations.h"
#import "Languages.h"

@implementation Generations

+ (NSDictionary *) generationsFromDatabase
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_generations = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT * FROM generations ORDER BY id" ];
	while ( [rs next] ) {
		Generation *generation = [[Generation alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
		
        if( [[Languages sharedLanguages] isJapanese] )
            generation.name = [rs stringForColumn: @"name_jp" ];
        else
            generation.name = [rs stringForColumn: @"name"];

		[_generations setObject: generation forKey: [NSNumber numberWithInt: generation.dbID ] ];
		[generation release];
	}
	
	//push the array to the class instance
	return [_generations autorelease];
}

+ (NSArray *) generationNamesWithGenerations: (NSDictionary *)generations
{
	NSMutableArray *names = [[NSMutableArray alloc] init];
	
	for( NSInteger i = 0; i < [generations count]; i++ )
		[names addObject: [[generations objectForKey: [NSNumber numberWithInt: i+1]] name]];
	
	return [names autorelease];
}

+ (NSString *) generationShortNameWithGeneration: (Generation *)gen
{
	return [NSString stringWithFormat: NSLocalizedString( @"Gen. %@", "Generation Short" ), gen.name ];
}

+ (Generation *) generationWithDatabaseID: (NSInteger) databaseID
{
	if( databaseID == 0 )
		return nil;
	
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//grab the specific item from the DB
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM generations WHERE id = %i LIMIT 1", databaseID ]];
	[rs next];
	
	Generation *generation = [[Generation alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
    if( [[Languages sharedLanguages] isJapanese] )
        generation.name = [rs stringForColumn: @"name_jp" ];
    else
        generation.name = [rs stringForColumn: @"name"];
	
	return [generation autorelease];
}

@end

@implementation Generation

@end