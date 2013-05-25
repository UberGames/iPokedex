//
//  Move.m
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

#import "Move.h"

@implementation Move

@synthesize dbID, name, nameJP, nameJPMeaning;
@synthesize generation;
@synthesize typeID, type, categoryID, category, PP, maxPP, ppHasChangeLog, power, powerHasChangeLog, powerValue, accuracy, accuracyHasChangeLog, accuracyValue;
@synthesize flags, changeLog;
@synthesize targetID, flavorText, effectText;

- (id)initWithDatabaseID: (NSInteger)databaseID
{
	if( (self = [super init]) )
	{
		self.dbID = databaseID;
	}
	
	return self;
}

- (void) loadMove
{
	FMDatabase *db = [[Bulbadex sharedDex] db];
	
	NSString *query = [NSString stringWithFormat: @"SELECT m.*, mf.*, mft.%@ AS 'flavor_text', me.%@ AS 'effect' \
													FROM moves AS m \
                                                    LEFT JOIN move_effects AS me ON m.effect_id = me.id AND m.effect_id > 1 \
													LEFT JOIN move_flags AS mf ON m.id = mf.move_id \
													LEFT JOIN move_flavor_text AS mft ON m.id = mft.move_id \
													WHERE m.id = %d \
													ORDER BY mft.generation_id DESC \
													LIMIT 1", TCLocalizedColumn(@"flavor_text"), TCLocalizedColumn(@"effect"), self.dbID];

	FMResultSet *rs = [db executeQuery: query];
	if( rs == nil )
		return;
	
	//load the entry into the result set
	[rs next];
	
	//name
	self.name					= [rs stringForColumn: @"name"];
	self.nameJP                     = [rs stringForColumn: @"name_jp"];
	self.nameJPMeaning			= [rs stringForColumn: @"name_jp_tm"];
	
    self.generation             = [rs intForColumn: @"generation_id"];
    
	//categories
	self.typeID					= [rs intForColumn: @"type_id"];
	self.categoryID				= [rs intForColumn: @"category_id"];
	
	//PP
	self.PP						= [rs intForColumn: @"pp"];
	self.maxPP					= ceil(self.PP*1.6f);
	
    self.power                  = [rs intForColumn: @"power"];

	self.accuracy				= [rs intForColumn: @"accuracy"];
	
	//flags
	MoveFlagsStruct _flags;
	_flags.makesContact			= [rs intForColumn: @"makes_contact"];
	_flags.affectedByProtect	= [rs intForColumn: @"protect_affected"];
	_flags.affectedByMagicCoat	= [rs intForColumn: @"magic_coat_affected"];
	_flags.affectedBySnatch		= [rs intForColumn: @"snatch_affected"];
	_flags.affectedByBrightPowder	= [rs intForColumn: @"brightpowder_affected"];
	_flags.affectedByKingsRock	= [rs intForColumn: @"kings_rock_affected"];
    
    //bright powder was discontinued after gen 2
    if( self.generation > 2 )
        _flags.affectedByBrightPowder = -1;
    
	self.flags = _flags;
	
	//flavor text
	self.flavorText				= [rs stringForColumn: @"flavor_text"];
	
    //effect text
    self.effectText             = [rs stringForColumn: @"effect"];
    
    //insert effect chance into string
    NSInteger effectChance      = [rs intForColumn: @"effect_chance"];
    if( [effectText length] > 0 && effectChance > 0 )
        self.effectText = [NSString stringWithFormat: effectText, effectChance, effectChance, effectChance ];
    
	//load type / category assets
	self.type = [ElementalTypes typeWithDatabaseID: typeID];
	self.category = [MoveCategories categoryFromDatabaseWithID: categoryID ];
    
    //----------------------------------------------------------------------
    //Load move changelog
    
    query = [NSString stringWithFormat: @"SELECT cl.*, g.%@ AS 'generation_name' \
                                            FROM move_changelog AS cl LEFT JOIN generations AS g ON g.id = cl.changed_in_generation_id \
                                            WHERE cl.move_id = %d ORDER BY cl.changed_in_generation_id", TCLocalizedColumn(@"name"), self.dbID];
    rs = [db executeQuery: query];
    
    while( [rs next] )
    {
        //if it doesn't exist already, create the changelog class
        if( self.changeLog == nil )
            self.changeLog = [NSMutableDictionary dictionary];
        
        NSInteger _generation = [rs intForColumn: @"changed_in_generation_id"];
        NSString *generationName = [rs stringForColumn: @"generation_name"];
        
        NSArray *keys = [NSArray arrayWithObjects: @"power", @"accuracy", @"pp", nil];
        
        for( NSString *key in keys )
        {
            NSInteger oldValue = [rs intForColumn: key];

            if( oldValue <= 0 )
                continue;
            
            MoveChangeLogEntry *entry = [[MoveChangeLogEntry alloc] init];
            entry.generation = _generation;
            entry.generationName = generationName;
            entry.previousValue = oldValue;
            
            NSMutableArray *powerEntries = [self.changeLog objectForKey: key];
            if( powerEntries == nil )
                powerEntries = [[NSMutableArray new] autorelease];
            
            [powerEntries addObject: entry];
            [self.changeLog setObject: powerEntries forKey: key];
            
            //manually set the changelog booleans
            if( [key isEqualToString: @"power"] )
                self.powerHasChangeLog = YES;
            else if( [key isEqualToString: @"accuracy"] )
                self.accuracyHasChangeLog = YES;
            else if( [key isEqualToString: @"pp"] )
                self.ppHasChangeLog = YES;
            
            [entry release];
        }
    };
}

-(NSString *)powerValue
{
    NSString *output = @"";
    
    //work out power value
    if( self.power == 0 )
        output = @"-";
    else if (self.power == 1 )
        output = @"→";
    else
        output = [NSString stringWithFormat: @"%d", self.power];
    
    if( powerHasChangeLog )
        output = [output stringByAppendingString: @"*"];
    
    return output;
}

-(NSString *)accuracyValue
{
	if( accuracy <= 0 )
		return @"-";
	
	return [NSString stringWithFormat: @"%d%%%@", accuracy, (accuracyHasChangeLog ? @"*" : @"")];
}

-(NSString *)PPValue
{
	return [NSString stringWithFormat: @"%d%@", PP, (ppHasChangeLog ? @"*" : @"")];
}

-(NSString *)maxPPValue
{
	return [NSString stringWithFormat: @"%d%@", maxPP, (ppHasChangeLog ? @"*" : @"")];
}

-(void) dealloc
{
	[type release];
	[category release];
	
	[name release];
	[nameJP release];
	[nameJPMeaning release];
	
	[powerValue release];
	
	[flavorText release];
	[effectText release];
    
    [changeLog release];
    
	[super dealloc];
}

@end

@implementation MoveChangeLogEntry

@synthesize generation, generationName, previousValue;

- (NSString *)description
{
    return [NSString stringWithFormat: @"Generation: %d Value changed: %d", generation, previousValue];
}

- (void)dealloc
{
    [generationName release];
    
    [super dealloc];
}

@end
