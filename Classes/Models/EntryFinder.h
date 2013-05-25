//
//  EntryFinder.h
//  iPokedex
//
//  Created by Timothy Oliver on 9/12/10.
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
#import "FMDatabase.h"

@interface ListEntry : NSObject {
	NSInteger dbID;
	NSString *name;
	NSString *nameAlt;
	
	NSString *webName;
	NSString *caption;
	
	NSInteger level;
	NSInteger exclusiveVersionGroupID;
	
    NSMutableArray *versionGroupIDNumbers;
	NSMutableArray *versionStrings;
	NSMutableArray *versionColors;
    
    NSIndexPath *indexPath;
}

- (void) loadIcon;
- (void)unloadIcon;

- (id) initWithDatabaseID: (NSInteger) _id;
- (id)initWithResultSet: (FMResultSet *)rs;

@property (nonatomic, assign) NSInteger dbID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nameAlt;
@property (nonatomic, readonly) NSString *webName;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain)  NSMutableArray *versionGroupIDNumbers;
@property (nonatomic, retain) NSMutableArray *versionStrings;
@property (nonatomic, retain) NSMutableArray *versionColors;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger exclusiveVersionGroupID;
@property (nonatomic, retain) NSIndexPath *indexPath;

@end

@interface EntryFinder : NSObject {
	FMDatabase *db;
	
	NSDictionary *gameVersionGroups;
    NSArray *gameVersionIgnoredCaptions;
}

- (NSMutableArray *) entriesFromDatabase;

- (void) reset;


+ (NSDictionary *) alphabeticalSectionEntryListWithEntries: (NSArray *)entries;

+ (NSArray *) alphabeticalSectionHeaderTitleListWithDictionary: (NSDictionary *)entries;
+ (NSArray *) alphabeticalSectionHeaderEntryListWithDictionary: (NSDictionary *)dict titleList: (NSArray *)titleList;

+ (NSArray *) alphabeticalSectionIndexTitleListWithSectionHeaderTitleList: (NSArray *)titles search: (BOOL) search;

- (BOOL) mergeExclusiveEntryWithList: (NSArray *)entries entry: (ListEntry *)entry;

@property (nonatomic, retain) FMDatabase *db;
@property (nonatomic, retain) NSDictionary *gameVersionGroups;
@property (nonatomic, retain) NSArray *gameVersionIgnoredCaptions;

@end

