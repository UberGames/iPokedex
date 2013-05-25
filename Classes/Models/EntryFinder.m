//
//  EntryFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 9/12/10.
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

#import "Bulbadex.h"
#import "EntryFinder.h"
#import "GameVersions.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

#define NUM_ALPHABETIC_SECTIONS 27

@implementation EntryFinder

@synthesize db, gameVersionGroups, gameVersionIgnoredCaptions;

- (id) init
{
	if( (self = [super init]) )
	{
		self.db = [[Bulbadex sharedDex] db];
	}
	
	return self;
}

- (NSMutableArray *) entriesFromDatabase
{
	//abstract method
	return nil;
}

- (void) reset
{
	//abstract
}

//generates a dictionary where the keys are the section names, and the contents are the table entries
//under each section
+ (NSDictionary *) alphabeticalSectionEntryListWithEntries: (NSArray *)entries
{
	//generate an array of arrays referring which item to which group
	NSMutableDictionary *entryList = [[NSMutableDictionary alloc] init];
	
	for( ListEntry *entry in entries )
	{
		//grab first letter of entry
		NSString *entryChar = [[entry.name substringToIndex: 1] uppercaseString];
		
		//add it to the dictionary
		NSMutableArray *existingArray;
		if( (existingArray = [entryList objectForKey: entryChar]) ) //if array object already exists
		{
			[existingArray addObject: entry];
		}
		else  //if no key exists now, add a new entry to the dict
		{
			existingArray = [[NSMutableArray alloc] init];
			[existingArray addObject: entry];
			[entryList setObject: existingArray forKey: entryChar];
			[existingArray release];
		}
	}
	
	//all good, return the completed array
	return (NSDictionary *)[entryList autorelease];
}

+ (NSArray *) alphabeticalSectionHeaderTitleListWithDictionary: (NSDictionary *)entries
{		 
	//append the list generated off the entries
	return [[entries allKeys] sortedArrayUsingSelector: @selector( caseInsensitiveCompare: )];
}

+ (NSArray *) alphabeticalSectionHeaderEntryListWithDictionary: (NSDictionary *)dict titleList: (NSArray *)titleList
{
	NSMutableArray *entryList = [[NSMutableArray alloc] init];
	
	for( NSString *title in titleList )
	{
		[entryList addObject: [dict objectForKey: title]];
	}
	
	return [entryList autorelease];
}
	
+ (NSArray *) alphabeticalSectionIndexTitleListWithSectionHeaderTitleList: (NSArray *)titles search: (BOOL) search
{
	NSMutableArray *titleList = [[NSMutableArray alloc] init];
	
	if( search )
		[titleList addObject: @"{search}"];
	
	//append the list generated off the entries
	[titleList addObjectsFromArray: titles];
	
	return (NSArray *)[titleList autorelease];
}

-(BOOL) mergeExclusiveEntryWithList: (NSArray *)entries entry: (ListEntry *)entry
{
    //check there is a valid instance of game version groups to check against
	if( self.gameVersionGroups == nil || entry.exclusiveVersionGroupID == 0 )
		return NO;
    
    //this entry has been requested of another object NOT to handle caption drawing
    //(But to still merge it)
    BOOL ignoreCaption = ([gameVersionIgnoredCaptions count] && 
                          [gameVersionIgnoredCaptions indexOfObject: [NSNumber numberWithInt: entry.exclusiveVersionGroupID]] != NSNotFound);
    
	//if this move is an exclusive, create an array and fill it with the version data
	if( entry.exclusiveVersionGroupID > 0 )
	{
        //add this group ID number to the list
        entry.versionGroupIDNumbers     = [NSMutableArray array];
        [entry.versionGroupIDNumbers    addObject: [NSNumber numberWithInt:entry.exclusiveVersionGroupID]];
        
        //if not ignoring captions, set up the arrays and add the string data
        if( ignoreCaption == NO )
        {
            NSArray *_versions = [self.gameVersionGroups objectForKey: [NSNumber numberWithInt: entry.exclusiveVersionGroupID]];
            
            entry.versionStrings    = [NSMutableArray array];
            entry.versionColors     = [NSMutableArray array];            
            
            for( GameVersion *_version in _versions )
            {
                [entry.versionStrings   addObject: _version.acronym ];
                [entry.versionColors    addObject: _version.color ];			
            }
        }
	}	
	
	//check if it is a unique case, but can be appended to the previous entry
	ListEntry *prev = [entries lastObject];
	if( prev && entry.exclusiveVersionGroupID > 0 )
	{
		//if the move is the same as the previous, merge this entry into the last
		//(Level is a bit of a dirty hack, but we know both will be 0 if the query didn't ask for levels)
		if ( entry.level == prev.level && entry.dbID == prev.dbID )
		{
            //if it's a complete duplicate of the previous object (Possible with the TM DB),
            //just clean forget about it
            if( entry.exclusiveVersionGroupID == prev.exclusiveVersionGroupID )
                return YES;
            
            //copy across the ID number
            [prev.versionGroupIDNumbers  addObjectsFromArray: entry.versionGroupIDNumbers];
            
            if( ignoreCaption )
                return YES;
            
			//copy across the arrays
			[prev.versionStrings addObjectsFromArray: entry.versionStrings];
			[prev.versionColors addObjectsFromArray: entry.versionColors];
            
            //update the entry to the latest version that was just merged onto it
			prev.exclusiveVersionGroupID = entry.exclusiveVersionGroupID;
            
			//Return YES (Which means don't bother adding this entry to the array)
			return YES;
		}
	}
	
	return NO;
}

- (void) dealloc
{
	[db release];
	[gameVersionGroups release];
	[super dealloc];
}

@end

@implementation ListEntry

@synthesize dbID, name, nameAlt, caption, level, versionGroupIDNumbers, versionStrings, versionColors, exclusiveVersionGroupID, indexPath;

- (id) initWithDatabaseID:(NSInteger)_id
{
	if( (self = [super init]) )
	{
		self.dbID = _id;
	}
	
	return self;
}

- (id)initWithResultSet: (FMResultSet *)rs
{
	if( (self = [super init]) )
	{
		self.dbID = [rs intForColumn: @"id"];
        
        if( LANGUAGE_IS_JAPANESE )
        {
            self.name = [rs stringForColumn: @"name_jp"];
            self.nameAlt = [rs stringForColumn: @"name"];
        }
        else
        {
            self.name = [rs stringForColumn: @"name"];
            self.nameAlt = [rs stringForColumn: @"name_jp"];
        }
    }
	
	return self;
}

- (void) loadIcon
{
	//overridden by child class
}

- (void)unloadIcon
{
    //overridden by child
}

- (NSString *)webName
{
    if( LANGUAGE_IS_JAPANESE )
        return [nameAlt stringByReplacingOccurrencesOfString: @" " withString: @"_"];
	else
        return [name stringByReplacingOccurrencesOfString: @" " withString: @"_"];
}

-(void) dealloc
{
	[name release];
	[nameAlt release];
    [caption release];
    [indexPath release];
	
    [versionGroupIDNumbers release];
	[versionStrings release];
	[versionColors release];
    
	[super dealloc];
}

@end