//
//  AboutTableArtists.m
//  iPokedex
//
//  Created by Timothy Oliver on 26/04/11.
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

#import "AboutTableArtists.h"


@implementation AboutTableArtists

@synthesize names, artPieces, highlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
        self.contentStretch = CGRectMake( 0.99f, 0.0f, 0.01f, 1.0f);
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    NSInteger columnWidth = (self.frame.size.width / [names count])-10;
    CGPoint drawPoint = CGPointZero;
    
    for( NSInteger i = 0; i < [names count]; i++ )
    {
        drawPoint.x = columnWidth * i;
        drawPoint.y = 0;
        
        //draw the names
        NSString *name = [names objectAtIndex: i];
        UIFont *font = [UIFont boldSystemFontOfSize: 16.0f];
        
        if( highlighted )
            [[UIColor whiteColor] set];
        else
            [[UIColor blackColor] set];
        
        [name drawAtPoint: drawPoint withFont: font];
        
        //draw the texts underneath
        NSInteger lineGap = 0;
        drawPoint.y = 18.0f + lineGap;
        
        NSArray *artPiece = [artPieces objectAtIndex: i];
        font = [UIFont systemFontOfSize: 14.0f];
        
        for( NSString *piece in artPiece )
        {
            [piece drawAtPoint: drawPoint withFont: font];
            drawPoint.y += 18.0f + lineGap;
        }
    }
}

-(NSInteger) frameHeight
{
    return 60;
}

#pragma mark Highlighted override
- (void) setHighlighted:(BOOL)_highlighted
{
	highlighted = _highlighted;
    [self setNeedsDisplay];
}

- (BOOL) isHighlighted
{
	return highlighted;
}

- (void)dealloc
{
    [names release];
    [artPieces release];
    [super dealloc];
}

@end
