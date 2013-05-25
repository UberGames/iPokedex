//
//  TCListViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 9/12/10.
//  Copyright 2010 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCListViewController.h"

@interface TCRefinableListViewController : TCListViewController <UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate> 
{	
	//sorting view elements
	BOOL isSortable;
	NSArray *sortTitles;
	NSMutableDictionary *sortRows; //the current rows
	NSMutableDictionary *sortSavedRows;  //saved so the wheel can be restored next time
}

-(void) performFilter;
-(void) setSortIndex: (NSInteger)index forRow: (NSInteger) row;

@property (nonatomic, assign) BOOL isSortable;
@property (nonatomic, retain) NSArray *sortTitles;
@property (nonatomic, retain) NSMutableDictionary *sortRows;
@property (nonatomic, retain) NSMutableDictionary *sortSavedRows;

@end
