//
//  AboutTableThanksView.m
//  iPokedex
//
//  Created by Timothy Oliver on 27/03/11.
//  Copyright 2011 UberGames. All rights reserved.
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

#import "AboutTableThanksView.h"


@implementation AboutTableThanksView

@synthesize names;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemsPerLine = 2;
        self.itemWidth = 95;
        self.itemHeight = 20;
    }
    return self;
}

-(void) drawInItemRect: (CGRect)rect forIndex: (NSInteger) index withContext: (CGContextRef) context
{
    NSString *name = [names objectAtIndex: index-1];
    UIFont *font = [UIFont boldSystemFontOfSize: 16.0f];
    
    if( highlighted )
        [[UIColor whiteColor] set];
    else
        [[UIColor blackColor] set];
    
    [name drawInRect: rect withFont: font];
}

- (void)setNames:(NSArray *)_names
{
    if( _names == names )
        return;
    
    [names release];
    names = [_names retain];
    
    self.numberOfItems = [names count];
}

- (void)dealloc
{
    [names release];
    [super dealloc];
}

@end
