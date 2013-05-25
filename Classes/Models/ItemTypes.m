//
//  ItemTypes.m
//  iPokedex
//
//  Created by Timothy Oliver on 21/12/10.
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

#import "ItemTypes.h"
#import "Bulbadex.h"

@implementation ItemTypes

#pragma mark Init Code
- (id)init
{
	[NSException raise: NSInternalInconsistencyException format: @"Class cannot be instanced"];
	return nil;
}

#pragma mark Class Methods

+ (NSDictionary *) typesFromDatabase
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_types = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT * FROM item_types ORDER BY id" ];
	while ( [rs next] ) {
		ItemType *type = [[ItemType alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
		
		type.name = [rs stringForColumn: @"name"];
		type.nameJP = [rs stringForColumn: @"name_jp" ];
		type.shortName = [rs stringForColumn: @"short_name"];
		
		[_types setObject: type forKey: [NSNumber numberWithInt: type.dbID ] ];
		[type release];
	}
	
	//push the array to the class instance
	return [_types autorelease];
}

+ (ItemType *) typeWithDatabaseID: (NSInteger) databaseID
{
	if( databaseID == 0 )
		return nil;
	
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//grab the specific item from the DB
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM item_types WHERE id = %i LIMIT 1", databaseID ]];
	[rs next];
	
	ItemType *type = [[ItemType alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
	type.name = [rs stringForColumn: @"name"];
	type.nameJP = [rs stringForColumn: @"name_jp" ];
	type.shortName = [rs stringForColumn: @"short_name"];
	
	return [type autorelease];
}


@end

@implementation ItemType

@synthesize shortName, icon;

- (void) dealloc
{
	[shortName release];
	[icon release];
	
	[super dealloc];
}

@end
