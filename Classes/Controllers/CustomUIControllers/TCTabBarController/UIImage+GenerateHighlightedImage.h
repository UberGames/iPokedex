//
//  UIImage+GenerateHighlightedImage.h
//  iPokedex
//
//  Created by Timothy Oliver on 21/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (GenerateHighlightedImage)

- (UIImage *)highlightedImage;
+ (UIImage *)highlightedImageWithImage: (UIImage *)image;

@end
