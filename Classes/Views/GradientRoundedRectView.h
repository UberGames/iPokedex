//
//  GradientRoundedRectView.h
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

#import <UIKit/UIKit.h>
#import "RoundedRectView.h"

#define kDefaultGradientColors [NSArray arrayWithObjects: (id)[UIColor colorWithRed: 1.0f green: 1.0f blue:1.0f alpha: 1.0f].CGColor, [UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 1.0f].CGColor, nil]
#define kDefaultGradientPositions [NSArray arrayWithObjects: [NSNumber numberWithFloat: 0.0f], [NSNumber numberWithFloat: 1.0f], nil]

@interface GradientRoundedRectView : RoundedRectView {
	NSArray *gradientColors;
	NSArray *gradientPositions;
}

@property (nonatomic, retain) NSArray *gradientColors;
@property (nonatomic, retain) NSArray *gradientPositions;

-(void) setGradientPositionsWithFloatsAndCount: (NSInteger)count, ...;
-(void) setGradientColorsWithColors: (UIColor *)first, ... NS_REQUIRES_NIL_TERMINATION;

@end
