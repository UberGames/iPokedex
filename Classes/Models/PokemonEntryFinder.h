//
//  PokemonFinder.h
//  iPokedex
//
//  Created by Timothy Oliver on 23/11/10.
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

#import <Foundation/Foundation.h>
#import "EntryFinder.h"
#import "GameVersions.h"
#import "ElementalTypes.h"

#define POKEMON_EVOLUTION_BABY_KEY @"baby"
#define POKEMON_EVOLUTION_BASE_KEY @"base"
#define POKEMON_EVOLUTION_FIRST_KEY @"first"
#define POKEMON_EVOLUTION_SECOND_KEY @"second"

#define POKEMON_NUM_DEX_SECTION_INDICIES 20

typedef enum 
{
	PokemonEntryCaptionNone=0,
	PokemonEntryCaptionLanguageName
} PokemonEntryCaption;

@interface PokemonListEntry : ListEntry {
	
	NSInteger nDexNumber;
	NSInteger regionDexNumber;
	
	NSString *dexText;
	NSString *species;
	
	UIImage *icon;
	BOOL iconLoaded;
	
	NSInteger type1Id;
	UIImage *type1Icon;
	
	NSInteger type2Id;
	UIImage *type2Icon;
	
	NSString *formeName;
    NSString *formeNameAlt;
	NSString *formeShortName;
}

-(id) initWithDatabaseResults: (FMResultSet *)results;

@property (nonatomic, assign) NSInteger nDexNumber;
@property (nonatomic, assign) NSInteger regionDexNumber;
@property (nonatomic, retain) NSString *dexText;
@property (nonatomic, retain) NSString *species;

@property (nonatomic, assign) NSInteger type1Id;
@property (nonatomic, retain) UIImage *type1Icon;

@property (nonatomic, assign) NSInteger type2Id;
@property (nonatomic, retain) UIImage *type2Icon;

@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, assign) BOOL iconLoaded;

@property (nonatomic, retain) NSString *formeName;
@property (nonatomic, retain) NSString *formeNameAlt;
@property (nonatomic, retain) NSString *formeShortName;

@end;

typedef enum 
{
	PokemonFinderSortByNumber,
	PokemonFinderSortByName
} PokemonFinderSort;

@interface PokemonEntryFinder : EntryFinder {
	NSInteger generationID; //limited to 1 generation
	NSInteger moveID;		//limited to 1 move the pokemon can learn
	NSInteger dexId;		//The dex ID to use
	NSInteger typeId;		//Pokemon type
	NSInteger eggGroup1ID;
	NSInteger eggGroup2ID;
    NSInteger abilityID;

	PokemonFinderSort sortedOrder; //Set the way it's sorted
}

+ (NSInteger) databaseIDOfPokemonWithName: (NSString *)name;
+ (BOOL) pokemonHasEvolutionsWithDatabaseID: (NSInteger) dbID;
+ (NSDictionary *) pokemonEvolutionsWithDatabaseID: (NSInteger) dbID;
+ (NSInteger) generationOfPokemonWithDatabaseID: (NSInteger) dbID;

-(NSArray *) availableLearnCategoriesFromDatabase;

-(NSArray *) moveLevelPokemonFromDatabase;
-(NSArray *) moveTMPokemonFromDatabase;
-(NSArray *) moveBreedPokemonFromDatabase;
-(NSArray *) moveTutorPokemonFromDatabase;

+ (NSDictionary *) dexSectionIndexEntriesWithEntries: (NSArray *)entries;
+ (NSArray *) dexSectionIndexTitlesWithDictionary:(NSDictionary *)entries search: (BOOL) search;
+ (NSArray *) dexSectionIndexIndiciesWithDictionary: (NSDictionary *)entries titleList: (NSArray *)titleList;

+ (PokemonListEntry *) pokemonWithDatabaseID: (NSInteger)databaseId;
+ (NSArray *) pokemonWithDatabaseIDList: (NSArray *) IDList;
+ (NSDictionary *) pokemonWithLegacyDatabaseIDList: (NSArray *)IDList;

+ (NSString *) pokemonRandomDexTextWithNdexID: (NSInteger) ndexID;

@property (nonatomic, assign) NSInteger generationID;
@property (nonatomic, assign) NSInteger moveID;
@property (nonatomic, assign) NSInteger dexId;	
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, assign) NSInteger eggGroup1ID;
@property (nonatomic, assign) NSInteger eggGroup2ID;
@property (nonatomic, assign) NSInteger abilityID;
@property (nonatomic, assign) PokemonFinderSort sortedOrder;

@end

