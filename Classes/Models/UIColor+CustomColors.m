//
//  UIColor+CustomColors.m
//  iPokedex
//
//  Created by Timothy Oliver on 13/04/11.
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

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

/* The default light-blue color used for out-of-boundary regions on tables */
+ (UIColor *)tableHeaderBackgroundColor
{
    return [UIColor colorWithRed: 0.92f green: 0.94f blue: 0.99f alpha: 1.0f];
}

/* The dark-blue color used for table cell caption strings */
+ (UIColor *)tableCellCaptionColor
{
    return [UIColor colorWithRed: 82.0f/255.0f green: 102.0f/255.0f blue: 145.0f/255.0f alpha: 1.0f];
}

/* As of iOS 5, the border outline of table cells */
+ (UIColor *)tableCellBorderColor
{
    return [UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.18f];
}

@end
