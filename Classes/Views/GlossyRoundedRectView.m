//
//  GlossyRoundedRect.m
//  iPokedex
//
//  Created by Timothy Oliver on 25/01/11.
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

#define CLAMP( a, min, max) ( (a) < (min) ? (min) : ((a) > (max) ? (max) : (a)))

#import "GlossyRoundedRectView.h"

@interface GlossyRoundedRectView ()
-(void) setGlossyColors;
@end

#define DEFAULT_WHITE_OFFSET 20
#define DEFAULT_BLACK_OFFSET 50 

@implementation GlossyRoundedRectView

@synthesize highlightOffset;
@synthesize shadowOffset;

-(id) initWithCoder:(NSCoder *)decoder
{
	if( self = [super initWithCoder: decoder])
	{
		self.highlightOffset	= DEFAULT_WHITE_OFFSET;
		self.shadowOffset		= DEFAULT_BLACK_OFFSET;
	}
	
	return self;
}

-(id) initWithFrame:(CGRect)frame
{
	if( self = [super initWithFrame: frame] )
	{
		self.highlightOffset	= DEFAULT_WHITE_OFFSET;
		self.shadowOffset		= DEFAULT_BLACK_OFFSET;
	}
	
	return self;
}

-(void)setRectColor:(UIColor *)color
{
	if( [rectColor isEqual: color] )
		return;
	
	[rectColor release];
	rectColor = [color retain];
	
	[self setGlossyColors];
}

+(NSArray *) glossyColorsFromColor: (UIColor *)color highLightOffset: (CGFloat) highlight shadowOffset: (CGFloat) shadow
{
	CGColorSpaceModel colorModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
	
	//only these models contain RGB values
	if( colorModel != kCGColorSpaceModelMonochrome && colorModel != kCGColorSpaceModelRGB )
		[NSException raise: NSInternalInconsistencyException format: @"Gloss color must be RGB"];
	
	CGFloat *c = (CGFloat *)CGColorGetComponents(color.CGColor);
	
	//if it is monochrome, pad it out to the RGB channels
	if( colorModel == kCGColorSpaceModelMonochrome )
		c[1] = c[2] = c[0];
	
	CGFloat whiteOffset = highlight/ 255.0f;
	CGFloat blackOffset = shadow / 255.0f;
	
	//calculate the glossy highlight component
	UIColor *topColor = [UIColor colorWithRed: CLAMP(c[0]+whiteOffset, 0, 1) green: CLAMP(c[1]+whiteOffset, 0, 1) blue: CLAMP(c[2]+whiteOffset, 0, 1) alpha: 1.0f];
	//calculate the dark midpoint component
	UIColor *midColor = [UIColor colorWithRed: CLAMP(c[0]-blackOffset, 0, 1) green: CLAMP(c[1]-blackOffset, 0, 1) blue: CLAMP(c[2]-blackOffset, 0, 1) alpha: 1.0f];
	//the bottom component is our original color, (re-calc'd for RGB if it was originally a monochrome)
	UIColor *bottomColor = [UIColor colorWithRed: c[0] green: c[1] blue: c[2] alpha: 1.0f];
	
	return [NSArray arrayWithObjects: topColor, topColor, midColor, bottomColor, nil];
}

-(void) setGlossyColors
{	
	//input the gloss data into the gradient draw code
	[self setGradientColors: [GlossyRoundedRectView glossyColorsFromColor: rectColor highLightOffset: highlightOffset shadowOffset: shadowOffset ]];
	[self setGradientPositionsWithFloatsAndCount: 4, 0.0f, 0.5f, 0.5f, 1.0f];
}

@end
