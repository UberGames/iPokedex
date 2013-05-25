//
//  PokemonGenderRatioView.m
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

#import "PokemonGenderRatioView.h"
#import "UIImage+ImageLoading.h"
#import "UIColor+CustomColors.h"

#define GENDER_VIEW_MALE_COLOR [UIColor colorWithRed: 18.0f/255.0f green: 23.0f/255.0f blue: 255.0f/255.0f alpha: 1.0f]
#define GENDER_VIEW_FEMALE_COLOR [UIColor colorWithRed: 255.0f/255.0f green: 95.0f/255.0f blue: 201.0f/255.0f alpha: 1.0f]

@interface PokemonGenderRatioView ()

- (void)initRatioData;

@end

@implementation PokemonGenderRatioView

@synthesize maleBarImage, femaleBarImage, genderRate, genderlessLabel, maleText, femaleText, femaleRatio, maleRatio;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
		
		//init the genderrate as no gender by default
		genderRate = -1;		
	}
    return self;
}

-(void)setGenderRate:(NSInteger) rate
{
	genderRate = rate;
	[self initRatioData];
}

-(NSInteger)cellHeight
{
	if( genderRate == -1 )
	{
		return GENDER_RATIO_CELL_HEIGHT_GENDERLESS;
	}
	else 
	{
		return GENDER_RATIO_CELL_HEIGHT;
	}
}

-(void) initRatioData
{
	//dealloc all the views in this view (bar the celllabel)
	for( UIView *subview in self.subviews )
	{
		[subview removeFromSuperview];
		[subview release];
		subview = nil;
	}
	
	if( genderRate >= 0 )
	{
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = NSNumberFormatterPercentStyle;
		formatter.maximumFractionDigits = 2;
		
		self.femaleRatio = (genderRate * 12.5f) / 100.0f;
		self.maleRatio = 1.0f - femaleRatio;
	
		if( maleRatio > 0 )
			self.maleText = [NSString stringWithFormat: NSLocalizedString( @"%@ male%@", nil), [formatter stringFromNumber: [NSNumber numberWithFloat: maleRatio]], (femaleRatio > 0 ) ? @", " : @"" ];
    
		if( femaleRatio > 0 )
			self.femaleText = [NSString stringWithFormat: NSLocalizedString( @"%@ female", nil), [formatter stringFromNumber: [NSNumber numberWithFloat: femaleRatio]] ];
		
		[formatter release];
        
        //load the male image
        if (genderRate < 8 )
        {
            self.maleBarImage = [[UIImage imageFromResourcePath: @"Images/Interface/MaleGenderBar.png"] stretchableImageWithLeftCapWidth: 14 topCapHeight: 0];
        }
        
        if( genderRate > 0 )
        {
            self.femaleBarImage = [[UIImage imageFromResourcePath: @"Images/Interface/FemaleGenderBar.png"] stretchableImageWithLeftCapWidth: 14 topCapHeight: 0];
        }
	}
	else 
	{
		genderlessLabel = [[UILabel alloc] initWithFrame: CGRectMake( 0, 11, 280, 20 )];
		genderlessLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		genderlessLabel.textColor = [UIColor grayColor];
		genderlessLabel.font = [UIFont boldSystemFontOfSize: 16.0f];
		genderlessLabel.textAlignment = UITextAlignmentCenter;
		genderlessLabel.text = NSLocalizedString( @"This Pokémon has no gender", nil);	
		[self addSubview: genderlessLabel];
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
	//if there's no gender, ignore
	if( genderRate == -1 )
		return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	NSInteger midpoint = self.bounds.size.width / 2;
	
	//Draw the custom gender ratio bar
	//set the draw region and radius of the arcs
	CGRect barRegion = CGRectMake( rect.origin.x+3, rect.origin.y + 26, rect.size.width-6, 14 );
	
	//draw the male/female components
	//male
	if (genderRate < 8 )
	{
        CGContextSaveGState(context);
        
        //calc the rect
		CGRect maleRect = barRegion;
		
		//if not 100% male
		if( genderRate > 0 )
        {
			maleRect.size.width *= (maleRatio / 1.0f);
            UIRectClip(maleRect);
        }
		
        [maleBarImage drawInRect: barRegion];
        
        CGContextRestoreGState(context);
	}
	//female
	if ( genderRate > 0 )
    {
        CGContextSaveGState(context);
        
		//calc the rect
		CGRect femaleRect = barRegion;
		
		//if not 100% male
		if( genderRate < 8 )
		{
			femaleRect.origin.x += femaleRect.size.width * (( 1.0f - femaleRatio )/1.0f);
			femaleRect.size.width *= (femaleRatio / 1.0f);
            UIRectClip(femaleRect);
		}
        
        [femaleBarImage drawInRect: barRegion]; 

        CGContextRestoreGState(context);
	}
	
	//finally render the ratio text
	UIFont *font = [UIFont boldSystemFontOfSize: 14.0f];
	CGSize maleTextSize = [maleText sizeWithFont: font];
	CGSize femaleTextSize = [femaleText sizeWithFont: font];
	CGRect maleFrame = CGRectZero, femaleFrame = CGRectZero;
	
	//total width of both labels
	NSInteger textWidth = 0;
	if( maleRatio > 0.0f ) { textWidth += maleTextSize.width; }
	if( femaleRatio > 0.0f ) { textWidth += femaleTextSize.width; }
	
	//position the male label
	if( maleRatio > 0 && femaleRatio > 0 )
	{
		maleFrame = CGRectMake(  midpoint - (textWidth / 2), GENDER_RATIO_TITLE_Y, maleTextSize.width, 15 );
		femaleFrame = CGRectMake( maleFrame.origin.x+maleFrame.size.width, GENDER_RATIO_TITLE_Y, femaleTextSize.width, 15 );
	}
	else 
	{
		if( maleRatio > 0 )
			maleFrame = CGRectMake(  midpoint - (textWidth / 2), GENDER_RATIO_TITLE_Y, maleTextSize.width, 15 );
		else
			femaleFrame = CGRectMake(  midpoint - (textWidth / 2), GENDER_RATIO_TITLE_Y, femaleTextSize.width, 15 );
	}
	
	//draw the male text 
	if( maleRatio > 0 )
	{
		[GENDER_VIEW_MALE_COLOR set];
		[maleText drawInRect: maleFrame withFont: font];
	}
	
	//draw the female text
	if( femaleRatio > 0 )
	{
		[GENDER_VIEW_FEMALE_COLOR set];
		[femaleText drawInRect: femaleFrame withFont: font];
	}
    
    //draw label
    NSString *label = NSLocalizedString( @"Gender ratio", nil );
    CGRect drawRect = CGRectMake( floor(self.center.x)-50, self.frame.size.height-22, 100, 18);
    
    [[UIColor tableCellCaptionColor] set];
    [label drawInRect: drawRect withFont: [UIFont boldSystemFontOfSize: 13.0f] lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];
} 
	 
- (void)dealloc {
	[maleBarImage release];
    [femaleBarImage release];
    
	[maleText release];
	[femaleText release];
    
    self.genderlessLabel = nil;
	 
    [super dealloc];
}


@end
