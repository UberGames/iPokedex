//
//  MoveProfileMainViewController.h
//  iPokedex
//
//  Created by Tim Oliver on 28/02/11.
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
#import "Move.h"
#import "TableHeaderContentView.h"
#import "TextBoxContentView.h"
#import "TitledTextBoxContentView.h"
#import "TCTableViewStatsSplitCell.h"
#import "MoveFlagsContentView.h"
#import "MoveExternalLinksView.h"
#import "Generations.h"

@interface MoveProfileMainViewController : UITableViewController {
	//Database content
	NSInteger dbID;
	Move *move;
    Generation *moveGeneration;
	
	//Content Views
	TextBoxContentView *flavorTextView;
    TitledTextBoxContentView *effectTextView;
	TCTableViewStatsSplitCell *moveStatsView;
	MoveFlagsContentView *flagsView;
    MoveExternalLinksView *externalLinksView;
}

- (id)initWithDatabaseID: (NSInteger) databaseID;

@property (nonatomic, assign) NSInteger dbID;
@property (nonatomic, retain) Move *move;
@property (nonatomic, retain) Generation *moveGeneration;

@property (nonatomic, retain) TextBoxContentView *flavorTextView;
@property (nonatomic, retain) TitledTextBoxContentView *effectTextView;
@property (nonatomic, retain) TCTableViewStatsSplitCell *moveStatsView;
@property (nonatomic, retain) MoveFlagsContentView *flagsView;
@property (nonatomic, retain) MoveExternalLinksView *externalLinksView;

@end