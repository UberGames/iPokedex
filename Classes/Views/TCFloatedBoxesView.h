//
//  TCFloatedBoxesView.h
//  iPokedex
//
//  Created by Timothy Oliver on 6/02/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//	A wrapper class. This class takes a series of views
//	and displays them horizontally along a view, whilst wrapping
//	to a new line as needed.
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


@interface TCFloatedBoxesView : UIView {
	NSInteger numberOfItems;
	NSInteger itemsPerLine;
	
	NSInteger frameHeight;
	
	NSInteger itemWidth;
	NSInteger itemHeight;
	
	NSInteger minWidthPadding;
	NSInteger heightPadding;
    
    BOOL highlighted;
}

-(void) drawInItemRect: (CGRect)rect forIndex: (NSInteger) index withContext: (CGContextRef) context;

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger itemsPerLine; //Number of views per line
@property (nonatomic, assign) NSInteger frameHeight; //the endheight of this view
@property (nonatomic, assign) NSInteger itemWidth; //the width of all subview
@property (nonatomic, assign) NSInteger itemHeight; //the height
@property (nonatomic, assign) NSInteger minWidthPadding; //minimum of padding to place between each view
@property (nonatomic, assign) NSInteger heightPadding; //height padding
@property (nonatomic, assign) BOOL highlighted;

@end
