//
//  TCTableViewStatsSplitCell.m
//  iPokedex
//
//  Created by Timothy Oliver on 20/03/11.
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

#import "TCTableViewStatsSplitCell.h"
#import "TCQuartzFunctions.h"
#import "UIColor+CustomColors.h"

@implementation TCTableViewStatsSplitCell

@synthesize items, itemTitles, itemColor, itemDetailColor;

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        self.itemColor = [UIColor blackColor];
		self.itemDetailColor = [UIColor tableCellCaptionColor];
    }
    
    return self;
}

- (void)dealloc
{
    [items release];
	[itemTitles release];
    [itemColor release];
	[itemDetailColor release];
    
    [super dealloc];
}

-(void)drawInCellIndex: (NSInteger) index withRect: (CGRect)rect withContext:(CGContextRef)context
{
    CGRect textRect = CGRectInset(rect, 3, 5);
    textRect.size.height = 20;
    NSString *itemText = (NSString *)[items objectAtIndex: index];
    
    if( highlighted ) { [[UIColor whiteColor] set]; } else { [itemColor set]; }
    [itemText drawInRect: textRect 
                withFont: [UIFont boldSystemFontOfSize: 17.0f] 
           lineBreakMode: UILineBreakModeClip 
               alignment: UITextAlignmentCenter];
    
    textRect = CGRectInset(rect, 3, 5);
    textRect.origin.y = 24;
    textRect.size.height = 14;
    NSString *detailItemText = (NSString *)[itemTitles objectAtIndex: index];
    
    if( highlighted ) { [[UIColor whiteColor] set]; } else { [itemDetailColor set]; }
    [detailItemText drawInRect: textRect
                      withFont: [UIFont boldSystemFontOfSize: 12.0f]
                 lineBreakMode: UILineBreakModeClip 
                     alignment: UITextAlignmentCenter];

    if( self.tappedCell == index )
    {
        CGRect drawRect = CGRectInset(rect, 3, 5);
        UIColor *highlights = [UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.2f];
        TCDrawRoundedRect( context, drawRect, 4.0f, highlights );
    }
    
}

-(void)setItems:(NSArray *)newItems
{
    if( [newItems isEqual: items])
        return;
    
    [items release];
    items = [newItems retain];
    
    self.numberOfCells = [items count];
}

@end
