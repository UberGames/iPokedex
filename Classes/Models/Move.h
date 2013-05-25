//
//  Move.h
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

#import "Bulbadex.h"
#import "ElementalTypes.h"
#import "MoveCategories.h"

struct MoveFlagsStruct
{
	NSInteger makesContact;
	NSInteger affectedByProtect;
	NSInteger affectedByMagicCoat;
	NSInteger affectedBySnatch;
	NSInteger affectedByBrightPowder;
	NSInteger affectedByKingsRock;
};
typedef struct MoveFlagsStruct MoveFlagsStruct;

@interface Move : NSObject {
	//------
	
	NSInteger dbID;				//DB ID of the Move
	
	//Name
	NSString *name;
	NSString *nameJP;
	NSString *nameJPMeaning;

    NSInteger generation;
    
	//type/category
	NSInteger typeID;
	ElementalType *type;
	
	NSInteger categoryID;
	MoveCategory *category;
	
	//PP
	NSInteger PP;
	NSInteger maxPP;
	BOOL ppHasChangeLog;
    
	//Power
    NSInteger power;
	BOOL powerHasChangeLog;
    
	//Accuracy
	NSInteger accuracy;
	BOOL accuracyHasChangeLog;
    
	MoveFlagsStruct flags;
	
	NSInteger targetID;
	
	NSString *flavorText;
    NSString *effectText;
    
    NSMutableDictionary *changeLog;
}

- (id)initWithDatabaseID: (NSInteger)databaseID;
- (void) loadMove;

@property (nonatomic, assign) NSInteger dbID;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nameJP;
@property (nonatomic, retain) NSString *nameJPMeaning;

@property (nonatomic, assign) NSInteger generation;

@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, retain) ElementalType *type;

@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, retain) MoveCategory *category;

@property (nonatomic, assign) NSInteger PP;
@property (nonatomic, readonly) NSString *PPValue;
@property (nonatomic, assign) BOOL ppHasChangeLog;

@property (nonatomic, assign) NSInteger maxPP;
@property (nonatomic, readonly) NSString *maxPPValue;

@property (nonatomic, assign) NSInteger power;
@property (nonatomic, readonly) NSString *powerValue;
@property (nonatomic, assign) BOOL powerHasChangeLog;

@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, readonly) NSString *accuracyValue;
@property (nonatomic, assign) BOOL accuracyHasChangeLog;

@property (nonatomic, assign) MoveFlagsStruct flags;

@property (nonatomic, assign) NSInteger targetID;

@property (nonatomic, copy) NSString *flavorText;
@property (nonatomic, copy) NSString *effectText;

@property (nonatomic, retain) NSMutableDictionary *changeLog;

@end

//------------------------------------------------
//Changelog object

@interface MoveChangeLogEntry : NSObject {
    NSInteger generation;
    NSString *generationName;
    NSInteger previousValue;
}

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, copy) NSString *generationName;
@property (nonatomic, assign) NSInteger previousValue;

@end
