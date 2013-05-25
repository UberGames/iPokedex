//
//  TCGroupedTableSectionHeaderView.m
//  iPokedex
//
//  Created by Tim Oliver on 7/02/11.
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

#import "TCGroupedTableSectionHeaderView.h"

#define GROUP_HEADER_TITLE_SIZE 17

@implementation TCGroupedTableSectionHeaderView

@synthesize title;

- (id)initWithTitle: (NSString *)text {
    
    self = [super initWithFrame:CGRectMake( 0, 0, 320, GROUP_TABLE_SECTION_HEADER_HEIGHT)];
    if (self) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
        
        self.title = text;
	}
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGRect drawRect = CGRectMake( 20, 0, self.bounds.size.width, GROUP_TABLE_SECTION_HEADER_HEIGHT);
    UIFont *font = [UIFont boldSystemFontOfSize: GROUP_HEADER_TITLE_SIZE];
    CGSize textSize = [title sizeWithFont: font];
    
    drawRect.origin.y = (self.frame.size.height/2) - (textSize.height/2);
	drawRect.size.height = textSize.height+5;
    
    //draw the bevel underneath
    [[UIColor colorWithWhite: 1.0f alpha: 0.7f] set];
    [title drawInRect: CGRectOffset(drawRect, 0, 1) withFont: font];
    
    //draw the text
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    [[UIColor colorWithWhite: 0.0f alpha: 0.8f] set];
    [title drawInRect: drawRect withFont: font];
     
    CGContextRestoreGState(context);
}


- (void)dealloc {
	[title release];
    [super dealloc];
}


@end
