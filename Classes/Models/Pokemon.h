//
//  Pokemon.h
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

#import <Foundation/Foundation.h>

//Pokemon Objects
#import "PokemonStats.h"
#import "Ability.h"
#import "EggGroup.h"
#import "ElementalTypes.h"

@interface Pokemon : NSObject {
	//------
	
	NSInteger dbID;				//DB ID of the Pokémon
	
	//Name
	NSString *name;
	NSString *nameJP;
	NSString *nameJPRomaji;
    NSString *namePhonetic;
	
	//Forme
	NSString *formeName;
	NSString *formeShortName;
	
	//Generation
	NSInteger generation;
	
	//Pokedex number entries
	NSInteger ndex;				
	NSInteger kdex;
	NSInteger jdex;
	NSInteger hdex;
	NSInteger sdex;
    NSInteger udex;
	
	//Evolution
	
	//Types
	NSInteger type1ID;
	ElementalType *type1;
	
	NSInteger type2ID;
	ElementalType *type2;
	
	//Species
	NSString *species;
	
	//Height/Weight
	NSInteger weight;
	NSInteger height;

	//Abilities
	NSInteger ability1ID;
	NSString *ability1Name;
	
	NSInteger ability2ID;
	NSString *ability2Name;
	
    NSInteger abilityHiddenID;
    NSString *abilityHiddenName;
    
	//Egg chain data
	NSInteger eggSteps;
	
	//Egg Groups
	NSInteger eggGroup1ID;
	NSString *eggGroup1Name;
	
	NSInteger eggGroup2ID;
	NSString *eggGroup2Name;
	
	//Is Baby Evolution Form
	BOOL isBaby;
	
	//Gender Rate
	NSInteger genderRate;

	//Experience yield of the Pokemon
	NSInteger expYield;
	
	//Pokemon catch rate
	NSInteger catchRate;
	
	//the EV and Base stats of the Pokemon
	PokemonStats *stats;
    
    //The final amount of XP this Pokemon can acrue
    NSInteger expAtLv100;
    
    //Base happiness of the Pokemon
    NSInteger baseHappiness;
	
	UIImage *picture;
}

- (id) initWithDatabaseID: (NSInteger)databaseID;
- (void) loadPokemon;
- (void) loadPicture;

+ (NSString *)formatDexNumberWithInt: (NSInteger) ndex prependHash: (BOOL)prependHash;

@property (assign, nonatomic) NSInteger dbID;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *nameJP;
@property (retain, nonatomic) NSString *nameJPRomaji;
@property (retain, nonatomic) NSString *namePhonetic;
@property (retain, nonatomic) NSString *formeName;
@property (retain, nonatomic) NSString *formeShortName;
@property (assign, nonatomic) NSInteger generation;
@property (assign, nonatomic) NSInteger ndex;				
@property (assign, nonatomic) NSInteger kdex;
@property (assign, nonatomic) NSInteger jdex;
@property (assign, nonatomic) NSInteger hdex;
@property (assign, nonatomic) NSInteger sdex;
@property (assign, nonatomic) NSInteger udex;
@property (assign, nonatomic) NSInteger type1ID;
@property (retain, nonatomic) ElementalType *type1;
@property (assign, nonatomic) NSInteger type2ID;
@property (retain, nonatomic) ElementalType *type2;
@property (retain, nonatomic) NSString *species;
@property (assign, nonatomic) NSInteger weight;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger ability1ID;
@property (retain, nonatomic) NSString *ability1Name;
@property (assign, nonatomic) NSInteger ability2ID;
@property (retain, nonatomic) NSString *ability2Name;
@property (assign, nonatomic) NSInteger abilityHiddenID;
@property (retain, nonatomic) NSString *abilityHiddenName;
@property (assign, nonatomic) NSInteger eggSteps;
@property (assign, nonatomic) NSInteger eggGroup1ID;
@property (retain, nonatomic) NSString *eggGroup1Name;
@property (assign, nonatomic) NSInteger eggGroup2ID;
@property (retain, nonatomic) NSString *eggGroup2Name;
@property (assign, nonatomic) BOOL isBaby;
@property (assign, nonatomic) NSInteger genderRate;
@property (assign, nonatomic) NSInteger expYield;
@property (assign, nonatomic) NSInteger catchRate;
@property (assign, nonatomic) NSInteger expAtLv100;
@property (readonly) NSString *expAtLv100Value;
@property (nonatomic, assign) NSInteger baseHappiness;
@property (retain, nonatomic) PokemonStats *stats;
@property (retain, nonatomic) UIImage *picture;

@end
