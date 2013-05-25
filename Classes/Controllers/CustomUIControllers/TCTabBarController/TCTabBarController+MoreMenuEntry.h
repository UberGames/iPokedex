//
//  TCMoreMenuEntry.h
//  iPokedex
//
//  Created by Timothy Oliver on 22/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCMoreMenuEntry : NSObject {
    UITabBarItem *tabBarItem;
    UIImage *highlightedImage;
}

- (id)initWithTabBarItem: (UITabBarItem *)barItem;
+ (TCMoreMenuEntry *)moreMenuEntryWithItem: (UITabBarItem *)barItem;

@property (nonatomic, retain) UITabBarItem *tabBarItem;
@property (nonatomic, readonly) UIImage *highlightedImage;

@end
