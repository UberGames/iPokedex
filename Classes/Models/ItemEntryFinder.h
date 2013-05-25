//
//  ItemEntryFinder.h
//  iPokedex
//
//  Created by Timothy Oliver on 21/12/10.
//  Copyright 2010 UberGames. All rights reserved.
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
#import "EntryFinder.h"
#import "Bulbadex.h"

typedef enum 
{
	ItemFinderSortByType=0,
	ItemFinderSortByName
} ItemFinderSort;

@interface ItemEntryFinder : EntryFinder {
	ItemFinderSort sortedOrder;
	NSInteger generationId;
	NSInteger typeID;
}

-(NSArray *) generateSectionListWithList: (NSArray *)list;
-(NSArray *) generateSectionTitlesWithList: (NSArray *)list;

@property (nonatomic, assign) ItemFinderSort sortedOrder;
@property (nonatomic, assign) NSInteger generationID;
@property (nonatomic, assign) NSInteger typeID;

@end

@interface ItemListEntry : ListEntry {
	NSString *shortName;
	NSInteger typeID;
	
	NSInteger sellPrice;
	BOOL buyable;
	
	UIImage *icon;
}

-(void) loadIcon;

@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, assign) NSInteger sellPrice;
@property (nonatomic, assign) BOOL buyable;
@property (nonatomic, retain) UIImage *icon;

@end