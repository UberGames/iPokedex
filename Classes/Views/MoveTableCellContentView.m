//
//  MoveTableCellContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 15/02/11.
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

#import "MoveTableCellContentView.h"

#define MOVE_STATS_WIDTH 105

@implementation MoveTableCellContentView

@synthesize typeImage,
			categoryImage,
			typeID,
			categoryID,
			power,
			powerTitle,
			powerValue,
			accuracy,
			accuracyTitle,
			accuracyValue,
			PP,
			PPTitle,
			PPValue;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.titleSize = 19;
		self.titleInset = 48;
		
		//init the titles
		self.powerTitle		= NSLocalizedString( @"PWR", @"Power" );
		self.accuracyTitle	= NSLocalizedString( @"ACC", @"Accuracy" );
		self.PPTitle		= NSLocalizedString( @"PP", @"PP" );
        
        /*
         self.powerTitle	= @"PWR";
		 self.accuracyTitle	= @"ACC";
		 self.PPTitle		= @"PP";
        */

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGRect drawRect;
	UIFont *font;
	
	//draw the elemental type icon
	drawRect = CGRectMake( 10, 6, 32, 14 );
	[typeImage drawInRect: drawRect ];
	
	//draw the move category icon
	drawRect = CGRectMake( 10, 22, 32, 14 );
	[categoryImage drawInRect: drawRect ];
	
	//draw the move titles text
	if( highlighted )
		[[UIColor whiteColor] set];
	else
		[[UIColor colorWithRed: 34.0f/255.0f green: 118.0f/255.0f blue: 205.0f/255.0f alpha: 1.0f] set];
	
	font = [UIFont boldSystemFontOfSize: 12.0f];
	
	//PWR Title
	drawRect = CGRectMake( self.bounds.size.width - MOVE_STATS_WIDTH, 6, 38, 13 );
	[powerTitle drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter ];

	//ACC title
	drawRect.origin.x += 35;
	drawRect.size.width = 44;
	[accuracyTitle drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter ];
	
	//PP Title
	drawRect.origin.x += 45;
	drawRect.size.width = 23;
	[PPTitle drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter ];
	
	//Draw the move Values
	if( highlighted )
		[[UIColor whiteColor] set];
	else	
		[[UIColor blackColor] set];
	
	font = [UIFont systemFontOfSize: 15.0f];
	
	//PWR
	drawRect = CGRectMake( self.bounds.size.width - MOVE_STATS_WIDTH, 19, 38, 14 );
	[powerValue drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter ];
	
	//ACC
	drawRect.origin.x += 35;
	drawRect.size.width = 44;
	[accuracyValue drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter ];
	
	//PP
	drawRect.origin.x += 45;
	drawRect.size.width = 23;
	[PPValue drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter ];
	
	//draw the main title text
	self.titleWidth = self.bounds.size.width - (self.titleInset+MOVE_STATS_WIDTH);
	[super drawRect: rect];
}

- (void)dealloc {
	[typeImage release];
	[categoryImage release];
	[powerTitle release];
	[powerValue release];
	[accuracyTitle release];
	[accuracyValue release];
	[PPTitle release];
	[PPValue release];
	
    [super dealloc];
}


@end
