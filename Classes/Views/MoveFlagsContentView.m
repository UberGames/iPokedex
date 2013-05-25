//
//  MoveFlagsContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 2/03/11.
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

#import "MoveFlagsContentView.h"

#define POKEMON_FLAGS_NUMITEMS 6

#define POKEMON_FLAGS_FONTSIZE 15
#define POKEMON_FLAGS_LINE_SPACING 8

#define POKEMON_FLAGS_COLUMN_WIDTH 205

#define POKEMON_FLAGS_MAKESCONTACT NSLocalizedString( @"Makes contact", @"Makes Contact" )
#define POKEMON_FLAGS_DOESNTMAKECONTACT NSLocalizedString( @"Doesn't make contact", @"Makes Contact" )
#define POKEMON_FLAGS_AFFECTEDBY NSLocalizedString( @"Affected by %@", @"Makes Contact" )
#define POKEMON_FLAGS_NOTAFFECTEDBY NSLocalizedString( @"Not affected by %@", @"Makes Contact" )

@interface MoveFlagsContentView ()

- (void)rebuildStrings;

@end


@implementation MoveFlagsContentView

@synthesize flags, flagStrings, flagValues;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentStretch = CGRectZero;
    }
    return self;
}

-(NSInteger) height
{
	//derive height based on the number of columns we can fit
	NSInteger numColumns = (NSInteger)floor( self.bounds.size.width / POKEMON_FLAGS_COLUMN_WIDTH  );
	return (ceil((CGFloat)[flagStrings count]/(CGFloat)numColumns) * (POKEMON_FLAGS_FONTSIZE + POKEMON_FLAGS_LINE_SPACING));
}

-(void) setFlags: (MoveFlagsStruct) newFlags
{	
	flags = newFlags;
	[self rebuildStrings];
}

- (void)drawRect:(CGRect)rect {
	UIFont *font;
	CGPoint drawPoint = CGPointMake( 0, 0);
	NSInteger boxSize = 6;
	NSInteger numColumns = (NSInteger)floor( self.bounds.size.width / POKEMON_FLAGS_COLUMN_WIDTH  );
	NSInteger numPerColumn = ceil(POKEMON_FLAGS_NUMITEMS/numColumns);
	
	//CG
	UIColor *boxColor = [UIColor colorWithRed: 115.0f/255.0f green: 129.0f/255.0f blue: 139.0f/255.0f alpha: 1.0f];
	CGContextRef context = UIGraphicsGetCurrentContext();
						 
	for( NSInteger i = 0; i < [flagStrings count]; i++ )
	{
		NSString *drawString = [flagStrings objectAtIndex: i];
		NSInteger allowed = [[flagValues objectAtIndex: i] boolValue];
		
		if( allowed ) {
			font = [UIFont boldSystemFontOfSize: POKEMON_FLAGS_FONTSIZE];
		}
		else {
			font = [UIFont systemFontOfSize: POKEMON_FLAGS_FONTSIZE];
		}

		//draw the point box
		CGContextSetFillColorWithColor( context,  boxColor.CGColor);
		CGContextFillRect( context, CGRectMake( drawPoint.x, drawPoint.y + 7, boxSize, boxSize) );
		
		//draw the text
		[[UIColor blackColor] set];		
		[drawString drawAtPoint: CGPointMake( drawPoint.x + boxSize + 7, drawPoint.y) withFont: font];
		
		if( numColumns > 1 && ((i+1)%numPerColumn) == 0 )
		{
			drawPoint.y = 0;
			drawPoint.x += POKEMON_FLAGS_COLUMN_WIDTH+10;
		}
		else
			drawPoint.y += POKEMON_FLAGS_FONTSIZE + POKEMON_FLAGS_LINE_SPACING;
	}
}

-(void)rebuildStrings
{
	//clean out the old entries
	if( flagStrings )
		self.flagStrings = nil;
	
	if( flagValues )
		self.flagValues = nil;
	
	//set up the new entries
	NSMutableArray *strings = [[NSMutableArray alloc] init];
	NSMutableArray *values = [[NSMutableArray alloc] init];
	
	//add each one manually
	
	//Makes Contact
    if ( flags.makesContact >= 0 )
    {
        if( flags.makesContact )
        {
            [strings addObject: POKEMON_FLAGS_MAKESCONTACT];
            [values addObject: [NSNumber numberWithBool: YES]];
        }
        else 
        {
            [strings addObject: POKEMON_FLAGS_DOESNTMAKECONTACT];
            [values addObject: [NSNumber numberWithBool: NO]];
        }
    }

	//Affected by Protect
	if( flags.affectedByProtect >= 0 )
    {
        if( flags.affectedByProtect )
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_AFFECTEDBY, NSLocalizedString( @"Protect", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: YES]];
        }
        else 
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_NOTAFFECTEDBY, NSLocalizedString( @"Protect", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: NO]];
        }
    }
	
    //Affected by Magic Coat
    if( flags.affectedByMagicCoat >= 0 )
    {
        if( flags.affectedByMagicCoat )
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_AFFECTEDBY, NSLocalizedString( @"Magic Coat", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: YES]];
        }
        else 
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_NOTAFFECTEDBY, NSLocalizedString( @"Magic Coat", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: NO]];
        }
    }
		 
    //Affected by Snatch
    if( flags.affectedBySnatch >= 0 )
    {
        if( flags.affectedBySnatch )
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_AFFECTEDBY, NSLocalizedString( @"Snatch", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: YES]];
        }
        else 
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_NOTAFFECTEDBY, NSLocalizedString( @"Snatch", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: NO]];
        }
    }
	
	//Affected by BrightPowder
    if( flags.affectedByBrightPowder >= 0 )
    {
        if( flags.affectedByBrightPowder )
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_AFFECTEDBY, NSLocalizedString( @"Bright Powder", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: YES]];
        }
        else 
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_NOTAFFECTEDBY, NSLocalizedString( @"Bright Powder", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: NO]];
        }
    }
	
	//Affected by King's Rock
    if( flags.affectedByKingsRock >= 0 )
    {
        if( flags.affectedByKingsRock )
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_AFFECTEDBY, NSLocalizedString( @"King's Rock", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: YES]];
        }
        else 
        {
            [strings addObject: [NSString stringWithFormat: POKEMON_FLAGS_NOTAFFECTEDBY, NSLocalizedString( @"King's Rock", @"Move Flags")]];
            [values addObject: [NSNumber numberWithBool: NO]];
        }
    }
	
	//add the strings back into the class
	self.flagStrings = strings;
	self.flagValues = values;
	
	[strings release];
	[values release];
}

- (void)dealloc {
	[flagStrings release];
	[flagValues release];
	
    [super dealloc];
}


@end
