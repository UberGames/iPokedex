//
//  TCTabBarController+MoreMenuEntry.m
//  iPokedex
//
//  Created by Timothy Oliver on 22/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCTabBarController+MoreMenuEntry.h"
#import "UIImage+GenerateHighlightedImage.h"

@implementation TCMoreMenuEntry

@synthesize tabBarItem, highlightedImage;

- (id)initWithTabBarItem: (UITabBarItem *)barItem
{
    if( (self = [super init]) )
    {
        self.tabBarItem = barItem;
    }
    
    return self;
}

+ (TCMoreMenuEntry *)moreMenuEntryWithItem: (UITabBarItem *)barItem
{
    return [[[TCMoreMenuEntry alloc] initWithTabBarItem: barItem] autorelease];
}

- (void)setTabBarItem:(UITabBarItem *)_tabBarItem
{
    if( _tabBarItem == tabBarItem )
        return;
    
    [tabBarItem release];
    tabBarItem = [_tabBarItem retain];
    
    //generate the highlighted image
    highlightedImage = [[UIImage highlightedImageWithImage: tabBarItem.image] retain];
}

- (void)dealloc
{
    [tabBarItem release];
    [highlightedImage release];
    
    [super dealloc];
}

@end
