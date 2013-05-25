//
//  UIImage+ImageLoading.m
//  iPokedex
//
//  Created by Timothy Oliver on 10/02/11.
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

#import "UIImage+ImageLoading.h"
#import "UIScreen+isRetinaDisplay.h"

@implementation UIImage (ImageLoading)

//if device has retina capability (eg iPhone 4, iPod 4, iPad with RetinaPad >XD), force it to load the @2x asset
+ (NSString *) retinaFileFromFile:(NSString *)aFileName
{
    if( [[UIScreen mainScreen] isRetinaDisplay] == NO )
        return aFileName;

    NSString *retinaPath = [aFileName stringByReplacingOccurrencesOfString: @".png" withString: @""];
    retinaPath = [retinaPath stringByAppendingString: @"@2x.png"];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath: retinaPath] )
        aFileName = retinaPath;

    return aFileName;
}

+ (UIImage*)imageFromMainBundleFile:(NSString*)aFileName {
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [UIImage retinaFileFromFile: bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath,aFileName]];
}

+ (UIImage *)imageFromResourcePath: (NSString*) aFileName
{
	NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: aFileName];
    resourcePath = [UIImage retinaFileFromFile: resourcePath];
	return [UIImage imageWithContentsOfFile: resourcePath];
}

@end
