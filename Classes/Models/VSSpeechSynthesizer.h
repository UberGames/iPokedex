//
//  VSSpeechSynthesizer.h
//  VoiceServices
//
//  A partial recreation of the VSSpeechSynthesizer class header from the
//  VoiceServices Apple Private API framework.
//
//  Any app with this implemented will most definitely be rejected from App Store submission.
//

#ifdef PRIVATE_APIS_ARE_COOL

#import <Foundation/Foundation.h>

@interface VSSpeechSynthesizer : NSObject {
}

+ (id)availableLanguageCodes;
+ (BOOL)isSystemSpeaking;

/*  Start speaking the specified string. Ignores the iPhone mute switch.*/
- (id)startSpeakingString:(id)string;
- (id)startSpeakingString:(id)string toURL:(id)url;
- (id)startSpeakingString:(id)string toURL:(id)url withLanguageCode:(id)code;

/* The current instance is talking. */
- (BOOL)isSpeaking;

/* Stop speaking */
- (void)stopSpeakingAtNextBoundary:(NSInteger)boundary;

/* Talking speed. Default is 1.0f */
- (float)rate;
- (id)setRate:(float)rate;

/* Pitch of voice. Default is 1.0f */
- (float)pitch;
- (id)setPitch:(float)pitch;

/* Relative volume of voice. */
- (float)volume;
- (id)setVolume:(float)volume;

@end

#endif