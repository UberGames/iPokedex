//
//  TableHeaderContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 2/03/11.
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

#import "TableHeaderContentView.h"


@implementation TableHeaderContentView

@synthesize title, subTitle, generation, icon1, icon2, iconMargin, heightPadding, contentIndent, lineSpacing, titleSize, subTitleSize, generationSize, alignment;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentStretch = CGRectMake( 1.0f, 0, 1.0f, 1.0f);
		self.alignment = UITextAlignmentLeft;
		self.lineSpacing = 5;
		self.titleSize = 20;
		self.subTitleSize = 14;
        self.generationSize = 14;
		self.heightPadding = 10;
		self.iconMargin = 5;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGSize rectSize = self.bounds.size;
	UIFont *font;
	CGSize size;
	CGRect drawRect;
	
	NSInteger x = contentIndent;
	NSInteger y = heightPadding;
	
	//draw the title
	font = [UIFont boldSystemFontOfSize: titleSize];
	drawRect = CGRectMake( x, y, rectSize.width, titleSize );
	
	//realign if set to middle
	if( alignment == UITextAlignmentCenter )
	{
		size = [title sizeWithFont: font];
		drawRect = CGRectMake( (rectSize.width/2)-(size.width/2), y, size.width, drawRect.size.height);
	}

	//draw bevel effect
	[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
	[title drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
	
	//draw text
	[[UIColor blackColor] set];
	[title drawInRect: drawRect withFont: font];
	
	//offset by the line spacing
	y += titleSize + lineSpacing;	
	
	//draw the subtitle
	if( [subTitle length] )
	{
		font = [UIFont systemFontOfSize: subTitleSize];
		drawRect = CGRectMake( x, y, rectSize.width, subTitleSize );
		
		//realign if set to middle
		if( alignment == UITextAlignmentCenter )
		{
			size = [subTitle sizeWithFont: font];
			drawRect = CGRectMake( (rectSize.width/2)-(size.width/2), y, size.width, drawRect.size.height);
		}
		
		//draw bevel effect
		[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
		[subTitle drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
		
		//draw text
		[[UIColor blackColor] set];
		[subTitle drawInRect: drawRect withFont: font];
        
        y += subTitleSize + lineSpacing;
	}
	
    //draw the generation string
    if( [generation length] )
    {
        
        font = [UIFont boldSystemFontOfSize: generationSize];
        drawRect = CGRectMake( x, y, drawRect.size.width, generationSize );
        
        //draw bevel effect
		[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
		[generation drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
		
		//draw text
		[[UIColor blackColor] set];
		[generation drawInRect: drawRect withFont: font];
    }
    
	//draw the icons
	if( icon1 )
	{
		drawRect = CGRectMake( (rectSize.width - contentIndent)-icon1.size.width, heightPadding+3, icon1.size.width, icon1.size.height);
		[icon1 drawInRect: drawRect];
		
		if ( icon2 )
		{
			drawRect = CGRectMake( (rectSize.width - contentIndent)-icon2.size.width, heightPadding+icon1.size.height+6, icon2.size.width, icon2.size.height);
			[icon2 drawInRect: drawRect];
		}
	}
}

- (NSInteger) height
{
	NSInteger height = (heightPadding*2);
	
	if( [title length] > 0 )
		height += titleSize+lineSpacing;
	
	if( [subTitle length] > 0 )
		height += subTitleSize+lineSpacing;
	
    if( [generation length] > 0 )
        height += generationSize+(lineSpacing);
    
	if( icon1 )
	{
		CGSize iconSize = icon1.size;
		height += iconSize.height+lineSpacing;
	}
	
	return height;
}

- (void)dealloc {
	[title release];
	[subTitle release];
    [generation release];
	[icon1 release];
	[icon2 release];
	
    [super dealloc];
}


@end
