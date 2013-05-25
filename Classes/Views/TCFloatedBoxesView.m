//
//  TCFloatedBoxesView.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/02/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//	A wrapper class. This class takes a series of views
//	and displays them horizontally along a view, whilst wrapping
//	to a new line as needed.
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

#import "TCFloatedBoxesView.h"

@interface TCFloatedBoxesView ()

-(NSInteger) numberOfItemsPerLineWithWidth: (CGFloat) width;

@end


@implementation TCFloatedBoxesView

@synthesize itemsPerLine, numberOfItems, minWidthPadding, heightPadding, frameHeight, itemWidth, itemHeight, highlighted;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.contentMode = UIViewContentModeRedraw;
        self.contentStretch = CGRectMake( 0.99f, 0.0f, 0.01f, 1.0f);
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.minWidthPadding = 5;
		self.heightPadding = 5;
		self.itemWidth = 30;
		self.itemHeight = 30;
    }
    return self;
}

-(void) setNumberOfItems: (NSInteger) num
{
	if( num == numberOfItems )
		return;
	
	numberOfItems = num;
	
	self.itemsPerLine = [self numberOfItemsPerLineWithWidth: self.frame.size.width];
}

-(NSInteger) numberOfItemsPerLineWithWidth: (CGFloat)width
{
	NSInteger numPerLine = 0;
	//find out how many elements we can fit on each line
	//(for easier working, it's assumed all elements are the same size)
	NSInteger viewWidth = 0;
	for ( NSInteger i = 0; i < numberOfItems; i++ )
	{
		viewWidth += itemWidth + minWidthPadding;
		if ( (viewWidth-minWidthPadding) > width )
			break;
		
		numPerLine++;
	}
	
	return numPerLine;
}

-(NSInteger) frameHeight
{	
	if( numberOfItems == 0 )
		return 44;
	
	return ((NSInteger)ceil((CGFloat)numberOfItems / (CGFloat)itemsPerLine) * (itemHeight+heightPadding))-heightPadding;
}

-(void) setFrame:(CGRect)newFrame
{ 
	//items per line
	self.itemsPerLine = [self numberOfItemsPerLineWithWidth: newFrame.size.width];
	newFrame.size.height = self.frameHeight;
	
	[super setFrame: newFrame];
}

-(void) drawRect:(CGRect)rect
{
	//CG Context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//Calculate the amount of necessary padding now
	NSInteger linePadding = (self.bounds.size.width - (itemsPerLine * itemWidth)) / (itemsPerLine - 1);
        
	//start laying out each of the items
	NSInteger y = 0;
	for ( NSInteger i = 0; i < numberOfItems; i++ )
	{
		CGRect itemFrame;
		itemFrame.origin.x = (itemWidth + linePadding) * (i % itemsPerLine);
		itemFrame.origin.y = y;
		itemFrame.size.width = itemWidth;
		itemFrame.size.height = itemHeight;
		
		//call the child class to render stuff in this box
		[self drawInItemRect: itemFrame forIndex: i+1 withContext: context];
		
		//once hit the end of the line, move to the next one
		if( (i+1) % itemsPerLine == 0 )
			y += itemHeight + heightPadding;
	}
}

-(void) drawInItemRect: (CGRect)rect forIndex: (NSInteger) index withContext: (CGContextRef) context
{
	//this is an abstract for subclasses. Here they can perform drawing operations per item box
}

#pragma mark Highlighted override
- (void) setHighlighted:(BOOL)_highlighted
{
	highlighted = _highlighted;
    [self setNeedsDisplay];
}

- (BOOL) isHighlighted
{
	return highlighted;
}

- (void)dealloc {
    [super dealloc];
}

@end
