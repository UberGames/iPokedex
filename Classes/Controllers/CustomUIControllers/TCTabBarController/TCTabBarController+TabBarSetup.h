//
//  TCTabBarController+ManualAccessors.h
//  iPokedex
//
//  Created by Timothy Oliver on 21/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCTabBarController (TabBarSetup)

- (BOOL)populateTabBarFromDefaultList;
- (BOOL)populateTabBarFromSavedList;
- (void)initMoreTabBarItem;
- (void)buildMoreItemList;
- (void)saveTabBarOrderToFileWithList: (NSArray *)tabOrder;
- (void)reinitTabBarItemWithController: (UIViewController *)controller;
- (UIViewController *)viewControllerForTabBarItem: (UITabBarItem *)item;

@end
