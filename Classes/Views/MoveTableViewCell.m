//
//  MoveTableViewCell.m
//  iPokedex
//
//  Created by Timothy Oliver on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoveTableViewCell.h"


@implementation MoveTableViewCell

@synthesize typeImageView, categoryImageView, typeID, categoryID, power, powerValueLabel, accuracy, accuracyValueLabel, PP, PPValueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    //override the style. It MUST be a caption cell
	if ((self = [super initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
		
		//Set style to have drill down icon on the right side
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		self.typeImageView = [[UIImageView alloc] initWithFrame: CGRectMake( 9, 7, 32, 14 )];
		self.categoryImageView = [[UIImageView alloc] initWithFrame: CGRectMake( 9, 22, 32, 14 )];
		
		//image views
		self.typeImageView = [[UIImageView alloc] initWithFrame: CGRectMake( 9, 7, 32, 14 )];
		[self.contentView addSubview: typeImageView];
		
		self.categoryImageView = [[UIImageView alloc] initWithFrame: CGRectMake( 9, 23, 32, 14 )];
		[self.contentView addSubview: categoryImageView];
	
		UIView *containerView = [[UIView alloc] initWithFrame: CGRectMake( 200, 7, 105, 33 )];
		containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		
		//Power Label
		UILabel *powerLabel = [[UILabel alloc] initWithFrame: CGRectMake( 0, 0, 30, 11 )];
		powerLabel.textColor = [UIColor colorWithRed: 28.0f/255.0f green: 126.0f / 255.0f blue: 205.0f / 255.0f alpha: 1.0f ];
		powerLabel.highlightedTextColor = [UIColor whiteColor];
		powerLabel.textAlignment = UITextAlignmentCenter;
		powerLabel.text = @"PWR";
		powerLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
		[containerView addSubview: powerLabel];
		[powerLabel release];
		
		self.powerValueLabel = [[UILabel alloc] initWithFrame: CGRectMake( 0, 11, 30, 20 )];
		powerValueLabel.textColor = [UIColor blackColor];
		powerValueLabel.highlightedTextColor = [UIColor whiteColor];
		powerValueLabel.textAlignment = UITextAlignmentCenter;
		powerValueLabel.text = @"-";
		powerValueLabel.font = [UIFont systemFontOfSize: 14.0f];
		[containerView addSubview: powerValueLabel];
		
		//Accuracy Label
		UILabel *accuracyLabel = [[UILabel alloc] initWithFrame: CGRectMake( 35, 0, 40,11 )];
		accuracyLabel.text = @"ACC";
		accuracyLabel.textAlignment = UITextAlignmentCenter;
		accuracyLabel.highlightedTextColor = [UIColor whiteColor];
		accuracyLabel.textColor = [UIColor colorWithRed: 28.0f/255.0f green: 126.0f / 255.0f blue: 205.0f / 255.0f alpha: 1.0f ];
		accuracyLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
		[containerView addSubview: accuracyLabel];
		[accuracyLabel release];
		
		self.accuracyValueLabel = [[UILabel alloc] initWithFrame: CGRectMake( 35, 11, 40, 20 )];
		accuracyValueLabel.textColor = [UIColor blackColor];
		accuracyValueLabel.highlightedTextColor = [UIColor whiteColor];
		accuracyValueLabel.textAlignment = UITextAlignmentCenter;
		accuracyValueLabel.text = @"-";
		accuracyValueLabel.font = [UIFont systemFontOfSize: 14.0f];
		[containerView addSubview: accuracyValueLabel];
		
		//PP Label
		UILabel *ppLabel = [[UILabel alloc] initWithFrame: CGRectMake( 75, 0, 20, 11 )];
		ppLabel.text = @"PP";
		ppLabel.textAlignment = UITextAlignmentCenter;
		ppLabel.highlightedTextColor = [UIColor whiteColor];
		ppLabel.textColor = [UIColor colorWithRed: 28.0f/255.0f green: 126.0f / 255.0f blue: 205.0f / 255.0f alpha: 1.0f ];
		ppLabel.font = [UIFont boldSystemFontOfSize: 12.0f];
		[containerView addSubview: ppLabel];
		[ppLabel release];
		
		self.PPValueLabel = [[UILabel alloc] initWithFrame: CGRectMake( 75, 11, 20, 20 )];
		PPValueLabel.textColor = [UIColor blackColor];
		PPValueLabel.highlightedTextColor = [UIColor whiteColor];
		PPValueLabel.textAlignment = UITextAlignmentCenter;
		PPValueLabel.text = @"-";
		PPValueLabel.font = [UIFont systemFontOfSize: 14.0f];
		[containerView addSubview: PPValueLabel];
		
		[self.contentView addSubview: containerView];
		[containerView release];
	}
	
	return self;
}

-(void) layoutSubviews
{
	[super layoutSubviews];
	
	//offset the text labels
	self.textLabel.frame = CGRectMake( self.textLabel.frame.origin.x + 37, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height );
	self.detailTextLabel.frame = CGRectMake( self.detailTextLabel.frame.origin.x + 37, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height );
}

-(void) setPower: (NSInteger)newPower
{
	if( newPower == power )
		return;
	
	power = newPower;
	
	if( newPower == 0 )
		powerValueLabel.text = @"-";
	else
		powerValueLabel.text = [NSString stringWithFormat: @"%i", newPower ];
}

-(void) setAccuracy:(NSInteger)newAccuracy
{
	if( newAccuracy == accuracy )
		return;
	
	accuracy = newAccuracy;
	
	if( newAccuracy == 0 )
		accuracyValueLabel.text = @"-";
	else
		accuracyValueLabel.text = [NSString stringWithFormat: @"%i%%", newAccuracy ];
}

-(void) setPP: (NSInteger)newPP
{
	if( newPP == PP )
		return;
	
	PP = newPP;
	
	if( newPP == 0 )
		PPValueLabel.text = @"-";
	else
		PPValueLabel.text = [NSString stringWithFormat: @"%i", newPP ]; 
}

-(void) dealloc
{
	[typeImageView release];
	[categoryImageView release];
	[powerValueLabel release];
	[accuracyValueLabel release];
	[PPValueLabel release];
	
	[super dealloc];
}

@end
