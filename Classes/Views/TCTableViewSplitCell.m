//
//  UITableViewSplitCell.m
//  iPokedex
//
//  Created by Timothy Oliver on 12/01/11.
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

#import "TCTableViewSplitCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TCTableViewSplitCell

@synthesize defaultText, borderColor, selectedCell, numberOfCells, cellWidth, numberOfLines, tappedCell, highlighted, delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
        self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.clipsToBounds = YES;
		
		self.borderColor = [UIColor colorWithWhite: 0.82f alpha: 1.0f];
        self.numberOfLines = 1;
        self.tappedCell = -1;
    }
    return self;
}

- (void)dealloc {
	[defaultText release];
	[borderColor release];
	
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
    CGRect frame = self.frame;
    NSInteger y = 0;
    
	//if no items, display default text
	if( numberOfCells == 0 )
	{
		self.contentStretch = CGRectZero; //disable stretching
		[[UIColor grayColor] set];
		[defaultText drawInRect: CGRectMake( 0, (frame.size.height/2)-9, frame.size.width-4, 18) 
					   withFont: [UIFont boldSystemFontOfSize: 16.0f] 
				  lineBreakMode: UILineBreakModeClip 
					  alignment: UITextAlignmentCenter];
		return;
	}
    
	NSInteger numPerLine = floor(numberOfCells / numberOfLines);
    CGFloat lineHeight = frame.size.height/numberOfLines;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Drawing code
	self.cellWidth = frame.size.width / numPerLine;
	
	for( int i = 0; i < numberOfCells; i++ )
	{ 
		//work out where to draw the content
        CGRect contentDrawRect = CGRectMake((cellWidth*(i%numPerLine)), y, cellWidth, lineHeight);
        
        //draw the content
        [self drawInCellIndex: i withRect: contentDrawRect withContext: context];
        
		//add the vertical divider
		if ( i < (numPerLine-1) )
		{
			//Draw a rectangle
			CGContextSetFillColorWithColor(context, borderColor.CGColor);
			//Define a rectangle
			CGContextAddRect(context, CGRectMake(floor(cellWidth*(i+1)), 0, 1.0f, frame.size.height));
			//Draw it
			CGContextFillPath(context);
		}
        
        //if it's a new line, increment
        if( ( (i+1) % numPerLine ) == 0)
        {
            //increment the height
            y += (NSInteger)lineHeight;
            
            //draw the horizontal divider
            CGContextSetFillColorWithColor(context, borderColor.CGColor);
			//Define a rectangle
			CGContextAddRect(context, CGRectMake( 0, y, frame.size.width, 1.0f) );
			//Draw it
			CGContextFillPath(context);           
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

-(void)drawInCellIndex: (NSInteger) index withRect: (CGRect)rect withContext:(CGContextRef)context
{
    //abstract
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get the touch object
    UITouch* touch = [touches anyObject];     
    CGPoint location = [touch locationInView: self];

    //determine which cell was tapped
    NSInteger numPerLine = floor(numberOfCells / numberOfLines);
    CGFloat cellHeight = self.frame.size.height/numberOfLines;
    
    //Work out the X offset
    NSInteger cellIndex = floor( location.x / cellWidth );
    //Work out the Y
    cellIndex += floor( location.y / cellHeight ) * numPerLine;
    
    //Send delegate asking if this one can be tapped
    if( self.delegate && [self.delegate respondsToSelector: @selector(splitTableCell: indexCanBeTapped:)] )
    {
       if( [self.delegate splitTableCell: self indexCanBeTapped: cellIndex] == NO )
           return;
    }
    else
        return;
    
    self.tappedCell = cellIndex;
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
    if( tappedCell == -1 )
        return;
    
    if( self.delegate && [self.delegate respondsToSelector: @selector(splitTableCellTapped: withIndex:)] )
        [self.delegate splitTableCellTapped: self withIndex: tappedCell];
        
    self.tappedCell = -1;
    [self performSelector: @selector(setNeedsDisplay) withObject: nil afterDelay: 0.3f];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{	
	if( tappedCell == -1 )
        return;
	
    self.tappedCell = -1;
    [self performSelector: @selector(setNeedsDisplay) withObject: nil afterDelay: 0.3f];	
}

@end
