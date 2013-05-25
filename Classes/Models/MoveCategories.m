//
//  MoveCategories.m
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

#import "MoveCategories.h"
#import "Bulbadex.h"
#import "UIImage+ImageLoading.h"

//cache the icons in a static array
static NSMutableDictionary *moveIcons;

@implementation MoveCategories

+ (NSDictionary *) categoriesFromDatabaseWithIcons: (BOOL) loadIcons
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_categories = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: @"SELECT * FROM move_categories ORDER BY id" ];
	while ( [rs next] ) {
		MoveCategory *category = [[MoveCategory alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
		
		category.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
		category.shortName = [rs stringForColumn: @"short_name" ];
		
		if (loadIcons )
			[category loadIcon];
		
		[_categories setObject: category forKey: [NSNumber numberWithInt: category.dbID ] ];
		[category release];
	}
	
	//push the array to the class instance
	return [_categories autorelease];	
}

+ (MoveCategory *)categoryFromDatabaseWithID: (NSInteger) databaseID
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];

	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM move_categories WHERE id = %d LIMIT 1", databaseID] ];
	[rs next];
	
	MoveCategory *category = [[MoveCategory alloc] initWithDatabaseID: [rs intForColumn: @"id"]];
		
	category.name = [rs stringForColumn: TCLocalizedColumn(@"name")];
	category.shortName = [rs stringForColumn: @"short_name" ];
	
	[category loadIcon];
	
	//push the array to the class instance
	return [category autorelease];
}

@end

@implementation MoveCategory

@synthesize shortName, icon;

- (void) loadIcon
{
	//if not already created, spawn the cache array
	@synchronized(self)
	{
		if( moveIcons == nil )
			moveIcons = [[NSMutableDictionary alloc] init];
	}
	
	//try and retrieve the image from it
	self.icon = [moveIcons objectForKey: [NSNumber numberWithInt: self.dbID]];
	if( icon == nil )
	{
		self.icon = [UIImage imageFromResourcePath: [NSString stringWithFormat: @"Images/Moves/%@.png", self.shortName]];
		[moveIcons setObject: icon forKey: [NSNumber numberWithInt: self.dbID]];
	}
}

-(void) dealloc
{
	[icon release];
	
	[super dealloc];
}

@end