//
//  Regions.m
//  iPokedex
//
//  Created by Timothy Oliver on 8/12/10.
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

#import "Regions.h"
#import "Bulbadex.h"

@implementation Regions

#pragma mark Class Methods

+ (NSDictionary *) regionsFromDatabase
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_regions = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT * FROM regions ORDER BY id" ];
	while ( [rs next] ) {
		Region *region = [[Region alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
		
		region.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
		
		[_regions setObject: region forKey: [NSNumber numberWithInt: region.dbID ] ];
		[region release];
	}
	
	//push the array to the class instance
	return [_regions autorelease];
}

+ (Region *) regionWithDatabaseID: (NSInteger) databaseID
{
	if( databaseID == 0 )
		return nil;
	
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM regions WHERE id = %i ORDER BY id", databaseID] ];
	[rs next];
	
	Region *region = [[Region alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
	region.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
	
	//push the array to the class instance
	return [region autorelease];
}


@end

@implementation Region

@end