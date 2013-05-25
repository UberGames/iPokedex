//
//  PokemonExternalLinksViewEnglish.m
//  iPokedex
//
//  Created by Timothy Oliver on 15/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "PokemonExternalLinksView.h"
#import "UIImage+ImageLoading.h"
#import "Pokemon.h"

//English Defines
#define LINK_EN_BULBAPEDIA  0
#define LINK_EN_VEEKUN      1
#define LINK_EN_SEREBII     2
#define LINK_EN_SMOGON      3
#define LINK_EN_TOTAL       4

//Japanese Defines
#define LINK_JP_POKEMONWIKI 0
#define LINK_JP_YAKKUN      1
#define LINK_JP_TOTAL       2

@interface PokemonExternalLinksView (hidden)

- (NSString *)formeParticleFromSmogon;

//Language specific

//English
- (NSString *)englishTitleForLinkWithIndex: (NSInteger)index;
- (UIImage *)englishImageForLinkWithIndex: (NSInteger)index;
- (NSArray *)englishLinkChoicesForLinkWithIndex: (NSInteger)index;
- (NSURL *)englishURLForLinkWithIndex: (NSInteger)index withGen: (NSInteger)gen;

//Japanese
- (NSString *)japaneseTitleForLinkWithIndex: (NSInteger)index;
- (UIImage *)japaneseImageForLinkWithIndex: (NSInteger)index;
- (NSArray *)japaneseLinkChoicesWithIndex: (NSInteger)index;
- (NSURL *)japaneseURLForLinkWithIndex: (NSInteger)index withGen: (NSInteger)gen;

@end

@implementation PokemonExternalLinksView

@synthesize pokemonName, pokemonNdex, pokemonFormeShortName;

- (void)dealloc
{
    [pokemonName release];
    [pokemonFormeShortName release];
    [super dealloc];
}

#pragma mark - 
#pragma mark Super Class Overrides
- (NSInteger) numberOfLinks
{
    if( LANGUAGE_IS_JAPANESE )
        return LINK_JP_TOTAL;
    else
        return LINK_EN_TOTAL;
}

- (BOOL)buttonIsDisabledWithIndex: (NSInteger)index
{
    if( LANGUAGE_IS_JAPANESE )
        return NO;
        
    //Smogon has no content for Gen V yet
    if( index == LINK_EN_SMOGON && self.generation == 5 )
        return YES;
    
    return NO;
}

- (NSString *)titleForLinkWithIndex: (NSInteger)index
{
    if( LANGUAGE_IS_JAPANESE )
        return [self japaneseTitleForLinkWithIndex: index];
    else
        return [self englishTitleForLinkWithIndex: index];
    
    return nil;
}

- (UIImage *)imageForLinkWithIndex: (NSInteger)index
{
    if( LANGUAGE_IS_JAPANESE )
        return [self japaneseImageForLinkWithIndex: index];
    else
        return [self englishImageForLinkWithIndex: index];
    
    return nil;
}

- (NSArray *)choicesForLinkWithIndex: (NSInteger)index
{
    if( LANGUAGE_IS_JAPANESE )
        return [self japaneseLinkChoicesWithIndex: index];
    else
        return [self englishLinkChoicesForLinkWithIndex: index];
    
    return nil;
}

- (NSURL *)URLForLinkWithIndex: (NSInteger)index withGen: (NSInteger)gen
{
    if( LANGUAGE_IS_JAPANESE )
        return [self japaneseURLForLinkWithIndex: index withGen: gen];
    else
        return [self englishURLForLinkWithIndex: index withGen: gen];
        
    return nil;
}

#pragma mark -
#pragma mark English Methods
- (NSString *)englishTitleForLinkWithIndex:(NSInteger)index
{
    switch( index )
    {
        case LINK_EN_BULBAPEDIA:
            return @"Bulbapedia";
        case LINK_EN_VEEKUN:
            return @"Veekun";
        case LINK_EN_SEREBII:
            return @"Serebii.net";
        case LINK_EN_SMOGON:
            return @"Smogon University";
        default: 
            break;
    }
    
    return nil;
}

- (UIImage *)englishImageForLinkWithIndex:(NSInteger)index
{
    NSString *imageRoute = nil;
    
    switch (index)
    {
        case LINK_EN_BULBAPEDIA:
            imageRoute = @"Images/Logos/BulbapediaSmall.png";
            break;
        case LINK_EN_VEEKUN:
            imageRoute = @"Images/Logos/VeekunSmall.png";
            break;
        case LINK_EN_SEREBII:
            imageRoute = @"Images/Logos/SerebiiSmall.png";
            break;
        case LINK_EN_SMOGON: 
            imageRoute = @"Images/Logos/SmogonSmall.png";
            break;
        default:
            return nil;
    }
    
    return [UIImage imageFromResourcePath: imageRoute];
}

- (NSArray *)englishLinkChoicesForLinkWithIndex:(NSInteger)index
{
    switch (index) {
        case LINK_EN_BULBAPEDIA:
        case LINK_EN_VEEKUN:
            return nil;
        case LINK_EN_SEREBII:
        {
            NSMutableArray *linkChoices = [NSMutableArray array];
            
            [linkChoices addObject:@"Black/White Pokédex"];
            if( generation <= 4 ) { [linkChoices addObject: @"DPtHGSS Pokédex"]; }
            if( generation <= 3 ) { [linkChoices addObject: @"R/S/C/FR/LG/E Pokédex"]; }
            if( generation <= 2 ) { [linkChoices addObject: @"RBYGSC Pokédex"]; }
            
            return linkChoices;
        }
            break;
        case LINK_EN_SMOGON:
        {
            NSMutableArray *linkChoices = [NSMutableArray array];
            
            [linkChoices addObject:@"D/P"];
            if( generation <= 3 ) { [linkChoices addObject: @"R/S"]; }
            if( generation <= 2 ) { [linkChoices addObject: @"G/S"]; }
            if( generation <= 1 ) { [linkChoices addObject: @"R/B"]; }
            
            return linkChoices;
        }
            break;
    }
    
    return nil;

}

- (NSURL *)englishURLForLinkWithIndex:(NSInteger)index withGen:(NSInteger)gen
{
    //if the generation is invalid for this pokemon, return nil
    if( self.generation > gen )
        return nil;
    
    NSString *address = nil;
    
    switch (index )
    {
        case LINK_EN_BULBAPEDIA:
        {
            NSString *name = [pokemonName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
            address = [NSString stringWithFormat: @"http://bulbapedia.bulbagarden.net/wiki/%@_(Pok%%C3%%A9mon)", name];
        }
            break;
        case LINK_EN_VEEKUN:
            address = [NSString stringWithFormat: @"http://veekun.com/dex/pokemon/%@", pokemonName];
            address = [address stringByReplacingOccurrencesOfString: @" " withString: @"%20"];
            
            //add forme if possible
            if( pokemonFormeShortName )
                address = [address stringByAppendingFormat: @"?form=%@", pokemonFormeShortName];
            
            break;
        case LINK_EN_SEREBII:
        {
            //(generation 1 and 2 are merged, so gen 1 is actually the cancel button)
            if( gen == 1 )
                return nil;
            
            NSString *particle = @"";
            if( gen == 5 ) { particle = @"-bw"; }
            if( gen == 4 ) { particle = @"-dp"; }
            if( gen == 3 ) { particle = @"-rs"; }
            
            NSString *dexCode = [Pokemon formatDexNumberWithInt: pokemonNdex prependHash: NO];
            address = [NSString stringWithFormat: @"http://serebii.net/pokedex%@/%@.shtml", particle, dexCode];
        }
            break;
        case LINK_EN_SMOGON:
        {
            //Smogon is only up to gen 4, so account for that
            gen--;
            
            //cancel button
            if( gen == 0 || self.generation > gen )
                return nil;
            
            NSString *particle = nil;
            if( gen == 4 ) { particle = @"dp"; }
            if( gen == 3 ) { particle = @"rs"; }
            if( gen == 2 ) { particle = @"gs"; }
            if( gen == 1 ) { particle = @"rb"; }
            
            NSString *forme = nil;
            if( [pokemonFormeShortName length] )
                forme = [self formeParticleFromSmogon];
            
            NSString *linkName = pokemonName;
            if( forme )
                linkName = [linkName stringByAppendingString: forme];
            
            //remove any full stops from pokemon names
            linkName = [linkName stringByReplacingOccurrencesOfString: @"." withString: @""];
            //replace spaces with underscores
            linkName = [linkName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
            //all lowercase
            linkName = [linkName lowercaseString];
            
            address = [NSString stringWithFormat: @"http://www.smogon.com/%@/pokemon/%@", particle, linkName];
        }
            break;
    }
    
    return [NSURL URLWithString: address];
}

#pragma mark -
#pragma mark Japanese methods

- (NSString *)japaneseTitleForLinkWithIndex:(NSInteger)index
{
    switch( index )
    {
        case LINK_JP_POKEMONWIKI:
            return @"ポケモンWiki";
        case LINK_JP_YAKKUN:
            return @"ポケモン徹底攻略";
        default: 
            break;
    }
    
    return nil;
}

- (UIImage *)japaneseImageForLinkWithIndex:(NSInteger)index
{
    NSString *imageRoute = nil;
    
    switch (index)
    {
        case LINK_JP_POKEMONWIKI:
            imageRoute = @"Images/Logos/PokemonWikiSmall.png";
            break;
        case LINK_JP_YAKKUN:
            imageRoute = @"Images/Logos/YakkunSmall.png";
            break;
        default:
            return nil;
    }
    
    return [UIImage imageFromResourcePath: imageRoute];
}

- (NSArray *)japaneseLinkChoicesWithIndex:(NSInteger)index
{ 
    switch (index) {
        case LINK_JP_POKEMONWIKI:
            return nil;
            break;
        case LINK_JP_YAKKUN:
        {
            NSMutableArray *linkChoices = [NSMutableArray array];
            
            [linkChoices addObject:@"ブラック／ホワイト"];
            if( generation <= 4 ) { [linkChoices addObject: @"ダイヤモンド／パール／プラチナ"]; }
            return linkChoices;
        }
            break;
    }
    
    return nil;
    
}

- (NSURL *)japaneseURLForLinkWithIndex:(NSInteger)index withGen:(NSInteger)gen
{
    //if the generation is invalid for this pokemon, return nil
    if( self.generation > gen )
        return nil;
    
    NSString *address = nil;
    
    switch (index )
    {
        case LINK_JP_POKEMONWIKI:
        {
            NSString *name = [pokemonName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
            
            //convert the name to proper URL formatting
            NSString *encodedName = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                       NULL,
                                       (CFStringRef)name,
                                       NULL,
                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                       kCFStringEncodingUTF8 );
            
            address = [NSString stringWithFormat: @"http://wiki.xn--rckteqa2e.com/wiki/%@", encodedName];
            [encodedName release];
        }
            break;
        case LINK_JP_YAKKUN:
        {            
            NSString *baseAddress = @"";
            if( gen == 5 ) { baseAddress = @"http://bw.yakkun.com/zukan/n%d.htm"; }
            else if ( gen == 4 ) { baseAddress = @"http://yakkun.com/dp/zukan/n%d.htm"; }
            else { return nil; }
            
            address = [NSString stringWithFormat: baseAddress, pokemonNdex];
        }
            break;
    }
 
    return [NSURL URLWithString: address];
}

#pragma mark -
#pragma mark Per-source Specific methods
- (NSString *)formeParticleFromSmogon
{
    //this can't really be helped since the forme naming convention on Smogon is quite different to ours
    //We'll need to handle it on a per-case basis
    
    //deoxys
    if( pokemonNdex == 386 )
    {
        if( [pokemonFormeShortName isEqualToString: @"attack" ] )
            return @"-a";
        else if( [pokemonFormeShortName isEqualToString: @"defense" ] )
            return @"-d";
        else if( [pokemonFormeShortName isEqualToString: @"speed" ] )
            return @"-s";
        
        return nil;
    }
    
    //wormadam
    if( pokemonNdex == 413 )
    {
        if( [pokemonFormeShortName isEqualToString: @"sandy" ] )
            return @"-g";
        else if( [pokemonFormeShortName isEqualToString: @"trash" ] )
            return @"-s";
        
        return nil;
    }
    
    //rotom
    if( pokemonNdex == 479 )
    {
        if( [pokemonFormeShortName isEqualToString: @"mow" ] )
            return @"-c";
        else if( [pokemonFormeShortName isEqualToString: @"frost" ] )
            return @"-f";
        else if( [pokemonFormeShortName isEqualToString: @"heat" ] )
            return @"-h";
        else if( [pokemonFormeShortName isEqualToString: @"fan" ] )
            return @"-c";
        else if( [pokemonFormeShortName isEqualToString: @"wash" ] )
            return @"-w";
        
        return nil;
    }
    
    //giratina
    if( pokemonNdex == 487 )
    {
        if( [pokemonFormeShortName isEqualToString: @"origin" ] )
            return @"-o";
        
        return nil;
    }
    
    //shaymin
    if( pokemonNdex == 492 )
    {
        if( [pokemonFormeShortName isEqualToString: @"sky" ] )
            return @"-s";
        
        return nil;
    }
    
    return nil;
}

@end
