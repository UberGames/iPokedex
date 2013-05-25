//
//  Pokemon.m
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

#import "UIImage+ImageLoading.h"
#import "Pokemon.h"
#import "Bulbadex.h"
#import "ElementalTypes.h"

@implementation Pokemon

//Accessor synthesis of properties
@synthesize dbID; 
@synthesize name; @synthesize nameJP; @synthesize nameJPRomaji; @synthesize namePhonetic;
@synthesize formeName; @synthesize formeShortName;
@synthesize generation;
@synthesize ndex; @synthesize kdex; @synthesize jdex; @synthesize hdex; @synthesize sdex; @synthesize udex;
@synthesize type1ID; @synthesize type2ID;
@synthesize type1, type2;
@synthesize species; 
@synthesize weight; @synthesize height;
@synthesize ability1ID, ability1Name; @synthesize ability2ID, ability2Name; @synthesize abilityHiddenID, abilityHiddenName;
@synthesize eggSteps; @synthesize eggGroup1ID, eggGroup1Name; @synthesize eggGroup2ID, eggGroup2Name;
@synthesize isBaby; @synthesize genderRate; @synthesize expYield; @synthesize catchRate; @synthesize expAtLv100; @synthesize baseHappiness;
@synthesize picture;
@synthesize stats;

- (id) initWithDatabaseID: (NSInteger)databaseID
{
	if( (self = [super init]) != nil )
	{
		self.dbID = databaseID;
	}
	
	return self;
}

- (void) loadPokemon
{
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	//load the pokemon data from the database
	NSString *query = [NSString stringWithFormat: @"SELECT p.*, \
                            rn.real_name AS 'real_name', \
                            f.%@ AS 'forme_name', \
                            f.short_name AS 'forme_shortname', \
                            egg1.%@  AS 'egg_group1_name', \
                            egg2.%@ AS 'egg_group2_name', \
                            a1.%@ AS 'ability1_name', \
                            a2.%@ AS 'ability2_name', \
                            ah.%@ AS 'abilitydream_name' \
                            FROM pokemon AS p \
                            LEFT JOIN pokemon_real_names AS rn ON rn.pokemon_id = p.id \
                            LEFT JOIN egg_groups AS egg1 ON egg1.id = p.egg_group1_id \
                            LEFT JOIN egg_groups AS egg2 ON egg2.id = p.egg_group2_id \
                            LEFT JOIN pokemon_formes AS f ON f.pokemon_id = p.id  \
                            LEFT JOIN abilities AS a1 ON p.ability1_id = a1.id \
                            LEFT JOIN abilities AS a2 ON p.ability2_id = a2.id \
                            LEFT JOIN abilities AS ah ON p.abilitydream_id = ah.id \
                            WHERE p.id = ? LIMIT 1", 
                       
                       TCLocalizedColumn( @"name" ), //forme
                       TCLocalizedColumn( @"name" ), //egg1
                       TCLocalizedColumn( @"name" ), //egg2
                       TCLocalizedColumn( @"name" ), //ability1
                       TCLocalizedColumn( @"name" ), //ability2
                       TCLocalizedColumn( @"name" ) //abilitydream
                       ];
	
	
	FMResultSet *rs = [db executeQuery: query, [NSNumber numberWithInt: self.dbID] ];
	if( rs == nil )
	{
		NSLog( @"Pokemon: ID %d doesn't exist.", self.dbID );
		return;
	}
	
	//increment it by one to load the first result
	[rs next];
	
	self.dbID = [rs intForColumn: @"id" ];
	
	self.name = [rs stringForColumn: @"name" ];
	self.nameJP = [rs stringForColumn: @"name_jp" ];
	self.nameJPRomaji = [rs stringForColumn: @"name_jp_romaji" ];
    self.namePhonetic = [rs stringForColumn: @"name_phonetic"];
	
    //detect real name mode
    NSNumber *realMode = [[NSUserDefaults standardUserDefaults] objectForKey: @"realNameMode"];
    if ( realMode && [realMode intValue] )
    {
        NSString *realName = [rs stringForColumn: @"real_name"];
        if( [realName length] > 0 )
            self.name = realName;
    }
        
	self.generation = [rs intForColumn: @"generation_id" ];
	
	self.formeName = [rs stringForColumn: @"forme_name" ];
	self.formeShortName = [rs stringForColumn: @"forme_shortname" ];
	
	self.ndex = [rs intForColumn: @"ndex" ];
	self.kdex = [rs intForColumn: @"kdex" ];
	self.jdex = [rs intForColumn: @"jdex" ];
	self.hdex = [rs intForColumn: @"hdex" ];
	self.sdex = [rs intForColumn: @"sdex" ];
    self.udex = [rs intForColumn: @"udex" ];
	
	self.type1ID = [rs intForColumn: @"type1_id" ];
	self.type1 = [ElementalTypes typeWithDatabaseID: self.type1ID];
	
	self.type2ID = [rs intForColumn: @"type2_id" ];
	self.type2 = [ElementalTypes typeWithDatabaseID: self.type2ID];
	
    //localize species
	self.species = [rs stringForColumn: TCLocalizedColumn(@"species") ];
	self.weight = [rs intForColumn: @"weight" ];
	self.height = [rs intForColumn: @"height" ];
	
	self.ability1ID = [rs intForColumn: @"ability1_id" ];
	self.ability1Name = [rs stringForColumn: @"ability1_name"];

	self.ability2ID = [rs intForColumn: @"ability2_id" ];
	self.ability2Name = [rs stringForColumn: @"ability2_name"];
	
    self.abilityHiddenID = [rs intForColumn: @"abilitydream_id"];
    self.abilityHiddenName = [rs stringForColumn: @"abilitydream_name"];
    
	self.eggSteps = ([rs intForColumn: @"hatch_counter"] + 1) * 255;
	
	self.eggGroup1ID = [rs intForColumn: @"egg_group1_id" ];
	self.eggGroup1Name = [rs stringForColumn: @"egg_group1_name"];
	
	self.eggGroup2ID = [rs intForColumn: @"egg_group2_id" ];
	self.eggGroup2Name = [rs stringForColumn: @"egg_group2_name"];
	
	self.genderRate = [rs intForColumn: @"gender_rate" ];
	
	self.isBaby = [rs intForColumn: @"is_baby" ];
	self.expYield = [rs intForColumn: @"exp_yield" ];
	self.catchRate = [rs intForColumn: @"catch_rate" ];
	
    self.expAtLv100 = [rs intForColumn: @"lvl_100_exp"];
    
    self.baseHappiness = [rs intForColumn: @"base_happiness"];
    
	//load the stats
	PokemonStats *_stats = [[PokemonStats alloc] initWithDatabaseID: self.dbID loadStats: YES];
	self.stats = _stats;
	[_stats release];
}

-(void) loadPicture
{
	NSString *fileName;
	
	if( self.formeShortName )
		fileName = [NSString stringWithFormat: @"Images/Pokemon/Large/%i-%@.png", self.ndex, self.formeShortName];
	else
		fileName = [NSString stringWithFormat: @"Images/Pokemon/Large/%i.png", self.ndex];
		
	self.picture = [UIImage imageFromResourcePath: fileName];
}

-(NSString *)species
{
	return  [NSString stringWithFormat: NSLocalizedString( @"%@ Pokémon", @"Pokémon Species" ), species];
}

-(NSString *)expAtLv100Value
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *formattedXP = [formatter stringFromNumber: [NSNumber numberWithInt: expAtLv100]];
    [formatter release];
    
    return formattedXP;
}

+ (NSString *)formatDexNumberWithInt: (NSInteger) ndex prependHash: (BOOL)prependHash
{
    NSString *hash = @"";
    if( prependHash )
        hash = @"#";
    
	if( ndex < 10 )
		return [NSString stringWithFormat: @"%@00%d", hash, ndex];
	else if ( ndex < 100 )
		return [NSString stringWithFormat: @"%@0%d", hash, ndex];
	else 
		return [NSString stringWithFormat: @"%@%d", hash, ndex];	   
}

- (NSString *)description
{
	return [NSString stringWithFormat: @"Pokemon: ID: %d, Ndex: %d, Name: %@, NameJP: %@", self.dbID, self.ndex, self.name, self.nameJP ];
}

- (void) dealloc
{
	[name release];
	[nameJP release];
	[nameJPRomaji release];
    [species release];
    [formeName release];
    [formeShortName release];
	[ability1Name release];
	[ability2Name release];
	[type1 release];
	[type2 release];
	[picture release];
	[eggGroup1Name release];
	[eggGroup2Name release];
	[stats release];
	
	[super dealloc];
}

@end
