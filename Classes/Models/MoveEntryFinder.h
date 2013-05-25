//
//  MoveEntryFinder.h
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

#import <Foundation/Foundation.h>
#import "EntryFinder.h"
#import "GameVersions.h"

@interface MoveListEntry : ListEntry {
	
	UIImage *typeIcon;
	UIImage *categoryIcon;
	
	NSInteger elementalTypeID;
	NSInteger categoryID;
	
	NSInteger power;
	NSString *powerValue;
	
	NSInteger accuracy;
	NSString *accuracyValue;
	
	NSInteger PP;
	NSString *PPValue;
}

- (id) initWithResultSet: (FMResultSet *)results;

@property (nonatomic, retain) UIImage *typeIcon;
@property (nonatomic, retain) UIImage *categoryIcon;

@property (nonatomic, assign) NSInteger elementalTypeID;
@property (nonatomic, assign) NSInteger categoryID;

@property (nonatomic, assign) NSInteger power;
@property (nonatomic, copy) NSString *powerValue;
@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, copy) NSString *accuracyValue;
@property (nonatomic, assign) NSInteger PP;
@property (nonatomic, copy) NSString *PPValue;

@end

//----------------------------------------------------------------

typedef enum 
{
	MoveFinderSortByName=0,
	MoveFinderSortByPower,
	MoveFinderSortByPP
} MoveFinderSort;

@interface MoveEntryFinder : EntryFinder {
	//General move list sorting
	NSInteger typeID;
	NSInteger categoryID;
	NSInteger generationID;
	NSInteger pokemonID;
	
	NSDictionary *versions;
	
	MoveFinderSort sortedOrder;
}

+(NSInteger) databaseIDOfMoveWithName: (NSString *)name;
+(MoveListEntry *) moveWithDatabaseID: (NSInteger) databaseID;
+(NSArray *) movesWithDatabaseIDList: (NSArray *) IDList;
+(NSInteger) generationOfMoveWithDatabaseID: (NSInteger) databaseID;

-(NSArray *) availableLearnCategoriesFromDatabase;
-(NSArray *) pokemonLevelMovesFromDatabase;
-(NSArray *) pokemonTechnicalMachineMovesFromDatabase;
-(NSArray *) pokemonTutorMovesFromDatabase;
-(NSArray *) pokemonEggMovesFromDatabase;

@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, assign) NSInteger generationID;
@property (nonatomic, assign) NSInteger pokemonID;
@property (nonatomic, retain) NSDictionary *versions;
@property (nonatomic, assign) MoveFinderSort sortedOrder;

@end