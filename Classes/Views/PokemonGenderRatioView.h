//
//  PokemonGenderRatioView.h
//  iPokedex
//
//  Created by Timothy Oliver on 16/01/11.
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

#define GENDER_RATIO_CELL_HEIGHT 68;
#define GENDER_RATIO_CELL_HEIGHT_GENDERLESS	45;

#define GENDER_RATIO_TITLE_Y 4


@interface PokemonGenderRatioView : UIView {
	UIImage *maleBarImage;
    UIImage *femaleBarImage;
    
    NSInteger genderRate;
	
	NSString *maleText;
	NSString *femaleText;
	
	UILabel *genderlessLabel;
	
	CGFloat maleRatio;
	CGFloat femaleRatio;
}

-(NSInteger) cellHeight;

@property (nonatomic, retain) UIImage *maleBarImage;
@property (nonatomic, retain) UIImage *femaleBarImage;
@property (nonatomic, assign) NSInteger genderRate;
@property (nonatomic, retain) UILabel *genderlessLabel;
@property (nonatomic, retain) NSString *maleText;
@property (nonatomic, retain) NSString *femaleText;
@property (nonatomic, assign) CGFloat maleRatio;
@property (nonatomic, assign) CGFloat femaleRatio;

@end
