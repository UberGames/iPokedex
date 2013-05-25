//
//  TCTableViewCell.h
//  iPokedex
//
//  Created by Timothy Oliver on 17/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCTableViewCell : UITableViewCell {
    //A reference to the CG view inside the contentView
    UIView *drawView;
}

@property (nonatomic, retain) UIView *drawView;

@end
