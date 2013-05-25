//
//  TechnicalMachineFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 9/03/11.
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

#import "TechnicalMachineFinder.h"
#import "GameVersions.h"

@implementation TechnicalMachineFinder

@synthesize moveID, generationID;

-(TechnicalMachineListEntry *)tmEntryFromDatabase
{
	NSString *query = [NSString stringWithFormat: @"SELECT * FROM machines \
													WHERE move_id = %d AND generation_id = %d \
											ORDER BY number ASC, exclusive_version_group_id ASC", self.moveID, self.generationID];
	
	FMResultSet *rs = [db executeQuery: query];
	if( rs == nil )
		return nil;
	
	NSMutableArray *entries = [[NSMutableArray alloc] init];
	while ( [rs next] )
	{
		TechnicalMachineListEntry *tm = [[TechnicalMachineListEntry alloc] initWithResultSet: rs];

		//check to merge 
		if( [self mergeExclusiveEntryWithList: entries entry: tm] == NO )
			[entries addObject: tm];
		
		[tm release];
	}
	
	if( [entries count] <= 0 )
	{
		[entries release];
		return nil;
	}   
	
	//at this point, we should only have ONE cell in the array
	//pull the first cell out
	TechnicalMachineListEntry *entry = [[entries objectAtIndex: 0] retain];
	[entries release];
	
	return [entry autorelease];
}

@end

@implementation TechnicalMachineListEntry

@synthesize isHiddenMachine, machineNumber, generationID, moveID;

- (id)initWithResultSet: (FMResultSet *)rs
{
	if( (self = [super init]) )
	{
		self.machineNumber = [rs intForColumn: @"number"];
		self.generationID = [rs intForColumn: @"generation_id"];
		self.isHiddenMachine = [[rs stringForColumn: @"type"] isEqualToString: @"hm"];
		self.moveID = [rs intForColumn: @"move_id"];
		
		//generate the name off the type and number
		self.name = [NSString stringWithFormat: @"%@%@%d", 
												(isHiddenMachine?NSLocalizedString(@"HM",nil):NSLocalizedString(@"TM",nil)), 
												(machineNumber < 10 ? @"0" : @""), 
												machineNumber];
	
		self.exclusiveVersionGroupID = [rs intForColumn: @"exclusive_version_group_id"];
	}
	
	return self;
}

@end