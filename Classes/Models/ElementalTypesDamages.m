//
//  ElementalTypesDamage.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/02/11.
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

#import "ElementalTypesDamages.h"
#import "Bulbadex.h"

@implementation ElementalTypesDamages

+ (NSDictionary *) damagesWithPokemonId: (NSInteger) pokemonId
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_typeDamages = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT d.* FROM elemental_types_dmg AS d, pokemon AS p \
																		WHERE (defense_type_id = p.type1_id OR defense_type_id = p.type2_id) AND p.id = %d \
																		ORDER BY attack_type_id ASC, damage_multiplier DESC", pokemonId] ];
	while ( [rs next] ) {
		//get the type id
		NSInteger typeId = [rs intForColumn: @"attack_type_id"];
		
		//see if an entry has been created for it already
		//(Must be retained if it already exists since it won't get retained again when added back to the object)
		ElementalTypesDamage *typeDamage = [_typeDamages objectForKey: [NSNumber numberWithInt: typeId]];
		if( typeDamage == nil )
			typeDamage = [[[ElementalTypesDamage alloc] initWithTypeId: typeId] autorelease];
		
        NSInteger damagePercentile = [rs intForColumn: @"damage_multiplier"];
        
		//if this is currently null (eg un-init'd), add the damage directly to it
		if( typeDamage.damagePercentile == 0 && damagePercentile > 0 )
			typeDamage.damagePercentile = damagePercentile;
		else //else stack the 2 damages together
			typeDamage.damagePercentile *= ((CGFloat)damagePercentile/100.0f);
        
		[_typeDamages setObject: typeDamage forKey: [NSNumber numberWithInt: typeId ] ];
	}
	
	//push the array to the class instance
	return [_typeDamages autorelease];
}

+ (NSDictionary *) damagesWithType1: (NSInteger) type1Id
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_typeDamages = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM elemental_types_dmg WHERE defense_type_id = %d ORDER BY attack_type_id ASC", type1Id] ];
	while ( [rs next] ) {
		ElementalTypesDamage *typeDamage = [[ElementalTypesDamage alloc] initWithTypeId: [rs intForColumn: @"attack_type_id"]];
		
		typeDamage.damagePercentile = [rs intForColumn: @"damage_multiplier"];
		
		[_typeDamages setObject: typeDamage forKey: [NSNumber numberWithInt: type1Id ] ];
		[typeDamage release];
	}
	
	//push the array to the class instance
	return [_typeDamages autorelease];
}

+ (NSDictionary *) damagesWithType1: (NSInteger) type1Id withType2: (NSInteger) type2Id
{
	//get DB from the app delegate
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	if ( db == nil )
		[NSException raise: NSInternalInconsistencyException format: @"DB file was invalid." ];
	
	NSMutableDictionary *_typeDamages = [[NSMutableDictionary alloc] init];
	
	//grab all of the items from the db
	FMResultSet *rs = [db executeQuery: [NSString stringWithFormat: @"SELECT * FROM elemental_types_dmg WHERE defense_type_id = %d OR defense_type_id = %d ORDER BY attack_type_id ASC", type1Id, type2Id] ];
	while ( [rs next] ) {
		//get the type id
		NSInteger typeId = [rs intForColumn: @"attack_type_id"];
		
		//see if an entry has been created for it already
		ElementalTypesDamage *typeDamage = [_typeDamages objectForKey: [NSNumber numberWithInt: typeId]];
		if( typeDamage == nil )
			typeDamage = [[[ElementalTypesDamage alloc] initWithTypeId: typeId] autorelease];
		
		//if this is currently null, add the damage directly to it
		if( typeDamage.damagePercentile == 0 )
			typeDamage.damagePercentile = [rs intForColumn: @"damage_multiplier"];
		else //else stack the 2 damages together
			typeDamage.damagePercentile *= (NSInteger)((CGFloat)[rs intForColumn: @"damage_multiplier"]/100.0f);
		
		[_typeDamages setObject: typeDamage forKey: [NSNumber numberWithInt: typeId ] ];
	}
	
	//push the array to the class instance
	return [_typeDamages autorelease];
}

@end

@implementation ElementalTypesDamage

@synthesize typeId, damagePercentile;

-(id) initWithTypeId: (NSInteger) _typeId
{
	if( (self = [super init]) )
	{
		self.typeId = _typeId;
		self.damagePercentile = 0;
	}
	
	return self;
}

-(NSString *) description
{
	return [NSString stringWithFormat: @"%d %d", typeId, damagePercentile];
}

-(void)dealloc
{
	[super dealloc];
}

@end