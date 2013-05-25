//
//  UIImage+GenerateHighlightedImage.m
//  iPokedex
//
//  Created by Timothy Oliver on 21/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "UIImage+GenerateHighlightedImage.h"
#import "UIScreen+isRetinaDisplay.h"

@implementation UIImage (GenerateHighlightedImage)

- (UIImage *)highlightedImage
{
    return [UIImage highlightedImageWithImage: self];
}

+ (UIImage *)highlightedImageWithImage: (UIImage *)_image
{
	CGRect bounds = CGRectMake( 0, 0, _image.size.width, _image.size.height);
	
    //set up the Quartz context. check if this is a retina device
    if( [[UIScreen mainScreen] isRetinaDisplay] )
        UIGraphicsBeginImageContextWithOptions( bounds.size, NO, 2.0f );
    else
        UIGraphicsBeginImageContext( bounds.size );

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// flip the graphics context so the CG co-ord system matches UI
	CGContextTranslateCTM(context, 0, bounds.size.height );
	CGContextScaleCTM(context, 1.0, -1.0);
	
	//set the fill color to white, set the transparency and fill it
	[[UIColor whiteColor] setFill];
	CGContextClipToMask(context, bounds, [_image CGImage]);
	CGContextFillRect(context, bounds );
	
	//return the new image to a new UIImage object and close the context
	UIImage *_highlightedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return _highlightedImage;
}

@end
