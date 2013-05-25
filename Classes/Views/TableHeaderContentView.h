//
//  TableHeaderContentView.h
//  iPokedex
//
//  Created by Timothy Oliver on 2/03/11.
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


@interface TableHeaderContentView : UIView {
	NSString *title;
	NSString *subTitle;

    NSString *generation;
    
	UIImage *icon1;
	UIImage *icon2;
	NSInteger iconMargin;
	
	NSInteger contentIndent;
	NSInteger lineSpacing;
	
	NSInteger titleSize;
	NSInteger subTitleSize;
	NSInteger generationSize;
    
	NSInteger heightPadding;
	UITextAlignment alignment;	
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *generation;

@property (nonatomic, retain) UIImage *icon1;
@property (nonatomic, retain) UIImage *icon2;
@property (nonatomic, assign) NSInteger iconMargin;

@property (nonatomic, assign) NSInteger contentIndent;
@property (nonatomic, assign) NSInteger lineSpacing;

@property (nonatomic, assign) NSInteger titleSize;
@property (nonatomic, assign) NSInteger subTitleSize;
@property (nonatomic, assign) NSInteger generationSize;

@property (nonatomic, assign) UITextAlignment alignment;

@property (nonatomic, assign) NSInteger heightPadding;
@property (nonatomic, readonly) NSInteger height;

@end
