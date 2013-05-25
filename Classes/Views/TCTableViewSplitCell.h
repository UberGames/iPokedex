//
//  UITableViewSplitCell.h
//  iPokedex
//
//  Created by Timothy Oliver on 12/01/11.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//delegate method
@protocol TableViewSplitCellDelegate;

@interface TCTableViewSplitCell : UIView {
	NSString *defaultText;
	UIColor *borderColor;
    
    CGFloat cellWidth;
    NSInteger numberOfCells;
    NSInteger numberOfLines;

    BOOL highlighted;
    NSInteger tappedCell;
    
    id <TableViewSplitCellDelegate> delegate;
}

-(void)drawInCellIndex: (NSInteger) index withRect: (CGRect)rect withContext:(CGContextRef)context;

@property (nonatomic, retain) NSString *defaultText;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nonatomic, assign) NSInteger selectedCell;
@property (nonatomic, assign) NSInteger tappedCell;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) id delegate;

@end

@protocol TableViewSplitCellDelegate

-(BOOL)splitTableCell: (TCTableViewSplitCell *)splitCell indexCanBeTapped: (NSInteger) index;
-(void)splitTableCellTapped: (TCTableViewSplitCell *)splitCell withIndex: (NSInteger)index;

@end