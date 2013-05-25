//
//  RootViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 16/11/10.
//  Copyright 2010 UberGames. All rights reserved.
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

#import "PokemonListViewController.h"
//#import "ItemListViewController.h"
#import "AbilityListViewController.h"
#import "MoveListViewController.h"
#import "FavoritesListViewController.h"
#import "EggGroupsListViewController.h"
#import "SettingsViewController.h"

@interface RootViewTabBarController : TCTabBarController <UINavigationBarDelegate, UITabBarDelegate, TCTabBarControllerDelegate> {
    PokemonListViewController   *pokemonViewController;
    AbilityListViewController   *abilityViewController;
    MoveListViewController      *moveViewController;
    FavoritesListViewController *favoritesViewController;
    EggGroupsListViewController *eggGroupsViewController;
    SettingsViewController      *settingsViewController;
}

@end
