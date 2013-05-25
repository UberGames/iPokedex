//
//  TableCellContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 5/03/11.
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

#import "TableCellContentView.h"

@implementation TableCellContentView

@synthesize icon, title, subTitle;
@synthesize highlighted;
@synthesize versionStrings, versionColors;	
@synthesize titleInset, titleWidth;
@synthesize titleSize, subTitleSize;
@synthesize subTitleIsMultiline;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
        self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.titleInset = TABLECONTENTCELL_DEFAULT_INSET;
		self.titleWidth = self.bounds.size.width - titleInset;
		self.titleSize = TABLECONTENTCELL_DEFAULT_TITLESIZE;
		self.subTitleSize = TABLECONTENTCELL_DEFAULT_SUBTITLESIZE;
        
        self.contentStretch = CGRectMake(0.99f, 0.0f, 0.01f, 1.0f); 
    }
    return self;
}

- (CGFloat)height
{
    if( subTitleIsMultiline == NO )
        return 43;
        
    return [TableCellContentView heightWithSubtitleText: self.subTitle withSubTitleSize: self.subTitleSize forWidth: self.bounds.size.width-titleInset];
}

+ (CGFloat)heightWithSubtitleText: (NSString *)subtitleText withSubTitleSize: (CGFloat)subtitleFontSize forWidth: (CGFloat)width
{
    if( [subtitleText length] == 0 )
        return 44;
    
    NSInteger height = 44 - subtitleFontSize;
    CGSize subTitleFrame = [subtitleText sizeWithFont: [UIFont systemFontOfSize: subtitleFontSize] constrainedToSize: CGSizeMake(width, NSIntegerMax) lineBreakMode: UILineBreakModeWordWrap];
    
    return height + subTitleFrame.height - 2;
}

- (void)drawRect:(CGRect)rect {
	CGRect drawRect;
	UIFont *font;
    
	if ( highlighted )
		self.backgroundColor = [UIColor clearColor];
	
	if( highlighted ) { [[UIColor whiteColor] set]; } else { [[UIColor blackColor] set]; }
	
    //draw the icon
    if( icon )
    {
        drawRect = CGRectMake( 5, floor(self.center.y-(icon.size.height/2)), icon.size.width, icon.size.height);
        [icon drawInRect: drawRect];
    }
    
	drawRect = CGRectMake( titleInset, 18 - (titleSize/2), titleWidth, titleSize );
	if( subTitle != nil )
	{
		drawRect.origin.y = 0;
		[title drawInRect: drawRect withFont: [UIFont boldSystemFontOfSize: titleSize] lineBreakMode: UILineBreakModeTailTruncation];
		
		//detail text
		if( highlighted == NO )
			[[UIColor grayColor] set];
		
        font = [UIFont systemFontOfSize: subTitleSize];
        drawRect.origin.y += titleSize+2; //Font size + padding
        
        if( subTitleIsMultiline )
        {
            drawRect.size.height = NSIntegerMax;
            [subTitle drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeWordWrap];
        }
        else
        {
            [subTitle drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeTailTruncation];
        }
	}
	else 
	{
		//if there are version strings, truncate the big string to fit them on the end
		if ( versionStrings != nil )
			drawRect.size.width -= 35;
		
		font = [UIFont boldSystemFontOfSize: titleSize];
		[title drawInRect: drawRect withFont: font lineBreakMode: UILineBreakModeTailTruncation];
	}
	
	//draw exclusive version texts
	if( versionStrings != nil )
	{
		CGSize textSize;
		if( subTitle )
			textSize = [subTitle sizeWithFont: font forWidth: drawRect.size.width lineBreakMode: UILineBreakModeTailTruncation];
		else 
			textSize = [title sizeWithFont: font forWidth: drawRect.size.width lineBreakMode: UILineBreakModeTailTruncation];
		
		CGPoint point = CGPointMake( drawRect.origin.x + textSize.width + 1, drawRect.origin.y);
		font = [UIFont boldSystemFontOfSize: 11.0f];
		
		for( NSInteger i = 0; i < [versionStrings count]; i++ )
		{
			UIColor *color = [versionColors objectAtIndex: i];
			NSString *string = [versionStrings objectAtIndex: i];
			
			if( highlighted == NO )
				[color set];
			
			[string drawAtPoint: point withFont: font];
			
			textSize = [string sizeWithFont: font];
			point.x += textSize.width;
		}
	}	
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

- (void)dealloc {
    [icon release];
	[title release];
	[subTitle release];
	[versionStrings release];
	[versionColors release];
	
    [super dealloc];
}


@end
