//
//  MoveProfileTabController.h
//  iPokedex
//
//  Created by Tim Oliver on 28/02/11.
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

#import <UIKit/UIKit.h>
#import "TCTabBarController.h"

#import "MoveProfileMainViewController.h"
#import "MoveProfilePokemonViewController.h"

#import "MoveEntryFinder.h"
#import "UIImage+ImageLoading.h"
#import "GANTracker.h"

@interface MoveProfileTabController : TCTabBarController <TCTabBarControllerDelegate> {
	NSInteger dbID;
    NSString *webTitle;
    
    MoveProfileMainViewController *mainViewController;
    MoveProfilePokemonViewController *pokemonViewController;
}

- (id) initWithDatabaseID: (NSInteger) databaseID moveEntry: (MoveListEntry *)move;

@property (nonatomic, assign) NSInteger dbID;
@property (nonatomic, retain) NSString *webTitle;

@end
