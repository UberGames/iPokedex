//
//  TitledTextBoxContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 19/04/11.
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

#import "TitledTextBoxContentView.h"
#import "UIColor+CustomColors.h"

#define TITLE_INSET 40

@implementation TitledTextBoxContentView

@synthesize title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.xOffset = TITLE_INSET+7;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //draw the heading text
    CGRect drawRect = CGRectMake( 0, 2.0f, TITLE_INSET, 13.0f);

    [[UIColor tableCellCaptionColor] set];
    [title drawInRect: drawRect withFont: [UIFont boldSystemFontOfSize: 13.0f] lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentRight];
    
    [super drawRect: rect];
}


- (void)dealloc
{
    [super dealloc];
    [title release];
}

@end
