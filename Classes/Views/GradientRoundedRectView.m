//
//  GradientRoundedRectView.m
//  iPokedex
//
//  Created by Tim Oliver on 24/01/11.
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

#import "GradientRoundedRectView.h"

@interface RoundedRectView ()
	-(CGMutablePathRef) pathForRoundedRect;
@end

@implementation GradientRoundedRectView

@synthesize gradientColors;
@synthesize	gradientPositions;

-(id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder: decoder];
    if (self) {
        self.gradientColors = kDefaultGradientColors;
		self.gradientPositions = kDefaultGradientPositions;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.gradientColors = kDefaultGradientColors;
		self.gradientPositions = kDefaultGradientPositions;   
    }
    return self;
}

//a bit easier than manually setting the array objects
-(void) setGradientPositionsWithFloatsAndCount: (NSInteger)count, ...
{		
	va_list args;
	NSMutableArray *positions = [[NSMutableArray alloc] init];
	
	va_start( args, count );
	for( int i = 1; i < count+1; i++ )
	{
		double pos = va_arg( args, double );
		[positions addObject: [NSNumber numberWithFloat: pos]];
	}
	va_end( args );
		 
	self.gradientPositions = positions;
	[positions release];
}

-(void) setGradientColorsWithColors: (UIColor *)first, ...
{	
	va_list args;
	NSMutableArray *colors = [[NSMutableArray alloc] init];
	
	va_start( args, first );
	for ( UIColor *color = first; color != nil; color = (UIColor *)va_arg( args, UIColor*))
	{
		[colors addObject: (id)color.CGColor];
	}
	va_end( args );
	
	self.gradientColors = colors;
	[colors release];
}
							   
- (void)drawRect:(CGRect)rect { 
    //Quartz Context
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	//convert the gradient positions into a C array format
	CGFloat *positions = malloc( [self.gradientPositions count] * sizeof(CGFloat) );
	for( int i = 0; i < [self.gradientPositions count]; i++ ){
		positions[i] = (CGFloat)[(NSNumber *)[self.gradientPositions objectAtIndex: i] floatValue];
	}
	
	//Set draw parameters
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);	
	CGContextSetFillColorWithColor(context, self.rectColor.CGColor);
	
	//get the path 
	CGMutablePathRef path = [self pathForRoundedRect];
	
	//render the gradient
	CGContextSaveGState(context);
	CGContextAddPath( context, path );
	CGContextClip( context ); //CGFloat positions[2] = {0.0f, 1.0f};
	CGGradientRef gradient = CGGradientCreateWithColors( colorspace, (CFArrayRef)self.gradientColors, positions);
	CGContextDrawLinearGradient(context, 
									gradient, 
									CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMinY(self.bounds)), 
									CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMaxY(self.bounds)),
								0 );
	CGContextRestoreGState(context);
	
	//render the stroke
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGContextRestoreGState(context);
	
	//free all of the resources
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);
	free( positions );
}


- (void)dealloc {
	[gradientPositions release];
	[gradientColors release];
    [super dealloc];
}


@end
