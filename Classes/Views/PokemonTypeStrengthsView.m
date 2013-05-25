//
//  PokemonTypeStrengthsView.m
//  iPokedex
//
//  Created by Timothy Oliver on 25/01/11.
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

#import "PokemonTypeStrengthsView.h"
#import "ElementalTypes.h"
#import "ElementalTypesDamages.h"

#define DAMAGE_BOX_WIDTH 40
#define DAMAGE_BOX_HEIGHT 35

#define DAMAGE_COLOR_NONE [UIColor colorWithRed: 2.0f/255.0f green: 226.0f/255.0f blue: 23.0f/255.0f alpha: 1.0f]
#define DAMAGE_COLOR_QUARTER [UIColor colorWithRed: 24/255.0f green: 194.0f/255.0f blue: 19.0f/255.0f alpha: 1.0f]
#define DAMAGE_COLOR_HALF [UIColor colorWithRed: 1/255.0f green: 159/255.0f blue: 16.0f/255.0f alpha: 1.0f]
#define DAMAGE_COLOR_NORMAL [UIColor blackColor]
#define DAMAGE_COLOR_DOUBLE [UIColor colorWithRed: 207/255.0f green: 28/255.0f blue: 28/255.0f alpha: 1.0f];
#define DAMAGE_COLOR_QUADRUPLE [UIColor colorWithRed: 255.0f/255.0f green: 17/255.0f blue: 17/255.0f alpha: 1.0f]

#define DAMAGE_SIZE_NONE 20
#define DAMAGE_SIZE_QUARTER 20
#define DAMAGE_SIZE_HALF 20
#define	DAMAGE_SIZE_NORMAL 20
#define DAMAGE_SIZE_DOUBLE 20
#define DAMAGE_SIZE_QUADRUPLE 20

@interface PokemonTypeStrengthsView ()

- (NSString *) multiplierStringForDamagePercentile: (NSInteger)damagePercentile;
- (UIColor *) multiplierColorForDamagePercentile: (NSInteger)damagePercentile;
- (NSInteger) multiplierSizeForDamagePercentile: (NSInteger)damagePercentile;

@end

@implementation PokemonTypeStrengthsView

@synthesize types, typeDamages;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.minWidthPadding = 3;
		self.heightPadding = 15;
		self.itemWidth = DAMAGE_BOX_WIDTH;
		self.itemHeight = DAMAGE_BOX_HEIGHT;
		self.contentStretch = CGRectMake(1.0f, 0, 1.0f, 1.0f);
    }
    return self;
}

-(void) setTypes:(NSDictionary *)_types
{
	if( types == _types )
		return;
	
	[types release];
	types = [_types retain];
	
	//once we have the number of items, calculate the number that can be placed on each row
	self.numberOfItems = [types count];
}

- (NSString *) multiplierStringForDamagePercentile: (NSInteger)damagePercentile
{
	switch (damagePercentile) {
		case 0:
			return @"0x";
		case 25:
			return @"¼x";
		case 50:
			return @"½x";
		case 100:
			return @"1x";
		case 200:
			return @"2x";
		case 400:
			return @"4x";
		default:
			return @"Null";
	}
	
	return @"Null";
}

- (UIColor *) multiplierColorForDamagePercentile: (NSInteger)damagePercentile
{
	switch (damagePercentile) {
		case 0:
			return DAMAGE_COLOR_NONE;
		case 25:
			return DAMAGE_COLOR_QUARTER;
		case 50:
			return DAMAGE_COLOR_HALF;
		case 100:
			return DAMAGE_COLOR_NORMAL;
		case 200:
			return DAMAGE_COLOR_DOUBLE;
		case 400:
			return DAMAGE_COLOR_QUADRUPLE;
		default:
			return [UIColor blackColor];
	}
	
	return [UIColor blackColor];
}

- (NSInteger) multiplierSizeForDamagePercentile: (NSInteger)damagePercentile
{
	switch (damagePercentile) {
		case 0:
			return DAMAGE_SIZE_NONE;
		case 25:
			return DAMAGE_SIZE_QUARTER;
		case 50:
			return DAMAGE_SIZE_HALF;
		case 100:
			return DAMAGE_SIZE_NORMAL;
		case 200:
			return DAMAGE_SIZE_DOUBLE;
		case 400:
			return DAMAGE_SIZE_QUADRUPLE;
		default:
			return DAMAGE_SIZE_NORMAL;
	}
	
	return DAMAGE_SIZE_NORMAL;
}

-(void) drawInItemRect:(CGRect)rect forIndex:(NSInteger)index withContext:(CGContextRef)context
{
	ElementalType *type = [types objectForKey: [NSNumber numberWithInt: index]];
	ElementalTypesDamage *typeDamage = [typeDamages objectForKey: [NSNumber numberWithInt: index]];
	
	//draw the image
	CGRect iconFrame = CGRectMake( 0, 0, TYPE_ICON_WIDTH, TYPE_ICON_HEIGHT);
	iconFrame.origin.x = rect.origin.x + ((DAMAGE_BOX_WIDTH / 2) - (TYPE_ICON_WIDTH / 2));
	iconFrame.origin.y = rect.origin.y + (DAMAGE_BOX_HEIGHT - TYPE_ICON_HEIGHT);
	[type.icon drawInRect: iconFrame];
	
	//draw the text
	UIColor *textColor = (UIColor *)[self multiplierColorForDamagePercentile: typeDamage.damagePercentile];
	UIFont *textFont = [UIFont boldSystemFontOfSize: [self multiplierSizeForDamagePercentile: typeDamage.damagePercentile]];
	NSString *textString = [self multiplierStringForDamagePercentile: typeDamage.damagePercentile];
	
	CGSize textSize = [textString sizeWithFont: textFont];
	CGRect textFrame = CGRectMake( 0, 0, DAMAGE_BOX_WIDTH, DAMAGE_BOX_HEIGHT-16 );
	textFrame.origin.x = rect.origin.x;
	textFrame.origin.y = rect.origin.y + ((DAMAGE_BOX_HEIGHT - (TYPE_ICON_HEIGHT)) - textSize.height);
	textFrame.size.height = textSize.height;
	
    [[UIColor colorWithWhite: 0.0f alpha: 0.2f] set];
    [textString drawInRect: CGRectOffset(textFrame, 1.0f, 1.0f) withFont: textFont lineBreakMode: UILineBreakModeClip	alignment: UITextAlignmentCenter];
    [textColor set];
	[textString drawInRect: textFrame withFont: textFont lineBreakMode: UILineBreakModeClip	alignment: UITextAlignmentCenter];
}

- (void)dealloc {
	[types release];
	[typeDamages release];
    [super dealloc];
}


@end
