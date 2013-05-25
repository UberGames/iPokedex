//
//  Favorites.m
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

#import "Favorites.h"
#import "UIImage+ImageLoading.h"

@interface Favorites ()

-(void)removeFavoriteEntryWithKey: (NSString *)key databaseID: (NSInteger) dbID;
-(BOOL)resultForFavoriteEntryWithKey: (NSString *)key databaseID: (NSInteger)dbID;
-(BOOL)toggleFavoritesEntryWithKey: (NSString *)key databaseID: (NSInteger) dbID fromController: (UIViewController *)controller;
-(void)synchronizeFavorites;

@end

static Favorites *sharedFavorites = nil;

@implementation Favorites

@synthesize favorites, favoritedOff, favoritedOn, forceRefresh;

+ (Favorites *)sharedFavorites
{
    @synchronized(self)
    {
        if (sharedFavorites == nil)
			sharedFavorites = [[Favorites alloc] init];
    }
    
    return sharedFavorites;
}

- (id) init
{
    if ( sharedFavorites != nil ) {
        [NSException raise:NSInternalInconsistencyException
					format:@"[%@ %@] cannot be called; use +[%@ %@] instead"],
		NSStringFromClass([self class]), NSStringFromSelector(_cmd), 
		NSStringFromClass([self class]),
		NSStringFromSelector(@selector(sharedDex));
    } 
    else if( (self = [super init]) )
    {
        self.favorites = [NSMutableDictionary dictionaryWithDictionary: [[NSUserDefaults standardUserDefaults] objectForKey: USERDEFAULTS_FAVORITES]];
        if( favorites == nil )
        {
            self.favorites = [[[NSMutableDictionary alloc] init] autorelease];
            [[NSUserDefaults standardUserDefaults] setObject: favorites forKey: USERDEFAULTS_FAVORITES];
        }
        
        //load the images
        self.favoritedOff = [UIImage imageFromResourcePath: @"Images/Interface/Favorite.png"];
        self.favoritedOn = [UIImage imageFromResourcePath: @"Images/Interface/FavoriteOn.png"];
    }

    return self;
}

#pragma mark NSUserDefaults Interaction
-(void)synchronizeFavorites
{
    [[NSUserDefaults standardUserDefaults] setObject: self.favorites forKey: USERDEFAULTS_FAVORITES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Navigation Bar interface base classes
- (UIBarButtonItem *) barButtonForNavBarWithTarget: (id)target initialResult: (BOOL) on
{
    UIImage *image;
    if( on )
        image = favoritedOn;
    else
        image = favoritedOff;
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage: image style: UIBarButtonItemStylePlain target: target action: @selector( favoritesTapped: )];
    return [menuItem autorelease];
}

-(void) toggleFavoriteIconInBarButton: (UIBarButtonItem *)barItem withResult: (BOOL)on
{
    if( on )
        barItem.image = favoritedOn;
    else
        barItem.image = favoritedOff;
}

#pragma mark Favorite Data Methods Base Method
-(BOOL)resultForFavoriteEntryWithKey: (NSString *)key databaseID: (NSInteger)dbID
{
    NSMutableArray *favoriteEntries = [favorites objectForKey: key];
    if( favoriteEntries == nil )
        return NO;
    
    NSNumber *favoriteNumber = [NSNumber numberWithInt: dbID];
    
    return ([favoriteEntries indexOfObject: favoriteNumber] != NSNotFound);
}

-(BOOL)toggleFavoritesEntryWithKey: (NSString *)key databaseID: (NSInteger) dbID fromController: (UIViewController *)controller
{
   NSMutableArray *favoriteEntries = [NSMutableArray arrayWithArray: [favorites objectForKey: key]];
    
    //if this is the first time, create the array
    if( favoriteEntries == nil )
    {
        favoriteEntries = [NSMutableArray array];
        [favorites setObject: favoriteEntries forKey: key];
    }
    
    BOOL result = NO;
    NSNumber *favoriteNumber = [NSNumber numberWithInt: dbID];
    
    //check if it already exists
    if( [favoriteEntries indexOfObject: favoriteNumber] != NSNotFound )
    {
        //remove it from the array
        [favoriteEntries removeObject: favoriteNumber];
        result = NO;
    }
    else
    {
        //add it to the list
        [favoriteEntries addObject: favoriteNumber];
        result = YES;
    }
    
    //set refresh to on
    forceRefresh = YES;

    //re-add the results to favorites
    [favorites setObject: favoriteEntries forKey: key];
    
    //resync this to userdefaults
    [self synchronizeFavorites];
    
    return result;
}

-(void)reorderFavoriteEntryWithKey: (NSString *)key fromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
    NSMutableArray *favoriteEntries = [NSMutableArray arrayWithArray: [favorites objectForKey: key]];
    NSNumber *dbNumber = [[favoriteEntries objectAtIndex: fromIndex] retain];
    
    [favoriteEntries removeObjectAtIndex: fromIndex];
    [favoriteEntries insertObject: dbNumber atIndex: toIndex];
    
    [dbNumber release];
    
    //re-add the results to favorites
    [favorites setObject: favoriteEntries forKey: key];
    
    //resync this to userdefaults
    [self synchronizeFavorites];    
}

-(void)removeFavoriteEntryWithKey: (NSString *)key databaseID: (NSInteger) dbID
{
    NSMutableArray *favoriteEntries = [NSMutableArray arrayWithArray: [favorites objectForKey: key]];
    if( favoriteEntries == nil )
        return;
    
    NSNumber *favoriteNumber = [NSNumber numberWithInt: dbID];
    if( [favoriteEntries indexOfObject: favoriteNumber] != NSNotFound )
    {
        //remove it from the array
        [favoriteEntries removeObject: favoriteNumber];
    }
    
    [favorites setObject: favoriteEntries forKey: key];
    
    //resync this to userdefaults
    [self synchronizeFavorites];    
}

#pragma mark Force Refresh
- (BOOL) forceRefresh
{
    if( forceRefresh == YES )
    {
        forceRefresh = NO;
        return YES;
    }
    
    return NO;
}

#pragma mark Pokemon Specific
- (UIBarButtonItem *) barButtonForPokemonWithPokemonID: (NSInteger) databaseID target: (id)target
{
    BOOL result = [self resultForFavoriteEntryWithKey: FAVORITES_POKEMON databaseID: databaseID];
    return [self barButtonForNavBarWithTarget: target initialResult: result];
}

-(BOOL) toggleFavoritePokemonWithPokemonID: (NSInteger)databaseID fromController: (UIViewController *)controller
{
    return [self toggleFavoritesEntryWithKey: FAVORITES_POKEMON databaseID: databaseID fromController: controller];
}

- (void)removeFavoritePokemonWithPokemonID:(NSInteger)databaseID
{
    [self removeFavoriteEntryWithKey: FAVORITES_POKEMON databaseID: databaseID];
}

- (void)reorderFavoritePokemonFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
    [self reorderFavoriteEntryWithKey: FAVORITES_POKEMON fromIndex: fromIndex toIndex: toIndex];
}

#pragma mark Move Specific
- (UIBarButtonItem *) barButtonForMoveWithMoveID: (NSInteger) databaseID target: (id)target
{
    BOOL result = [self resultForFavoriteEntryWithKey: FAVORITES_MOVES databaseID: databaseID];
    return [self barButtonForNavBarWithTarget: target initialResult: result];
}

-(BOOL) toggleFavoriteMoveWithMoveID: (NSInteger)databaseID fromController: (UIViewController *)controller
{
    return [self toggleFavoritesEntryWithKey: FAVORITES_MOVES databaseID: databaseID fromController: controller];
}

- (void) removeFavoriteMoveWithMoveID:(NSInteger)databaseID
{
    [self removeFavoriteEntryWithKey: FAVORITES_MOVES databaseID: databaseID];
}

- (void)reorderFavoriteMoveFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
    [self reorderFavoriteEntryWithKey: FAVORITES_MOVES fromIndex: fromIndex toIndex: toIndex];
}

#pragma mark Abilities
- (UIBarButtonItem *) barButtonForAbilityWithAbilityID: (NSInteger) databaseID target: (id)target
{
    BOOL result = [self resultForFavoriteEntryWithKey: FAVORITES_ABILITIES databaseID: databaseID];
    return [self barButtonForNavBarWithTarget: target initialResult: result];    
}

-(BOOL) toggleFavoriteAbilityWithAbilityID: (NSInteger) databaseID fromController: (UIViewController *)controller;
{
   return [self toggleFavoritesEntryWithKey: FAVORITES_ABILITIES databaseID: databaseID fromController: controller];
}

- (void) removeFavoriteAbilityWithAbilityID:(NSInteger)databaseID
{
    [self removeFavoriteEntryWithKey: FAVORITES_ABILITIES databaseID: databaseID];
}

- (void)reorderFavoriteAbilityFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
    [self reorderFavoriteEntryWithKey: FAVORITES_ABILITIES fromIndex: fromIndex toIndex: toIndex];
}

#pragma mark Egg Groups
- (UIBarButtonItem *) barButtonForEggGroupWithEggGroupID: (NSInteger) databaseID target: (id)target
{
    BOOL result = [self resultForFavoriteEntryWithKey: FAVORITES_EGGGROUPS databaseID: databaseID];
    return [self barButtonForNavBarWithTarget: target initialResult: result];  
}

-(BOOL) toggleFavoriteEggGroupWithEggGroupID: (NSInteger) databaseID fromController: (UIViewController *)controller
{
   return [self toggleFavoritesEntryWithKey: FAVORITES_EGGGROUPS databaseID: databaseID fromController: controller]; 
}

- (void) removeFavoriteEggGroupWithEggGroupID:(NSInteger)databaseID
{
    [self removeFavoriteEntryWithKey: FAVORITES_EGGGROUPS databaseID: databaseID];
}

- (void)reorderFavoriteEggGroupFromIndex: (NSInteger)fromIndex toIndex: (NSInteger)toIndex
{
    [self reorderFavoriteEntryWithKey: FAVORITES_EGGGROUPS fromIndex: fromIndex toIndex: toIndex];
}

#pragma mark - Singleton Controls
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}


@end
