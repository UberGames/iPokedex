//
//  PokemonFlavorTexts.m
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

#import "PokemonFlavorTexts.h"


@implementation PokemonFlavorTexts

+ (NSArray *) pokemonFlavorTextsWithDatabaseID: (NSInteger) databasedID
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];	
	
	if( databasedID <= 0 )
		[NSException raise: NSInternalInconsistencyException format: @"NULL ID specified." ];	
	
	NSString *query = [NSString stringWithFormat: @"SELECT vft.*, ft.%@ AS 'flavor_text' \
													FROM pokemon_version_flavor_text AS vft, pokemon_flavor_text AS ft, pokemon AS p \
													WHERE ft.id = vft.flavor_text_id AND vft.ndex = p.ndex AND p.id = %d \
													ORDER BY version_id ASC", TCLocalizedColumn(@"flavor_text"), databasedID];
	
	FMResultSet *rs = [db executeQuery: query];
	if( rs == nil )
		return nil;
	
	NSMutableArray *flavorTexts = [[NSMutableArray alloc] init];
	
	while ( [rs next] )
	{
		PokemonFlavorText *text = [[PokemonFlavorText alloc] init];
		
		text.nDex = [rs intForColumn: @"ndex"];
		text.versionID = [rs intForColumn: @"version_id"];
		text.flavorTextID = [rs intForColumn: @"flavor_text_id"];
		text.flavorText = [rs stringForColumn: @"flavor_text"];
		
		[flavorTexts addObject: text];
		[text release];
	}
	
	return [flavorTexts autorelease];
}

+ (NSArray *) pokemonFlavorTextTableEntriesWithDatabaseID: (NSInteger) databasedID
{
	//grab all the versions from the DB
	NSDictionary *versions = [GameVersions gameVersionsFromDatabase];

	//Get the list of all entries for this pokemon
	NSArray *flavorTexts = [PokemonFlavorTexts pokemonFlavorTextsWithDatabaseID: databasedID];

	//we'll merge these two lists manually here
	NSMutableDictionary *generationEntries = [[NSMutableDictionary alloc] init];
	
	//loop through each entry and append it to the last
	//The rules are that if 2 adjacent entries ues the same Pokedex entry, merge them
	//Keep Generations completely separate
	
	//use this to derive the biggest generation
	NSInteger numGens = 0;
	
	for( PokemonFlavorText *flavorText in flavorTexts )
	{
		//Find the game version this dex entry is from
		GameVersion *version = [versions objectForKey: [NSNumber numberWithInt: flavorText.versionID] ];
		//use that to find out which generation's entries to grab
		NSMutableArray *genEntries = [generationEntries objectForKey: [NSNumber numberWithInt: version.generation]];
		
		if( version.generation > numGens )
			numGens = version.generation;
		
		//if an entry for this generation hasn't been spawned yet, spawn it now
		if( genEntries == nil )
			genEntries = [[[NSMutableArray alloc] init] autorelease];
		
		//grab the last object added to it so we can compare text IDs
		PokemonFlavorTextTableEntry *entry = [genEntries lastObject];
		//if the array is empty,spawn it now
		if( entry == nil )
		{
			entry = [[[PokemonFlavorTextTableEntry alloc] init] autorelease];
		}	
		else //compare the last result
		{
			//if the last entry's text ID matches this one, then both game versions 
			//use the same ID
			if ( entry.flavorTextID == flavorText.flavorTextID )
			{	
				//append this entry to that last one
				[entry.versionNames addObject: version.name];
				[entry.versionColors addObject: version.color];
				
				continue;
			}
			
			entry = [[[PokemonFlavorTextTableEntry alloc] init] autorelease];
		}
		
		//spawn the objects
		entry.versionNames = [NSMutableArray arrayWithObjects: version.name, nil];
		entry.versionColors = [NSMutableArray arrayWithObjects: version.color, nil];
		entry.flavorTextID = flavorText.flavorTextID;
		entry.flavorText = flavorText.flavorText;
		
		//add the entry to the generation group
		[genEntries addObject: entry];
		
		//push the new entry to the array
		[generationEntries setObject: genEntries forKey: [NSNumber numberWithInt: version.generation]];	
	}
	
	//convert the dictionary to a standard array
	NSMutableArray *tableEntries = [[[NSMutableArray alloc] init] autorelease];
	
	for ( NSInteger i = 0; i < [generationEntries count]; i++ )
		[tableEntries addObject: [generationEntries objectForKey: [NSNumber numberWithInt: numGens-i]]];
	
    [generationEntries release];
    
	return [[tableEntries reverseObjectEnumerator] allObjects];
}

@end

@implementation PokemonFlavorText

@synthesize nDex, versionID, flavorTextID, flavorText;

-(void)dealloc
{
	[flavorText release];
	[super dealloc];
}

@end

@implementation PokemonFlavorTextTableEntry

@synthesize versionNames, versionColors, flavorTextID, flavorText, cellHeight;

-(void) dealloc
{
	[versionNames release];
	[versionColors release];
	[flavorText release];
	
	[super dealloc];
}

@end
