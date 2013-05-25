//
//  Versions.h
//  iPokedex
//
//  Created by Timothy Oliver on 17/02/11.
//  Copyright 2011 UberGames. All rights reserved.
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
#import "Bulbadex.h"
#import "DatabaseEntries.h"
#import "UIColor+HexString.h"

@interface GameVersion : DatabaseEntry
{
	NSInteger generation;			//Generation of this game (1,2,3,4,5)
	NSInteger releaseGrouping;		//If this game was released with another one (eg, Red and Blue are both '1')
	NSInteger regionGrouping;		//Which versions are set in the same region
	
	UIColor	*color;					//Color of the version (To be rendered on a white BG)
	
	NSString *acronym;				//Acronym (eg Red = R, HeartGold = HG)
}

-(id) initWithResultSet: (FMResultSet *)results;

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) NSInteger releaseGrouping;
@property (nonatomic, assign) NSInteger regionGrouping;
@property (nonatomic, retain) UIColor	*color;
@property (nonatomic, copy) NSString *acronym;

@end

@interface GameVersions : DatabaseEntries {
	
}

+ (NSDictionary *) gameVersionsFromDatabase;
+ (GameVersion *) gameVersionWithDatabaseID: (NSInteger) databaseID;
+ (NSArray *) gameVersionsWithExclusiveGroupID: (NSInteger) groupID;
+ (NSDictionary *) gameVersionsByGroupingFromDatabase;

@end