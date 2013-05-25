//
//  MoveTableCellContentView.h
//  iPokedex
//
//  Created by Timothy Oliver on 15/02/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import <UIKit/UIKit.h>
#import "TableCellContentView.h"

@interface MoveTableCellContentView : TableCellContentView {
	
	UIImage *typeImage;
	UIImage *categoryImage;
	
	NSInteger typeID;
	NSInteger categoryID;
	
	NSInteger power;
	NSString *powerTitle;
	NSString *powerValue;
	
	NSInteger accuracy;
	NSString *accuracyTitle;
	NSString *accuracyValue;
	
	NSInteger PP;
	NSString *PPTitle;
	NSString *PPValue;
}

@property (nonatomic, retain) UIImage *typeImage;
@property (nonatomic, retain) UIImage *categoryImage;

@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, assign) NSInteger categoryID;

@property (nonatomic, assign) NSInteger power;
@property (nonatomic, copy) NSString *powerTitle;
@property (nonatomic, copy) NSString *powerValue;

@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, copy) NSString *accuracyTitle;
@property (nonatomic, copy) NSString *accuracyValue;

@property (nonatomic, assign) NSInteger PP;
@property (nonatomic, copy) NSString *PPTitle;
@property (nonatomic, copy) NSString *PPValue;

@end
