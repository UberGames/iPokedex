//
//  PokemonFlavorTexts.h
//  iPokedex
//
//  Created by Timothy Oliver on 17/02/11.
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

#import <Foundation/Foundation.h>
#import "Bulbadex.h"
#import "GameVersions.h"

@interface PokemonFlavorTexts : NSObject {
	
}

+ (NSArray *) pokemonFlavorTextsWithDatabaseID: (NSInteger) databasedID;
+ (NSArray *) pokemonFlavorTextTableEntriesWithDatabaseID: (NSInteger) databasedID;

@end

@interface PokemonFlavorText : NSObject {
	NSInteger nDex;
	NSInteger versionID;
	NSInteger flavorTextID;
	NSString *flavorText;
}

@property (nonatomic, assign) NSInteger nDex;
@property (nonatomic, assign) NSInteger versionID;
@property (nonatomic, assign) NSInteger flavorTextID;
@property (nonatomic, retain) NSString *flavorText;

@end

@interface PokemonFlavorTextTableEntry : NSObject {
	NSMutableArray *versionNames;
	NSMutableArray *versionColors;
	
	NSInteger flavorTextID;
	NSString *flavorText;
	
	CGFloat cellHeight;
}

@property (nonatomic, retain) NSMutableArray *versionNames;
@property (nonatomic, retain) NSMutableArray *versionColors;
@property (nonatomic, assign) NSInteger flavorTextID;
@property (nonatomic, copy) NSString *flavorText;
@property (nonatomic, assign) CGFloat cellHeight;

@end