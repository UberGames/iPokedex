//
//  TCBeveledButton.m
//  iPokedex
//
//  Created by Timothy Oliver on 8/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

#import "TCBeveledButton.h"
#import "TCQuartzFunctions.h"

#define IS_RETINA [UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0f

@interface TCBeveledButton (hidden) 

- (UIImage *)backgroundImage;
- (UIImage *)highlightedBackgroundImageWithBackgroundImage: (UIImage *)backgroundImage;
    
@end

@implementation TCBeveledButton

@synthesize radius;

#pragma mark -
#pragma mark Constructor Methods
+ (TCBeveledButton *)button
{
    return [TCBeveledButton buttonWithType: UIButtonTypeCustom];
}

+ (TCBeveledButton *)buttonWithRadius: (CGFloat)_radius;
{
    TCBeveledButton *button = [TCBeveledButton buttonWithType: UIButtonTypeCustom];
    button.radius = _radius;
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        self.radius = 5.0f;
    }
    
    return self;  
}

#pragma mark -
#pragma mark Accessor Method
- (void)setFrame:(CGRect)frame
{
    [super setFrame: frame];
    
    if( frame.size.width > 0 && frame.size.height > 0 )
    {
        UIImage *backgroundImage = [self backgroundImage];
        
        [self setBackgroundImage: backgroundImage forState: UIControlStateNormal];
        
        if( self.showsTouchWhenHighlighted == NO )
        {
            UIImage *highlightedBackgroundImage = [self highlightedBackgroundImageWithBackgroundImage: backgroundImage];
            [self setBackgroundImage: highlightedBackgroundImage forState: UIControlStateHighlighted];
        }
    }
}

#pragma mark -
#pragma mark Image Generation Methods
- (UIImage *)backgroundImage
{
    //Begin a new image context to draw directly to
    if( IS_RETINA )
        UIGraphicsBeginImageContextWithOptions( self.frame.size, NO, 2.0f);
    else
        UIGraphicsBeginImageContext( self.frame.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    TCDrawBeveledRoundedRect(context, self.bounds, radius, [UIColor whiteColor]);
    
    //save the context out to an image
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    //Release the context Resources
    UIGraphicsEndImageContext();
    
    return output;
}

- (UIImage *)highlightedBackgroundImageWithBackgroundImage:(UIImage *)backgroundImage
{
    if( IS_RETINA )
        UIGraphicsBeginImageContextWithOptions( backgroundImage.size, NO, 2.0f);
    else
        UIGraphicsBeginImageContext( backgroundImage.size );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake(1, 1, backgroundImage.size.width-2, backgroundImage.size.height-2 );
    
    [backgroundImage drawAtPoint: CGPointZero];
    
    CGPoint startPoint = CGPointMake( CGRectGetMidX(drawRect), CGRectGetMinY(drawRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(drawRect), CGRectGetMaxY(drawRect));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef startColor = [[UIColor colorWithRed: 0.0f green: 145.0f/255.0f blue: 248.0f/255.0f alpha: 1.0f] CGColor];
    CGColorRef endColor = [[UIColor colorWithRed: 0.0f green: 103.0f/255.0f blue: 233.0f/255.0f alpha: 1.0f] CGColor];
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPathRef path = TCPathForRoundedRectWithRect(drawRect, radius );
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path );
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}

@end
