//
//  TableCellContentView.h
//  iPokedex
//
//  Created by Timothy Oliver on 5/03/11.
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

#define TABLECONTENTCELL_DEFAULT_INSET 40
#define TABLECONTENTCELL_DEFAULT_TITLESIZE 22
#define TABLECONTENTCELL_DEFAULT_SUBTITLESIZE 14

@interface TableCellContentView : UIView {
    UIImage     *icon;
    
    NSString	*title;
	NSString	*subTitle;
	
	BOOL highlighted;
    BOOL subTitleIsMultiline;
	
	NSArray *versionStrings;
	NSArray *versionColors;	
	
	NSInteger titleInset;
	NSInteger titleWidth;
	
	NSInteger titleSize;
	NSInteger subTitleSize;
}

- (CGFloat)height;
+ (CGFloat)heightWithSubtitleText: (NSString *)subtitleText withSubTitleSize: (CGFloat)subtitleSize forWidth: (CGFloat)width;

@property (nonatomic, retain) UIImage     *icon;
@property (nonatomic, retain) NSString	*title;
@property (nonatomic, retain) NSString	*subTitle;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL subTitleIsMultiline;
@property (nonatomic, retain) NSArray *versionStrings;
@property (nonatomic, retain) NSArray *versionColors;
@property (nonatomic, assign) NSInteger titleInset;
@property (nonatomic, assign) NSInteger titleWidth;
@property (nonatomic, assign) NSInteger titleSize;
@property (nonatomic, assign) NSInteger subTitleSize;

@end
