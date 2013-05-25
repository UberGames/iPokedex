//
//  ItemEntryFinder.m
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

#import "ItemEntryFinder.h"

@implementation ItemEntryFinder

@synthesize sortedOrder, typeID, generationID;

- (NSMutableArray *) entriesFromDatabase
{
	BOOL multiple_filter = NO; //used to append 'AND' on multiple filters
	
	//start building the query
	NSString *query = @"SELECT i.* FROM items AS i";
	
	if (typeID > 0 || generationID > 0 )
		query = [query stringByAppendingString: @" WHERE "];
		
	if( typeID > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"item_type_id = %i", typeID];
		multiple_filter = YES; 
	}
	
	if( generationID > 0 )
	{
		if ( multiple_filter == YES ) { query = [query stringByAppendingString: @" AND " ]; }
		query = [query stringByAppendingFormat: @"generation <= %i", generationID];
	}
	
	if( sortedOrder == ItemFinderSortByName )
		query = [query stringByAppendingString: @" ORDER BY i.name ASC" ];
	else //order by type
		query = [query stringByAppendingFormat: @" ORDER BY i.item_type_id, i.id ASC" ];

	//perform the query
	FMResultSet *results = [self.db executeQuery: query];
	
	if( [self.db hadError] )
		return nil;
	
	NSMutableArray *itemList = [[NSMutableArray alloc] init];
	while ( [results next] ) {
		ItemListEntry *item = [[ItemListEntry alloc] initWithDatabaseID: [results intForColumn: @"id"]];
		
		item.name			= [results stringForColumn: @"name" ];
		item.nameAlt			= [results stringForColumn: @"name_jp" ];
		item.shortName		= [results stringForColumn: @"short_name"];
		item.buyable		= [results boolForColumn: @"buyable"];
		item.sellPrice		= [results intForColumn: @"sell_price"];
		item.typeID			= [results intForColumn: @"item_type_id"];
		
		[itemList addObject: item];
		[item release];
	}
	
	return [itemList autorelease];	
}

-(NSArray *) generateSectionListWithList: (NSArray *)list
{
	//Output array. Each cell is an array of items
	NSMutableArray *sectionList = [[NSMutableArray alloc] init];
	
	//the array of items we're working on now
	NSMutableArray *sectionItemList = nil;
	NSInteger lastTypeID = 0;
	
	//The assumption is the items are ordered by their type IDs
	for( ItemListEntry *item in list )
	{
		if( lastTypeID != item.typeID )
		{
			if( lastTypeID > 0 )
			{
				//add the block to the output array
				[sectionList addObject: sectionItemList];
				[sectionItemList release];
			}
			
			//reset the list array for more
			sectionItemList = [[NSMutableArray alloc] init];
			
			//reset the type checker
			lastTypeID = item.typeID;
		}
		
		[sectionItemList addObject: item];
	}
	
	//whatever's left, add it up
	[sectionList addObject: sectionItemList];
	[sectionItemList release];
    
	return [sectionList autorelease];
}

-(NSArray *) generateSectionTitlesWithList: (NSArray *)list
{
	//Output array. Each cell is an array of items
	NSMutableArray *sectionTitleList = [[NSMutableArray alloc] init];
	NSInteger lastTypeID = 0;
	
	for( ItemListEntry *item in list )
	{
		if( lastTypeID != item.typeID )
		{
			[sectionTitleList addObject: [NSNumber numberWithInt: item.typeID]];
			lastTypeID = item.typeID;
		}
	}
	
	return [sectionTitleList autorelease];
}

@end

@implementation ItemListEntry

@synthesize sellPrice, buyable, icon, typeID, shortName;

- (void) loadIcon
{
	NSString *file = [NSString stringWithFormat: @"Images/Items/%@.png", self.shortName];
	self.icon = [[UIImage alloc] initWithContentsOfFile: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: file]];
}

-(void) dealloc
{
	[icon release];
	[shortName release];
	[super dealloc];
}

@end