//
//  Bulbadex.m
//  iPokedex
//
//  Created by Timothy Oliver on 26/11/10.
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

#import "Bulbadex.h"

static Bulbadex *sharedDex = nil;

@implementation Bulbadex

@synthesize db;

#pragma mark -
#pragma mark class instance methods

#pragma mark -
#pragma mark Singleton methods

+ (Bulbadex*)sharedDex
{
    @synchronized(self)
    {
        if (sharedDex == nil)
			sharedDex = [[Bulbadex alloc] init];
    }
    return sharedDex;
}

- (id)init
{
    if ( sharedDex != nil ) {
        [NSException raise:NSInternalInconsistencyException
					format:@"[%@ %@] cannot be called; use +[%@ %@] instead"],
		NSStringFromClass([self class]), NSStringFromSelector(_cmd), 
		NSStringFromClass([self class]),
		NSStringFromSelector(@selector(sharedDex));
	 } 
	else if ( (self = [super init]) ) 
	{
		sharedDex = self;
		 
		//get location of database file
		NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"ipokedex.sqlite" ];
		if( [[NSFileManager defaultManager] fileExistsAtPath: dbPath] == NO )
		{
		 [NSException raise: @"Database was not found!" format: @"File missing." ];
		 return NO;
		}
		 
		//load the database file
		db = [[FMDatabase alloc] initWithPath: dbPath ];
		//open it
		if( ![db open] )
		{
			[NSException raise: @"Could not open database file!" format: @"File invalid." ];
			return NO;
		}		
	}
	
	return sharedDex;
}
							 
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}

@end
