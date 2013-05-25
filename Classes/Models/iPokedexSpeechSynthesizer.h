//
//  iPokedexEntrySpeechSynthesizer.h
//  iPokedex
//
//  Created by Timothy Oliver on 1/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

#ifdef PRIVATE_APIS_ARE_COOL

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

#if TARGET_IPHONE_SIMULATOR
#else
#import "VSSpeechSynthesizer.h"
#endif

//Object to hold the search value and the replacement phonetic value for made-up words
@interface TCPhoneticCorrection : NSObject  {
    NSString *searchString;
    NSString *phoneticString;
}

- (id)initWithSearchString: (NSString *)searchString phoneticString: (NSString *)phoneticString;
+ (TCPhoneticCorrection *)phoneticCorrectionWithSearchString: (NSString *)searchString phoneticString: (NSString *)phoneticString;

@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) NSString *phoneticString;

@end

@interface iPokedexSpeechSynthesizer : NSObject <AVAudioPlayerDelegate> {
    NSArray *phoneticCorrections;
    AVAudioPlayer *pokedexDingPlayer;
    
    NSString *speechString;
    
#if TARGET_IPHONE_SIMULATOR
#else
    VSSpeechSynthesizer *speechSynthesizer;
#endif
}

@property (nonatomic, retain) AVAudioPlayer *pokedexDingPlayer;

- (void)speakPokedexString: (NSString *)string;
    
@property (nonatomic, retain) NSArray *phoneticCorrections;

@end

#endif