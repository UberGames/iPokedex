//
//  UITableViewCellStyle2.m
//  iPokedex
//
//  Created by Timothy Oliver on 20/01/11.
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

#import "UITableViewCellStyle2.h"

@implementation UITableViewCellStyle2

@synthesize text2Label;

- initWithReuseIdentifier: (NSString *)identifier
{
	if( (self = [super initWithStyle: UITableViewCellStyleValue2 reuseIdentifier: identifier]) )
	{
		
	}
	
	return self;
}

- (UILabel *)text2Label
{
    if( text2Label == nil )
    {
        text2Label = [[UILabel alloc] initWithFrame: CGRectMake( 60, 22, 195, 25 )];
        text2Label.font = [UIFont boldSystemFontOfSize: 17.0f];
        text2Label.highlightedTextColor = [UIColor whiteColor];
        text2Label.textAlignment = UITextAlignmentLeft;
    }
    [self.contentView addSubview: text2Label];
   
    return text2Label;
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	
	//expand the detail textlabel
	CGRect detailRect = self.textLabel.frame;
	detailRect.size.width += 10;
	detailRect.origin.x -= 10;
    
    if( [text2Label.text length] )
        detailRect.origin.y = 16;
        
	self.textLabel.frame = detailRect;
    
    if ( [text2Label.text length] )
    {
        CGRect textRect = self.detailTextLabel.frame;
        textRect.origin.y = 11;
        self.detailTextLabel.frame = textRect;
        
        CGSize sizeOfText = [self.text2Label.text sizeWithFont: self.text2Label.font];
        textRect.origin.y = 33;
        textRect.size.width = sizeOfText.width;
        self.text2Label.frame = textRect;
    }
}

- (void)dealloc
{
    [text2Label release];
    [super dealloc];
}

@end
