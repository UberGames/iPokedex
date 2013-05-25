//
//  ItemTableCell.m
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

#import "ItemTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define BUY_X 0
#define SELL_X 45

@implementation ItemTableViewCell
	
@synthesize defaultIcon, sellValueText, buyValueText, sellPrice, pokeDollarIcon, pokeDollarIconHighlighted, buyPokeDollarIconView, sellPokeDollarIconView, buyable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    //override the style. It MUST be a caption cell
	if ((self = [super initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
		
		//Set style to have drill down icon on the right side
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		//Make the font size bigger
		self.textLabel.font	= [UIFont boldSystemFontOfSize: 20];		
		
		//create the container view
		UIView *containerView = [[UIView alloc] initWithFrame: CGRectMake( 205, 6, 90, 35 )];
		containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		
		// 'Buy' Label
		UILabel *buyText = [[UILabel alloc] initWithFrame: CGRectMake( BUY_X, 0, 50, 15 )];
		buyText.textColor = [UIColor colorWithRed: 28.0f/255.0f green: 126.0f / 255.0f blue: 205.0f / 255.0f alpha: 1.0f ];
		buyText.highlightedTextColor = [UIColor whiteColor];
		buyText.textAlignment = UITextAlignmentCenter;
		buyText.text = @"Buy";
		buyText.font = [UIFont boldSystemFontOfSize: 13.0f];
		[containerView addSubview: buyText];
		[buyText release];
		
		// 'Sell' Label
		UILabel *sellText = [[UILabel alloc] initWithFrame: CGRectMake( SELL_X, 0, 50, 15 )];
		sellText.text = @"Sell";
		sellText.textAlignment = UITextAlignmentCenter;
		sellText.highlightedTextColor = [UIColor whiteColor];
		sellText.textColor = [UIColor colorWithRed: 28.0f/255.0f green: 126.0f / 255.0f blue: 205.0f / 255.0f alpha: 1.0f ];
		sellText.font = [UIFont boldSystemFontOfSize: 13.0f];
		[containerView addSubview: sellText];
		[sellText release];
		
		// 9999
		self.buyValueText = [[UILabel alloc] initWithFrame: CGRectMake( BUY_X, 16, 50, 15 )];
		self.buyValueText.textAlignment = UITextAlignmentCenter;
		self.buyValueText.textColor = [UIColor blackColor];
		self.buyValueText.highlightedTextColor = [UIColor whiteColor];
		self.buyValueText.font = [UIFont systemFontOfSize: 14.0f];
		[containerView addSubview: buyValueText];		
		
		// 9999
		self.sellValueText = [[UILabel alloc] initWithFrame: CGRectMake( SELL_X, 16, 50, 15 )];
		self.sellValueText.textColor = [UIColor blackColor];
		self.sellValueText.highlightedTextColor = [UIColor whiteColor];
		self.sellValueText.textAlignment= UITextAlignmentCenter;
		self.sellValueText.font = [UIFont systemFontOfSize: 14.0f];
		[containerView addSubview: sellValueText];
		
		//load GFX assets
		NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
		
		//load a dummy image (Will be cached from each call after this)
		UIImage *dummyImage = [[UIImage alloc] initWithContentsOfFile: [resourcePath stringByAppendingPathComponent: @"Images/Items/unknown.png"]];
		self.defaultIcon = dummyImage;
		[dummyImage release];
		
		//load the pokedollar graphics
		self.pokeDollarIcon = [[UIImage alloc] initWithContentsOfFile: [resourcePath stringByAppendingPathComponent: @"Images/Interface/PokemonDollar.png"]];
		self.pokeDollarIconHighlighted = [[UIImage alloc] initWithContentsOfFile: [resourcePath stringByAppendingPathComponent: @"Images/Interface/PokemonDollarHighlighted.png"]];
		
		//init the icon placeholder views
		self.buyPokeDollarIconView = [[UIImageView alloc] initWithFrame: CGRectMake( 0, 0, pokeDollarIcon.size.width, pokeDollarIcon.size.height )];
		buyPokeDollarIconView.image = pokeDollarIcon;
		buyPokeDollarIconView.highlightedImage = pokeDollarIconHighlighted;
		[containerView addSubview: buyPokeDollarIconView];
		
		self.sellPokeDollarIconView = [[UIImageView alloc] initWithFrame: CGRectMake( 0, 0, pokeDollarIcon.size.width, pokeDollarIcon.size.height )];
		sellPokeDollarIconView.image = pokeDollarIcon;
		sellPokeDollarIconView.highlightedImage = pokeDollarIconHighlighted;
		[containerView addSubview: sellPokeDollarIconView];
		
		[self.contentView addSubview: containerView];
        [containerView release];
	}	
	
	return self;
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	
	//set up the text
	if( self.buyable && self.sellPrice > 0 )
	{
		self.buyValueText.text = [NSString stringWithFormat: @"%i", self.sellPrice*2];
		self.buyValueText.frame = CGRectMake( BUY_X + (self.buyPokeDollarIconView.frame.size.width / 2), self.buyValueText.frame.origin.y, self.buyValueText.frame.size.width, self.buyValueText.frame.size.height );
		self.buyValueText.textAlignment = UITextAlignmentCenter;
		
		//calc the x location to place the poke dollar graphic
		CGSize labelSize = [self.buyValueText.text sizeWithFont: self.buyValueText.font];
		NSInteger x = (self.buyValueText.center.x - (labelSize.width/2)) - buyPokeDollarIconView.frame.size.width;
		
		self.buyPokeDollarIconView.frame = CGRectMake( x, self.buyValueText.frame.origin.y+1, buyPokeDollarIconView.frame.size.width, buyPokeDollarIconView.frame.size.height );
		[buyPokeDollarIconView setHidden: NO];
	}
	else 
	{
		self.buyValueText.frame = CGRectMake( BUY_X, buyValueText.frame.origin.y, buyValueText.frame.size.width, buyValueText.frame.size.height );
		self.buyValueText.text = @"-";
		[buyPokeDollarIconView setHidden: YES];
	}
		
	if( self.sellPrice > 0 )
	{
		self.sellValueText.text = [NSString stringWithFormat: @"%i", self.sellPrice];
		self.sellValueText.frame = CGRectMake( SELL_X + (self.sellPokeDollarIconView.frame.size.width / 2), self.buyValueText.frame.origin.y, self.buyValueText.frame.size.width, self.buyValueText.frame.size.height );
		self.sellValueText.textAlignment = UITextAlignmentCenter;
		
		//calc the x location to place the poke dollar graphic
		CGSize labelSize = [self.sellValueText.text sizeWithFont: self.sellValueText.font];
		NSInteger x = (self.sellValueText.center.x - (labelSize.width/2)) - sellPokeDollarIconView.frame.size.width;
		
		self.sellPokeDollarIconView.frame = CGRectMake( x, self.sellValueText.frame.origin.y+1, sellPokeDollarIconView.frame.size.width, sellPokeDollarIconView.frame.size.height );
		[sellPokeDollarIconView setHidden: NO];		
	}
	else 
	{
		self.sellValueText.frame = CGRectMake( SELL_X, sellValueText.frame.origin.y, sellValueText.frame.size.width, sellValueText.frame.size.height );
		self.sellValueText.text = @"-";
		[sellPokeDollarIconView setHidden: YES];
	}
}

- (void) resetIcon
{
	self.imageView.image = self.defaultIcon;
}

-(void) dealloc
{
	[defaultIcon release];
	[sellValueText release];
	[buyValueText release];
	[pokeDollarIcon release];
	[pokeDollarIconHighlighted release];
	[buyPokeDollarIconView release];
	[sellPokeDollarIconView release];
	
	[super dealloc];
}

@end
