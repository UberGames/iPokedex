//
//  TCTableViewCell.m
//  iPokedex
//
//  Created by Timothy Oliver on 17/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TCTableViewCell

@synthesize drawView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if( (self = [super initWithStyle:style reuseIdentifier: reuseIdentifier]) )
	{
		
	}
	
	return self;
}

- (void)setDrawView:(UIView *)newDrawView
{
    if( [drawView isEqual: newDrawView] )
        return;
    
    [drawView removeFromSuperview];
    
    [drawView release];
    drawView = [newDrawView retain];
    
    //add it to the table view contentView
    [self.contentView addSubview: drawView];
}

-(void) setEditing: (BOOL)editing animated: (BOOL)animated
{
	[super setEditing: editing animated: animated];
	
    if( animated == NO )
        return;
    
	CATransition *animation = [CATransition animation];
	animation.duration = 0.25f;
	animation.type = kCATransitionFade;
	
	//redraw the subviews (and animate)
	for( UIView *subview in self.contentView.subviews )
	{
		[subview.layer addAnimation: animation forKey: @"editingFade"];
		[subview setNeedsDisplay];
	}
}

- (void)dealloc
{
    [drawView release];
    [super dealloc];
}


@end
