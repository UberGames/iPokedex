//
//  MoveExternalLinksView.m
//  iPokedex
//
//  Created by Timothy Oliver on 17/05/11.
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

#import "MoveExternalLinksView.h"
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
#define LINK_JP_TOTAL       1

@interface MoveExternalLinksView (hidden)

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

@implementation MoveExternalLinksView

@synthesize moveName;

#pragma mark - 
#pragma mark Life Cycle
- (void)dealloc
{
    [super dealloc];
    
    [moveName release];
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
            
            [linkChoices addObject:@"Attackdex BW"];
            if( generation <= 4 ) { [linkChoices addObject: @"Attackdex DPPt"]; }
            if( generation <= 3 ) { [linkChoices addObject: @"Attackdex"]; }
            
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
            NSString *name = [moveName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
            address = [NSString stringWithFormat: @"http://bulbapedia.bulbagarden.net/wiki/%@_(move)", name];
        }
            break;
        case LINK_EN_VEEKUN:
            address = [NSString stringWithFormat: @"http://veekun.com/dex/moves/%@", moveName];
            address = [address stringByReplacingOccurrencesOfString: @" " withString: @"%20"];
            break;
        case LINK_EN_SEREBII:
        {            
            //(generation 1 and 2 are merged, so gen 2 is actually the cancel button)
            if( gen <= 2 )
                return nil;
            
            NSString *particle = @"";
            if( gen == 5 ) { particle = @"-bw"; }
            if( gen == 4 ) { particle = @"-dp"; }

            NSString *formattedName = [[moveName stringByReplacingOccurrencesOfString: @" " withString: @""] lowercaseString];
            address = [NSString stringWithFormat: @"http://serebii.net/attackdex%@/%@.shtml", particle, formattedName];
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
            
            NSString *linkName = moveName;
            
            //remove any full stops from pokemon names
            linkName = [linkName stringByReplacingOccurrencesOfString: @"." withString: @""];
            //replace spaces with underscores
            linkName = [linkName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
            //all lowercase
            linkName = [linkName lowercaseString];
            
            address = [NSString stringWithFormat: @"http://www.smogon.com/%@/moves/%@", particle, linkName];
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
            NSString *name = [moveName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
            
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
    }
    
    return [NSURL URLWithString: address];
}

@end
