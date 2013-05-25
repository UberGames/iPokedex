//
//  ItemTableCell.h
//  iPokedex
//
//  Created by Timothy Oliver on 23/12/10.
//  Copyright 2010 UberGames. All rights reserved.
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

#import <Foundation/Foundation.h>


@interface ItemTableViewCell : UITableViewCell {
	UIImage *defaultIcon;

	UILabel *buyValueText;
	UILabel *sellValueText;
	
	UIImageView *sellPokeDollarIconView;
	UIImageView *buyPokeDollarIconView;
	
	UIImage *pokeDollarIcon;
	UIImage *pokeDollarIconHighlighted;
	
	NSInteger sellPrice;
	BOOL buyable;
}

- (void) resetIcon;

@property (nonatomic, retain) UIImage *defaultIcon;
@property (nonatomic, retain) UILabel *sellValueText;
@property (nonatomic, retain) UILabel *buyValueText;
@property (nonatomic, retain) UIImage *pokeDollarIcon;
@property (nonatomic, retain) UIImage *pokeDollarIconHighlighted;
@property (nonatomic, retain) UIImageView *sellPokeDollarIconView;
@property (nonatomic, retain) UIImageView *buyPokeDollarIconView;
@property (nonatomic, assign) NSInteger sellPrice;
@property (nonatomic, assign) BOOL buyable;

@end
