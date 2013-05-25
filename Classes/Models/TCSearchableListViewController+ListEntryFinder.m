//
//  TCSearchableListController+ListEntryFinder.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/03/11.
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

#import "TCSearchableListViewController+ListEntryFinder.h"
#import "NSString+JapaneseScript.h"

@implementation TCSearchableListViewController (ListEntryFinder)

-(void) searchListWithString: (NSString *)searchString
{
    //determine whether we're searching using the current set language, or Japanese
    BOOL searchUsingAltName = NO;
    BOOL searchingWithJapanese = NO;
    
    if( LANGUAGE_IS_JAPANESE == YES )
    {
        searchUsingAltName = ([searchString isJapaneseScript] == NO );
        searchingWithJapanese = !searchUsingAltName;
    }
    else
    {
        searchUsingAltName = ([searchString isJapaneseScript] == YES );
        searchingWithJapanese = searchUsingAltName;
    }
    
    //if we're searching with Japanese, force 
    NSString *altSearchString = @"";
    if( searchingWithJapanese )
    {
        searchString = [searchString hiraganaScript];
        altSearchString = [searchString katakanaScript];
    }
    
    //let the sublcasses know the search was conducted in a non-English language
    self.searchWasWithLanguage = searchUsingAltName;

	if (tableSearchedEntries == nil )
		self.tableSearchedEntries = [NSMutableArray array];
	
	[tableSearchedEntries removeAllObjects];
	
	//loop through all of the entries
	for( ListEntry *item in tableEntries)
	{
		NSRange range, altRange=NSMakeRange(NSNotFound, -1);
		
		if( searchUsingAltName == NO )
        {
			range = [item.name rangeOfString: searchString options: NSCaseInsensitiveSearch ];
            
            if( searchingWithJapanese )
                altRange = [item.name rangeOfString: altSearchString options: NSCaseInsensitiveSearch ];
        }
		else 
        {
			range = [item.nameAlt rangeOfString: searchString options: NSCaseInsensitiveSearch ];
        
            if( searchingWithJapanese )
                altRange = [item.nameAlt rangeOfString: altSearchString options: NSCaseInsensitiveSearch ];
        }
        
		if ( range.location != NSNotFound || altRange.location != NSNotFound)
		{
			[tableSearchedEntries addObject: item];
		}
	}
}

@end
