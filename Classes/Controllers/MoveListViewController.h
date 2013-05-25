//
//  MoveListViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 28/12/10.
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
#import "TCSearchableListViewController.h"
#import "TCSearchableListViewController+ListEntryFinder.h"
#import "MoveEntryFinder.h"

typedef enum 
{
	MoveEntryCaptionNone=0,
	MoveEntryCaptionLanguageName
} MoveEntryCaption;

@interface MoveListViewController : TCSearchableListViewController {
	MoveEntryFinder *moveFinder;

	NSDictionary *elementalTypes;
	NSDictionary *generations;
	NSDictionary *moveCategories;
	
	//sort Parameters
	NSArray *sortOrder;
	
	MoveEntryCaption searchEntryCaption;
	MoveEntryCaption entryCaption;
}

@property (nonatomic, retain) MoveEntryFinder *moveFinder;
@property (nonatomic, retain) NSDictionary *elementalTypes;
@property (nonatomic, retain) NSDictionary *generations;
@property (nonatomic, retain) NSDictionary *moveCategories;
@property (nonatomic, retain) NSArray *sortOrder;
@property (nonatomic, assign) MoveEntryCaption searchEntryCaption;
@property (nonatomic, assign) MoveEntryCaption entryCaption;

@end
