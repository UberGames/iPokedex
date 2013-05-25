//
//  TCQuartzFunctions.m
//  iPokedex
//
//  Created by Timothy Oliver on 8/02/11.
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

#import "TCQuartzFunctions.h"


CGMutablePathRef TCPathForRoundedRectWithRect( CGRect rrect, CGFloat radius )
{
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
	if (radius > height/2.0)
		radius = height/2.0;    
	
	CGFloat minx = CGRectGetMinX(rrect);
	CGFloat midx = CGRectGetMidX(rrect);
	CGFloat maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect);
	CGFloat midy = CGRectGetMidY(rrect);
	CGFloat maxy = CGRectGetMaxY(rrect);
	
	CGMutablePathRef path = CGPathCreateMutable();
	
	CGPathMoveToPoint(path, NULL, minx, midy);
	CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, radius);
	CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, radius);
	CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, radius);
	CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, radius);
	CGPathCloseSubpath(path);
	
	return path;
}

void TCDrawRoundedRect( CGContextRef context, CGRect rect, CGFloat radius, UIColor *fillColor )
{
	CGContextSaveGState(context);
	
	CGMutablePathRef path = TCPathForRoundedRectWithRect( rect, radius );
	CGContextAddPath( context, path );
	CGContextSetFillColorWithColor(context, fillColor.CGColor);
	CGContextFillPath(context);
	CGPathRelease(path);
	
	CGContextRestoreGState(context);
}

void TCDrawRoundedRectWithStroke( CGContextRef context, CGRect rect, CGFloat radius, NSInteger strokeWidth, UIColor *fillColor, UIColor *strokeColor )
{
	CGRect drawRect = CGRectInset(rect, strokeWidth, strokeWidth);
	
	CGContextSaveGState(context);
	
	//Set draw parameters
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
	
	//get the path 
	CGMutablePathRef path = TCPathForRoundedRectWithRect( drawRect, radius );
	
    //draw the path to the context
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    //draw the stroke *outside* of the boundary
    path = TCPathForRoundedRectWithRect( CGRectInset(drawRect, -(strokeWidth*0.5f), -(strokeWidth*0.5f)), radius );
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextStrokePath( context );
    CGContextRestoreGState( context );
	
	CGPathRelease(path);
	CGContextRestoreGState( context );
}

void TCDrawBeveledRoundedRect( CGContextRef context, CGRect rect, CGFloat radius, UIColor *fillColor )
{
    //contract the bounds of the rectangle in to account for the stroke
    CGRect drawRect = CGRectInset(rect, 1.0f, 1.0f);
    
	//contract the height by 1 to account for the white bevel at the bottom
    drawRect.size.height -= 1.0f;
    
    //Save the current state so we don't persist anything beyond this operation
	CGContextSaveGState(context);

    //Generate the rounded rectangle paths
    CGPathRef boxPath = [[UIBezierPath bezierPathWithRoundedRect: drawRect cornerRadius: radius] CGPath];
    //For the stroke, offset by half a pixel to ensure proper drawing
    CGPathRef strokePath = [[UIBezierPath bezierPathWithRoundedRect: CGRectInset(drawRect, -0.5f, -0.5f) cornerRadius: radius] CGPath];
    
    /*Draw the bevel effect*/
    CGContextSaveGState(context);
    //Set the color to be slightly transparent white
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 1.0f alpha: 0.8f] CGColor]);
    //Clip the region to only the visible portion to optimzie drawing
    CGContextClipToRect(context, CGRectMake(rect.origin.x, rect.origin.y+rect.size.height-radius, rect.size.width, radius));
    //draw the left corner curve
    CGRect corner = CGRectMake(rect.origin.x, (rect.origin.y+rect.size.height)-(2*radius)-1, (radius*2)+1, (radius*2)+1);
    CGContextFillEllipseInRect(context, corner);
    //draw the right corner
    corner.origin.x = rect.origin.x + rect.size.width - (radius*2)-1;
    CGContextFillEllipseInRect(context, corner);
    //draw the rectangle in the middle
    //set the blend mode to replace any existing pixels (or else we'll see visible overlap)
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextFillRect(context, CGRectMake(rect.origin.x+radius, rect.origin.y+rect.size.height-radius, rect.size.width-(2*radius),radius+1));
    CGContextRestoreGState(context);
    
    /*Draw the main region */
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGContextAddPath(context, boxPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    /*Main fill region inner drop shadow*/
    /*(This is done by duplicating the path, offsetting the duplicate by 1 pixel, and using the EO winding fill rule to fill the gap between the two)*/
    CGContextSaveGState(context);
    //set the colour to be a VERY faint grey
    CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite: 0.0f alpha: 0.08f] CGColor]);
    //clip the shadow to the top of the box (to reduce overhead)
    CGContextClipToRect(context, CGRectMake( drawRect.origin.x, drawRect.origin.y, drawRect.size.width, radius ));
    //add the first instance of the path
    CGContextAddPath(context, boxPath);
    //translate the draw origin down by 1 pixel
    CGContextTranslateCTM(context, 0.0f, 1.0f);
    //add the second instance of the path
    CGContextAddPath(context, boxPath);
    //use the EO winding rule to fill the gap between the two paths
    CGContextEOFillPath(context);
    CGContextRestoreGState(context);
    
    /*Outer Stroke*/
    /*This is drawn outside of the fill region to prevent the fill region bleeding over in some cases*/
    CGContextSaveGState(context);
    //set the line width to be 1 pixel
    CGContextSetLineWidth(context, 1.0f);
    //set the the colour to be a very transparent shade of grey
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithWhite: 0.0f alpha: 0.18f] CGColor]);
    //set up the path to draw the stroke along
    CGContextAddPath(context, strokePath);
    //set the blending mode to replace underlying pixels on this layer (so the background will come through through)
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    //draw the path
    CGContextStrokePath(context);
    CGContextRestoreGState( context );
    
    //Restore the previous CG state
	CGContextRestoreGState( context );
}
