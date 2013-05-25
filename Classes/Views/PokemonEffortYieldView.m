//
//  PokemonEffortYieldView.m
//  iPokedex
//
//  Created by Timothy Oliver on 16/01/11.
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

#import "PokemonEffortYieldView.h"
#import "TCQuartzFunctions.h"
#import "UIImage+ImageLoading.h"
#import "UIColor+CustomColors.h"

#define CELL_HP		0
#define CELL_ATK	1
#define CELL_DEF	2
#define CELL_SPATK	3
#define CELL_SPDEF	4
#define CELL_SPEED	5

#define EV_NUM_CELLS	6

#define EV_X_SPACING	4
#define EV_Y_SPACING	7
#define EV_BOX_HEIGHT	44

@interface PokemonEffortYieldView ()

-(UIColor *)boxColorForCellIndex: (NSInteger) index;
-(UIColor *)boxStrokeColorForCellIndex: (NSInteger) index;

@end

@implementation PokemonEffortYieldView

@synthesize hp, atk, def, spAtk, spDef, speed;
@synthesize hpImage, atkImage, defImage, spAtkImage, spDefImage, speedImage;
@synthesize	valueStrings;
@synthesize titleTexts, titleImages;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
		//set up view properties
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
        
        //init images
        self.hpImage = [[UIImage imageFromResourcePath: @"Images/Interface/EVYieldHP.png"] stretchableImageWithLeftCapWidth: 7 topCapHeight: 0];
        self.atkImage = [[UIImage imageFromResourcePath: @"Images/Interface/EVYieldAtk.png"] stretchableImageWithLeftCapWidth: 7 topCapHeight: 0];
        self.defImage = [[UIImage imageFromResourcePath: @"Images/Interface/EVYieldDef.png"] stretchableImageWithLeftCapWidth: 7 topCapHeight: 0];
        self.spAtkImage = [[UIImage imageFromResourcePath: @"Images/Interface/EVYieldSpAtk.png"] stretchableImageWithLeftCapWidth: 7 topCapHeight: 0];
        self.spDefImage = [[UIImage imageFromResourcePath: @"Images/Interface/EVYieldSpDef.png"] stretchableImageWithLeftCapWidth: 7 topCapHeight: 0];
        self.speedImage = [[UIImage imageFromResourcePath: @"Images/Interface/EVYieldSpeed.png"] stretchableImageWithLeftCapWidth: 7 topCapHeight: 0];
        
		//initialize the values array
		NSMutableArray *_valueStrings = [[NSMutableArray alloc] init];
		for( NSInteger i = 0; i < EV_NUM_CELLS; i++ )
		{
			NSMutableString *value = [[NSMutableString alloc] initWithString: @"0"];
			[_valueStrings addObject: value];
			[value release];
		}
		self.valueStrings = _valueStrings;
		[_valueStrings release];
		
        //init and add the titles for each stat
        self.titleTexts = [NSArray arrayWithObjects: NSLocalizedString( @"HP", nil ), NSLocalizedString( @"Atk", nil ), NSLocalizedString( @"Def", nil ), NSLocalizedString( @"Sp. Atk", nil ), NSLocalizedString( @"Sp. Def", nil ), NSLocalizedString( @"Speed", nil ), nil];	
        self.titleImages = [NSArray arrayWithObjects: hpImage, atkImage, defImage, spAtkImage, spDefImage, speedImage, nil];
    }
	
    return self;
}

- (void)dealloc {
    [hpImage release];
    [atkImage release];
    [defImage release];
    [spAtkImage release];
    [spDefImage release];
    [speedImage release];
    
    [titleTexts release];
    [titleImages release];
    
	[valueStrings release];
    [super dealloc];
}

-(void) drawRect:(CGRect)rect
{
	//middle of the view for centering purposes
	//NSInteger midPoint = self.bounds.size.width / 2;
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	//the width of each box (floored since rounding up can result in the boxes exceeding the parent view)
	NSInteger boxWidth = floor(self.bounds.size.width - ((EV_NUM_CELLS-1) * EV_X_SPACING)) / EV_NUM_CELLS;
	
	//save the total width of the rendered boxes (which should be slightly smaller than the superview frame)
	NSInteger totalWidth = (boxWidth * EV_NUM_CELLS) + ((EV_NUM_CELLS-1) * EV_X_SPACING);
	
	//calculate the xOffset needed to center the content in the view
	NSInteger xOffset = (self.frame.size.width - totalWidth) / 2;
    
    //create the draw box
    CGRect boxRect;
    boxRect.origin.y = EV_Y_SPACING;
    boxRect.size.width = boxWidth;
    boxRect.size.height = EV_BOX_HEIGHT;
    
    //position of value text in box
    CGRect valueRect;
    valueRect.origin.y = boxRect.origin.y + 17;
    valueRect.size.width = boxWidth;
    valueRect.size.height = 20;
    
    //position of title text
    CGRect titleRect;
    titleRect.origin.y = boxRect.origin.y + 5;
    titleRect.size.width = boxWidth;
    titleRect.size.height = 10;
    
    UIFont *valueFont = [UIFont boldSystemFontOfSize: 20.0f];
    UIFont *titleFont = [UIFont boldSystemFontOfSize: 12.0f];
    
	for( NSInteger i = 0; i < EV_NUM_CELLS; i++ )
	{
		NSString *valueString = [valueStrings objectAtIndex: i];
        UIColor *boxColor = [self boxColorForCellIndex: i];
		UIColor *boxStrokeColor = [self boxStrokeColorForCellIndex: i];
        
		//init the x position to draw the box to
		boxRect.origin.x = ((boxWidth+EV_X_SPACING) * i) + xOffset;
        
		//draw the box
		TCDrawRoundedRectWithStroke( context, boxRect, 5.0f, 1.0f, boxColor, boxStrokeColor );
		
		//set the text color
		[[UIColor blackColor] set];
		
		//draw the title label
		NSString *titleText = [titleTexts objectAtIndex: i];		
		titleRect.origin.x = boxRect.origin.x;

		//draw the text
		[titleText drawInRect:titleRect withFont: titleFont lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];
		
		//draw the value labels inside the box
		valueRect.origin.x = boxRect.origin.x;
		
		//draw the text
		[valueString drawInRect: valueRect withFont: valueFont lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];
	}
    
    
    //draw label
    NSString *label = NSLocalizedString( @"EV yield", nil);
    CGRect drawRect = CGRectMake( floor(self.center.x)-45, self.frame.size.height-22, 90, 18);
    
    [[UIColor tableCellCaptionColor] set];
    [label drawInRect: drawRect withFont: [UIFont boldSystemFontOfSize: 13.0f] lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];   
}

-(UIColor *)boxColorForCellIndex: (NSInteger) index
{
	switch (index) {
		case CELL_HP:
			return [UIColor colorWithRed: 255.0f/255.0f green: 89.0f/255.0f blue: 89.0f/255.0f alpha: 1.0f];
		case CELL_ATK:
			return [UIColor colorWithRed: 255.0f/255.0f green: 167.0f/255.0f blue: 89/255.0f alpha: 1.0f];
		case CELL_DEF:
			return [UIColor colorWithRed: 255.0f/255.0f green: 226.0f/255.0f blue: 89/255.0f alpha: 1.0f];
		case CELL_SPATK:
			return [UIColor colorWithRed: 89.0f/255.0f green: 191.0f/255.0f blue: 255.0f/255.0f alpha: 1.0f];
		case CELL_SPDEF:
			return [UIColor colorWithRed: 140.0f/255.0f green: 221.0f/255.0f blue: 119.0f/255.0f alpha: 1.0f];
		case CELL_SPEED:
			return [UIColor colorWithRed: 255.0f/255.0f green: 138.0f/255.0f blue: 196/255.0f alpha: 1.0f];
		default: 
			break;
	}
	
	return [UIColor blackColor];
}

-(UIColor *)boxStrokeColorForCellIndex: (NSInteger) index
{
	switch (index) {
		case CELL_HP:
			return [UIColor colorWithRed: 159.0f/255.0f green: 0.0f blue: 0.0f alpha: 1.0f];
		case CELL_ATK:
			return [UIColor colorWithRed: 159.0f/255.0f green: 97.0f/255.0f blue: 0.0f alpha: 1.0f];
		case CELL_DEF:
			return [UIColor colorWithRed: 159.0f/255.0f green: 142.0f/255.0f blue: 0.0f alpha: 1.0f];
		case CELL_SPATK:
			return [UIColor colorWithRed: 0.0f/255.0f green: 97.0f/255.0f blue: 159.0f/255.0f alpha: 1.0f];
		case CELL_SPDEF:
			return [UIColor colorWithRed: 19.0f/255.0f green: 159.0f/255.0f blue: 0.0f alpha: 1.0f];
		case CELL_SPEED:
			return [UIColor colorWithRed: 188.0f/255.0f green: 39.0f/255.0f blue: 193.0f/255.0f alpha: 1.0f];
		default: 
			break;
	}
	
	return [UIColor blackColor];
}

#pragma mark Manual Setter Accessors

-(void) setHp:(NSInteger)_hp
{
	if( _hp == hp )
		return;
	
	hp = _hp;
	
	NSMutableString *valueString = (NSMutableString *)[valueStrings objectAtIndex: CELL_HP];
	[valueString setString: [NSString stringWithFormat: @"%d", hp] ];
	
}

-(void) setAtk:(NSInteger)_atk
{
	if( _atk == atk )
		return;
	
	atk = _atk;
	
	NSMutableString *valueString = (NSMutableString *)[valueStrings objectAtIndex: CELL_ATK];
	[valueString setString: [NSString stringWithFormat: @"%d", atk] ];
}

-(void) setDef:(NSInteger)_def
{
	if( _def == def )
		return;
	
	def = _def;
	
	NSMutableString *valueString = (NSMutableString *)[valueStrings objectAtIndex: CELL_DEF];
	[valueString setString: [NSString stringWithFormat: @"%d", def] ];
}

-(void) setSpAtk:(NSInteger)_spAtk
{
	if( _spAtk == spAtk )
		return;
	
	spAtk = _spAtk;
	
	NSMutableString *valueString = (NSMutableString *)[valueStrings objectAtIndex: CELL_SPATK];
	[valueString setString: [NSString stringWithFormat: @"%d", spAtk] ];
}

-(void) setSpDef:(NSInteger)_spDef
{
	if( _spDef == spDef )
		return;
	
	spDef = _spDef;
	
	NSMutableString *valueString = (NSMutableString *)[valueStrings objectAtIndex: CELL_SPDEF];
	[valueString setString: [NSString stringWithFormat: @"%d", spDef] ];	
}

-(void) setSpeed:(NSInteger)_speed
{
	if( _speed == speed )
		return;
	
	speed = _speed;
	
	NSMutableString *valueString = (NSMutableString *)[valueStrings objectAtIndex: CELL_SPEED];
	[valueString setString: [NSString stringWithFormat: @"%d", speed] ];
}

@end
