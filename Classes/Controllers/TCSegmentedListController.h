//
//  TCSegmentedListController.h
//  iPokedex
//
//  Created by Timothy Oliver on 6/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRefinableListViewController.h"

@interface TCSegmentedListController : TCRefinableListViewController <UIScrollViewDelegate> {
	NSArray *segmentedButtonTitles;
	NSArray *segmentedDisabledButtons;
	NSInteger selectedIndex;
	
	UISegmentedControl *segmentedSelectorView;
	UINavigationBar *selectorNavBar;
	
    NSString *segmentedSortTitle;
}

-(void) selectedIndexChanged;
-(void) setSelectedIndex:(NSInteger)_newIndex withReload: (BOOL)reload;
-(NSInteger) firstEnabledSelectedIndex;

@property (nonatomic, retain) NSArray *segmentedButtonTitles; 
@property (nonatomic, retain) NSArray *segmentedDisabledButtons;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) UISegmentedControl *segmentedSelectorView;
@property (nonatomic, retain) UINavigationBar *selectorNavBar;
@property (nonatomic, retain) NSString *segmentedSortTitle;

@end
