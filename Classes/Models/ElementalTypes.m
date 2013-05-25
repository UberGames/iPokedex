//
//  ElementalType.m
//  iPokedex
//
//  Created by Timothy Oliver on 18/11/10.
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

#import "ElementalTypes.h"
#import "Bulbadex.h"
#import "UIImage+ImageLoading.h"

//cache the icons in a static array
static NSMutableDictionary *typeIcons;

@implementation ElementalTypes
												 
#pragma mark Class Methods
	 
+ (NSDictionary *) typesFromDatabaseWithIcons: (BOOL) loadIcons
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_types = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT t.* FROM elemental_types AS t ORDER BY id ASC" ];
	while ( [rs next] ) {
		ElementalType *type = [[ElementalType alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
		
		type.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
		type.shortName = [rs stringForColumn: @"short_name"];
		type.bgColor = [UIColor colorWithHexString: [rs stringForColumn: @"color"]];

		if( loadIcons == YES )
			[type loadIcon];
		
		[_types setObject: type forKey: [NSNumber numberWithInt: type.dbID ] ];
		[type release];
	}
	
	//push the array to the class instance
	return [_types autorelease];
}
	 
+ (ElementalType *) typeWithDatabaseID: (NSInteger) databaseID
{
	if( databaseID == 0 )
		return nil;
					
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//grab the specific item from the DB
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT t.* FROM elemental_types AS t WHERE id = %i LIMIT 1", databaseID ]];
	[rs next];
	
	ElementalType *type = [[ElementalType alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
	type.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
	type.shortName = [rs stringForColumn: @"short_name"];
	type.bgColor = [UIColor colorWithHexString: [rs stringForColumn: @"color"]];
	
	return [type autorelease];
}

+(ElementalType *) typeWithPokemonID: (NSInteger) pokemonID
{
	if( pokemonID == 0 )
		return nil;
	
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];

	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT e.* FROM pokemon AS p, elemental_types AS e \
																		WHERE p.type1_id = e.id AND p.id = %d LIMIT 1", pokemonID]];
	[rs next];
	
	ElementalType *type =[[ElementalType alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
	type.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
	type.shortName = [rs stringForColumn: @"short_name"];
	type.bgColor = [UIColor colorWithHexString: [rs stringForColumn: @"color"]];
	
	return [type autorelease];
}

@end

@implementation ElementalType

@synthesize shortName, icon, bgColor;

-(UIImage *) icon
{
	if ( icon == nil )
		[self loadIcon];
	
	return icon;
}

- (void) loadIcon
{
	//if not already created, spawn the cache array
	@synchronized(self)
	{
		if( typeIcons == nil )
			typeIcons = [[NSMutableDictionary alloc] init];
	}
	
	//try and retrieve the image from it
	self.icon = [typeIcons objectForKey: [NSNumber numberWithInt: self.dbID]];
	if( icon == nil )
	{
        NSString *languageDir = [[[Languages sharedLanguages] languageCode] uppercaseString];
		self.icon = [UIImage imageFromResourcePath: [NSString stringWithFormat: @"Images/Types/%@/%@.png", languageDir, self.shortName]];
		
        if( icon )
            
            [typeIcons setObject: icon forKey: [NSNumber numberWithInt: self.dbID]];
	}
}

- (void) dealloc
{
	[shortName release];
	[icon release];
	[bgColor release];
	
	[super dealloc];
}

@end

