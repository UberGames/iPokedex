//
//  PokemonPokedexTextView.m
//  iPokedex
//
//  Created by Timothy Oliver on 17/02/11.
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

#import "PokemonPokedexTextView.h"

@implementation PokemonPokedexTextView

@synthesize versionNames, versionColors;

- (id)initWithFrame:(CGRect)frame
{
	if( (self = [super initWithFrame: frame]) )
	{
		self.fontSize   = POKEDEX_FONT_SIZE;
		self.yOffset    = POKEDEX_GAMELABELS_HEIGHT;
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGSize textSize;
	UIFont *font = [UIFont boldSystemFontOfSize: POKEDEX_TITLE_FONT_SIZE];
	
	NSInteger x = 0;
	for( NSInteger i = 0; i < [versionNames count]; i++ )
	{	
		NSString *versionName = [versionNames objectAtIndex: i];
		UIColor *versionColor = [versionColors objectAtIndex: i];
		
		//append a comma if there is more than 1 entry
		if( i < [versionNames count]-1)
			versionName = [versionName stringByAppendingString: @", "];
		
		[versionColor set];
		[versionName drawAtPoint: CGPointMake( x, 0) withFont: font];
		
		//get ready for the next point
		textSize = [versionName sizeWithFont: font];
		x += textSize.width;
	}
	
	[super drawRect: rect];
}

+ (CGFloat) cellHeightWithWidth: (CGFloat)width text: (NSString *)text
{
	return [super cellHeightWithWidth: width text: text fontSize: POKEDEX_FONT_SIZE ] + POKEDEX_GAMELABELS_HEIGHT;
}

- (void)dealloc {
	[versionNames release];
	[versionColors release];
	
    [super dealloc];
}


@end
