//
//  Favorites.h
//  iPokedex
//
//  Created by Timothy Oliver on 13/03/11.
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

#define USERDEFAULTS_FAVORITES @"Favorites"

#define FAVORITES_POKEMON @"Pokemon"
#define FAVORITES_MOVES @"Moves"
#define FAVORITES_ABILITIES @"Abilities"
#define FAVORITES_EGGGROUPS @"EggGroups"

#define FAVORITES_KEY_ARRAY [NSArray arrayWithObjects: @"Pokemon", @"Moves", @"Abilities", @"EggGroups", nil ]

@interface Favorites : NSObject {
    NSMutableDictionary *favorites;
    
    UIImage *favoritedOff;
    UIImage *favoritedOn;
    
    //If a favorite gets changed, set this to let the
    //favorites menu know it needs to refresh
    BOOL forceRefresh;
}

+ (Favorites *)sharedFavorites;
-(void) toggleFavoriteIconInBarButton: (UIBarButtonItem *)barItem withResult: (BOOL)on;
-(void)reorderFavoriteEntryWithKey: (NSString *)key fromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;

- (UIBarButtonItem *) barButtonForPokemonWithPokemonID: (NSInteger) databaseID target: (id)target;
- (BOOL)toggleFavoritePokemonWithPokemonID: (NSInteger) databaseID fromController: (UIViewController *)controller;
- (void)removeFavoritePokemonWithPokemonID: (NSInteger) databaseID;
- (void)reorderFavoritePokemonFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;

- (UIBarButtonItem *) barButtonForMoveWithMoveID: (NSInteger) databaseID target: (id)target;
- (BOOL)toggleFavoriteMoveWithMoveID: (NSInteger) databaseID fromController: (UIViewController *)controller;
- (void)removeFavoriteMoveWithMoveID: (NSInteger) databaseID;
- (void)reorderFavoriteMoveFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;

- (UIBarButtonItem *) barButtonForAbilityWithAbilityID: (NSInteger) databaseID target: (id)target;
- (BOOL)toggleFavoriteAbilityWithAbilityID: (NSInteger) databaseID fromController: (UIViewController *)controller;
- (void)removeFavoriteAbilityWithAbilityID: (NSInteger) databaseID;
- (void)reorderFavoriteAbilityFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;

- (UIBarButtonItem *) barButtonForEggGroupWithEggGroupID: (NSInteger) databaseID target: (id)target;
- (BOOL)toggleFavoriteEggGroupWithEggGroupID: (NSInteger) databaseID fromController: (UIViewController *)controller;
- (void)removeFavoriteEggGroupWithEggGroupID: (NSInteger) databaseID;
- (void)reorderFavoriteEggGroupFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex;

@property (nonatomic, retain) NSMutableDictionary *favorites;

@property (nonatomic, retain) UIImage *favoritedOff;
@property (nonatomic, retain) UIImage *favoritedOn;

@property (nonatomic, assign) BOOL forceRefresh;

@end
