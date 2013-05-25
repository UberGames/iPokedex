//
//  TextBoxContentView.m
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

#import "TextBoxContentView.h"


@implementation TextBoxContentView

@synthesize flavorText, xOffset, yOffset, fontSize;

#pragma mark Class Creation/Destruction
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentStretch = CGRectMake( 0.99f, 0.0f, 1.0f, 1.0f);
		self.fontSize = 15;
        self.yOffset = 0;
        self.xOffset = 0;
    }
    
    return self;
}


- (void)dealloc {
	[flavorText release];
    [super dealloc];
}

#pragma mark CG Draw
- (void)drawRect:(CGRect)rect {
	UIFont *font = [UIFont systemFontOfSize: fontSize];
	CGSize textSize = [flavorText sizeWithFont: font constrainedToSize: CGSizeMake( (self.bounds.size.width-xOffset), NSIntegerMax) lineBreakMode: UILineBreakModeWordWrap];
	CGRect drawFrame = CGRectMake( xOffset, yOffset, textSize.width, textSize.height );
	
	[[UIColor blackColor] set];
	[flavorText drawInRect: drawFrame withFont: font lineBreakMode: UILineBreakModeWordWrap];
}


#pragma mark Height
+ (CGFloat) cellHeightWithWidth: (CGFloat)width text: (NSString *)text fontSize: (NSInteger) _fontSize
{
	CGSize textSize = [text sizeWithFont: [UIFont systemFontOfSize: _fontSize] constrainedToSize: CGSizeMake( width, NSIntegerMax) lineBreakMode: UILineBreakModeWordWrap];
	return textSize.height+5;
}

-(NSInteger) height
{ 
	CGSize textSize = [flavorText sizeWithFont: [UIFont systemFontOfSize: fontSize] constrainedToSize: CGSizeMake( (self.bounds.size.width-xOffset), NSIntegerMax) lineBreakMode: UILineBreakModeWordWrap]; //-5 to account for whitespace on the end 

    return textSize.height+5;
}

#pragma mark Copy to Clipboard Methods
- (BOOL)canBecomeFirstResponder 
{
    return YES;
}

- (void)copy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.flavorText;
}

//set so only the copy menu choice appears
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if( action == @selector(copy:) )
       return YES;
       
    return NO;
}

//enable the popup menu
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{ 
    [super touchesBegan:touches withEvent:event];
    [self becomeFirstResponder];
    
    CGRect drawFrame = CGRectMake( xOffset, yOffset, self.frame.size.width, self.frame.size.height ); 
    UIMenuController *menuController = [UIMenuController sharedMenuController];

    [menuController setTargetRect: drawFrame inView: self ];
    [menuController setMenuVisible: YES animated: YES];
}

@end
