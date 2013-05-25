//
//  iPokedexEntrySpeechSynthesizer.m
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

#define DEXTER_DING_PATH @"Sounds/Pokedex/Ding.m4a"

#import "UIDevice+SilentMode.h"
#import "iPokedexSpeechSynthesizer.h"

@implementation iPokedexSpeechSynthesizer

@synthesize phoneticCorrections, pokedexDingPlayer;

#pragma mark -
#pragma mark Class Lifecycle
- (id)init
{
    if( (self = [super init]) ) 
    {
        phoneticCorrections = [[NSArray alloc] initWithObjects:
                                        [TCPhoneticCorrection phoneticCorrectionWithSearchString: @"Pokémon" phoneticString: @"Poekaymawn"], 
                                        [TCPhoneticCorrection phoneticCorrectionWithSearchString: @"POKéMON" phoneticString: @"Poekaymawn"],
                                    nil];
        
        if( pokedexDingPlayer == nil )
        {
            //load the Dexter 'Ding' sound
            NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: DEXTER_DING_PATH];
            pokedexDingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: nil];
            pokedexDingPlayer.delegate = self;
        }
        
        //load the speech synthesizer
#if TARGET_IPHONE_SIMULATOR
#else
        speechSynthesizer = [[VSSpeechSynthesizer alloc] init];
#endif
    }
    
    return self;
}

- (void)dealloc
{
    [phoneticCorrections release];
    
#if TARGET_IPHONE_SIMULATOR
#else
    if( [speechSynthesizer isSpeaking] )
        [speechSynthesizer stopSpeakingAtNextBoundary: 0];
    
    [speechSynthesizer release];
#endif
    
    if( [pokedexDingPlayer isPlaying] )
        [pokedexDingPlayer stop];
    
    pokedexDingPlayer.delegate = nil;
    [pokedexDingPlayer release];
    
    [super dealloc];
}

- (NSString *)speakingStringWithPhoneticCorrectionsWithString: (NSString *)string
{
    if( phoneticCorrections == nil || [phoneticCorrections count] <= 0 )
        return string;
    
    for( TCPhoneticCorrection *correction in phoneticCorrections )
        string = [string stringByReplacingOccurrencesOfString: correction.searchString withString: correction.phoneticString options: NSCaseInsensitiveSearch range: NSMakeRange(0, [string length])];
    
    return string;
}

- (void)speakPokedexString: (NSString *)string
{
    if( [[UIDevice currentDevice] deviceIsMuted] )
        return;
    
    //format the string with the correct pronounciations
    for( TCPhoneticCorrection *correction in phoneticCorrections )
        string = [string stringByReplacingOccurrencesOfString: correction.searchString withString: correction.phoneticString];
    
    //play the 'ding' sound
    if( [pokedexDingPlayer isPlaying] )
        [pokedexDingPlayer stop];
        
    [pokedexDingPlayer play];
    
    speechString = [string retain];
    
    pokedexDingPlayer.delegate = self;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if( flag == NO )
        return;
    
    NSString *locale = nil;
    
    if( LANGUAGE_IS_JAPANESE )
        locale = @"ja-JP";
    else
        locale = @"en-US";
    
    //speak the string
#if TARGET_IPHONE_SIMULATOR
    NSLog( @"VoiceSynthesizer: %@", speechString );
#else
    [speechSynthesizer startSpeakingString: speechString toURL: nil withLanguageCode: locale];
#endif
    
    pokedexDingPlayer.delegate = nil;
    
    [speechString release];
}

@end


@implementation TCPhoneticCorrection

@synthesize phoneticString, searchString;

- (id)initWithSearchString: (NSString *)_searchString phoneticString: (NSString *)_phoneticString
{
    if ( (self = [super init]) )
    {
        self.phoneticString = _phoneticString;
        self.searchString = _searchString;
    }
    
    return self;
}

+ (TCPhoneticCorrection *)phoneticCorrectionWithSearchString: (NSString *)_searchString phoneticString: (NSString *)_phoneticString
{
    return [[[TCPhoneticCorrection alloc] initWithSearchString: _searchString phoneticString: _phoneticString] autorelease];
}

- (void)dealloc
{
    [super dealloc];
    
    [phoneticString release];
    [searchString release];
}

@end

#endif