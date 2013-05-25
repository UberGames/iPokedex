//
//  PokemonTableCellContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 9/02/11.
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

#import "PokemonTableCellContentView.h"

@implementation PokemonTableCellContentView

@synthesize type1Image, 
			type2Image, 
			nDexNum,
			regionDexNum,
			dexNumValue;
                                     
-(void)dealloc
{
    [type1Image release];
    [type2Image release];
    [dexNumValue release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    CGRect drawRect;
	NSInteger x = self.bounds.size.width - POKEMON_DEXTYPES_WIDTH;
	NSInteger y = self.center.y - 7;
	
	//draw dex text
	if( highlighted )
		[[UIColor whiteColor] set];
	else 
		[[UIColor colorWithRed: 28.0f/255.0f green: 126.0f / 255.0f blue: 205.0f / 255.0f alpha: 1.0f ] set];
	
	[dexNumValue drawInRect: CGRectMake( x, y-2, 35, 25) withFont: [UIFont systemFontOfSize: 15.0f]];
	x += 41;
	
	//draw the type images
	if( type2Image != nil )
	{
		y = self.center.y-15;
		drawRect = CGRectMake( x, y, 32, 14);
		CGRect type2Frame = CGRectMake( x, y+16, 32, 14 );
		
		[type2Image drawInRect: type2Frame];
	}
	else 
	{
		drawRect = CGRectMake( x, y, 32, 14 );
	}
	[type1Image drawInRect: drawRect];
    
    self.titleWidth = self.bounds.size.width - (self.titleInset+POKEMON_DEXTYPES_WIDTH);

    [super drawRect: rect];
}



#pragma mark Highlighted override
- (void) setHighlighted:(BOOL)_highlighted
{
	highlighted = _highlighted;
}

- (BOOL) isHighlighted
{
	return highlighted;
}


@end
