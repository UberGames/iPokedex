//
//  MoveTableViewCell.h
//  iPokedex
//
//  Created by Timothy Oliver on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MoveTableViewCell : UITableViewCell {
	UIImageView *typeImageView;
	UIImageView *categoryImageView;
	
	NSInteger typeID;
	NSInteger categoryID;
	
	NSInteger power;
	UILabel *powerValueLabel;
	
	NSInteger accuracy;
	UILabel *accuracyValueLabel;
	
	NSInteger PP;
	UILabel *PPValueLabel;
}

@property (nonatomic, retain) UIImageView *typeImageView;
@property (nonatomic, retain) UIImageView *categoryImageView;
@property (nonatomic, assign) NSInteger typeID;
@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, assign) NSInteger power;
@property (nonatomic, retain) UILabel *powerValueLabel;
@property (nonatomic, assign) NSInteger accuracy;
@property (nonatomic, retain) UILabel *accuracyValueLabel;
@property (nonatomic, assign) NSInteger PP;
@property (nonatomic, retain) UILabel *PPValueLabel;

@end
