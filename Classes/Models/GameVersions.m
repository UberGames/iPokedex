//
//  Versions.m
//  iPokedex
//
//  Created by Timothy Oliver on 17/02/11.
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

#import "GameVersions.h"

@implementation GameVersions

+ (NSDictionary *) gameVersionsFromDatabase
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_versions = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT * FROM versions ORDER BY id ASC" ];
	while ( [rs next] ) {
		GameVersion *version = [[GameVersion alloc] initWithResultSet: rs];
		[_versions setObject: version forKey: [NSNumber numberWithInt: version.dbID ] ];
		[version release];
	}
	
	return [_versions autorelease];
}

+ (GameVersion *) gameVersionWithDatabaseID:(NSInteger)databaseID
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM versions WHERE id = %d ORDER BY id ASC", databaseID] ];
	[rs next];
	
	GameVersion *version = [[GameVersion alloc] initWithResultSet: rs];
	return [version autorelease];	
}

+ (NSArray *) gameVersionsWithExclusiveGroupID: (NSInteger) groupID
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM versions WHERE version_group_id = %d ORDER BY id ASC", groupID] ];
	
	//set up the array to return
	NSMutableArray *_versions = [[NSMutableArray alloc] init];
	while([rs next])
	{
		GameVersion *version = [[GameVersion alloc] initWithResultSet: rs];
		[_versions addObject: version];
		[version release];
	}
	
	return [_versions autorelease];	
}

+ (NSDictionary *) gameVersionsByGroupingFromDatabase
{
	
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT * FROM versions ORDER BY version_group_id ASC, id ASC"];
	
	//set up the array to return
	NSMutableDictionary *_groups = [[NSMutableDictionary alloc] init];
	while([rs next])
	{
		//create version
		GameVersion *version = [[GameVersion alloc] initWithResultSet: rs];
		
		//see if an entry exists in the dictionary
		NSMutableArray *_versions = [_groups objectForKey: [NSNumber numberWithInt: version.releaseGrouping]] ;
		if( _versions == nil )
			_versions = [[[NSMutableArray alloc] init] autorelease];
		
		//add to the dictionary
		[_versions addObject: version];
		[_groups setObject: _versions forKey: [NSNumber numberWithInt: version.releaseGrouping] ];
		
		[version release];
	}
	
	return [_groups autorelease];	
}

@end

@implementation GameVersion

-(id) initWithResultSet: (FMResultSet *)rs
{
	if( (self = [super init]) )
	{
		self.dbID				= [rs intForColumn: @"id"];
		self.name				= [rs stringForColumn: TCLocalizedColumn(@"name")];
		self.generation			= [rs intForColumn: @"generation_id"];
		self.acronym			= [rs stringForColumn: TCLocalizedColumn(@"acronym")];
		self.releaseGrouping	= [rs intForColumn: @"version_group_id"];
		self.color				= [UIColor colorWithHexString: [rs stringForColumn: @"color"]];
	}
	
	return self;
}

@synthesize generation, releaseGrouping, regionGrouping, color, acronym;

-(void) dealloc
{
	[color release];
	[acronym release];
	
	[super dealloc];
}

@end