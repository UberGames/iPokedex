//
//  Ability.m
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

#import "Ability.h"
#import "Bulbadex.h"
#import "UIColor+HexString.h"

@implementation Ability

@synthesize generation, nameJPMeaning, flavorText, inBattleEffect, outBattleEffect, color;

-(id)initWithDatabaseID:(NSInteger)databaseID
{
	if( (self=[super initWithDatabaseID: databaseID]) )
    {
        
    }
    
    return self;
}

-(void) loadAbility
{
    NSString *query = [NSString stringWithFormat: @"SELECT a.*, \
                                                        c.color, \
                                                        f.%@ AS 'flavor_text', \
                                                        ie.%@ AS 'in_effect', \
                                                        oe.%@ AS 'out_effect' \
                                                        FROM abilities AS a, ability_colors AS c, ability_generation_flavor_text AS gf, ability_flavor_text AS f \
                                                        LEFT JOIN ability_effects AS ie ON ie.ability_id = a.id AND ie.battle_status = 'in' \
                                                        LEFT JOIN ability_effects AS oe ON oe.ability_id = a.id AND oe.battle_status = 'out' \
                                                        WHERE gf.ability_id = a.id AND gf.generation_id = 5 AND gf.flavor_text_id = f.id AND a.color_id = c.id AND a.id = %d \
                                                        ORDER BY name LIMIT 1", TCLocalizedColumn( @"flavor_text" ), TCLocalizedColumn( @"effect" ), TCLocalizedColumn( @"effect" ), self.dbID];
    
    FMResultSet *rs = [[[Bulbadex sharedDex] db] executeQuery: query];
    if( rs == nil )
        return;
   
    [rs next];
    
    self.name               = [rs stringForColumn: @"name"];
    self.nameJP             = [rs stringForColumn: @"name_jp"];
    self.nameJPMeaning      = [rs stringForColumn: @"name_jp_tm"];
    self.generation         = [rs intForColumn: @"generation_id"];
    self.flavorText         = [rs stringForColumn: @"flavor_text"];
    self.inBattleEffect     = [rs stringForColumn: @"in_effect"];
    self.outBattleEffect    = [rs stringForColumn: @"out_effect"];
    self.color              = [UIColor colorWithHexString: [rs stringForColumn: @"color"]];

    self.loaded = YES;
}

- (void)dealloc
{
    [nameJPMeaning release];
    [inBattleEffect release];
    [outBattleEffect release]; 
    
    [super dealloc];
}

@end
