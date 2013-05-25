//
//  PokemonInfoViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 29/12/10.
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "Pokemon.h"
#import "TCTableViewCell.h"

#ifdef PRIVATE_APIS_ARE_COOL
#import "iPokedexSpeechSynthesizer.h"
#endif

@interface PokemonProfileMainViewController : UITableViewController <UIActionSheetDelegate> {
	NSInteger dbID;
	Pokemon *pokemon;
	
    //values for the dex names
    NSArray *dexNumbersTitles;
    NSArray *dexNumbersValues;
    
    NSArray *weightHeightTitles;
    NSArray *weightHeightValues;
    
    NSArray *extraStatsTitles;
    NSArray *extraStatsValues;
    
    NSArray *extra2StatsTitles;
    NSArray *extra2StatsValues;

    TCTableViewCell *genderTableCell;
    TCTableViewCell *evTableCell;
    TCTableViewCell *linksTableCell;
    
	UIActionSheet *eggGroupPrompt;
	UIActionSheet *abilityPrompt;
    
    NSString *cryFilePath;
    AVAudioPlayer *cryPlayer;
    
#ifdef PRIVATE_APIS_ARE_COOL
    iPokedexSpeechSynthesizer *pokedexSpeech;
#endif
    
}

- (id)initWithDatabaseID: (NSInteger) databaseID;
- (void)cryButtonPressed: (id)sender;

#ifdef PRIVATE_APIS_ARE_COOL
- (void)speechButtonPressed: (id)sender;
#endif

@property (nonatomic, assign) NSInteger dbID;
@property (nonatomic, retain) Pokemon *pokemon;

@property (nonatomic, retain) NSArray *dexNumbersTitles;
@property (nonatomic, retain) NSArray *dexNumbersValues;

@property (nonatomic, retain) NSArray *weightHeightTitles;
@property (nonatomic, retain) NSArray *weightHeightValues;

@property (nonatomic, retain) NSArray *extraStatsTitles;
@property (nonatomic, retain) NSArray *extraStatsValues;

@property (nonatomic, retain) NSArray *extra2StatsTitles;
@property (nonatomic, retain) NSArray *extra2StatsValues;

@property (nonatomic, retain) TCTableViewCell *genderTableCell;
@property (nonatomic, retain) TCTableViewCell *evTableCell;
@property (nonatomic, retain) TCTableViewCell *linksTableCell;

@property (nonatomic, retain) UIActionSheet *eggGroupPrompt;
@property (nonatomic, retain) UIActionSheet *abilityPrompt;

@property (nonatomic, retain) NSString *cryFilePath;
@property (nonatomic, retain) AVAudioPlayer *cryPlayer;

#ifdef PRIVATE_APIS_ARE_COOL
@property (nonatomic, retain) iPokedexSpeechSynthesizer *pokedexSpeech;
#endif

@end
