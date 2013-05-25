//
//  Languages.m
//  iPokedex
//
//  Created by Timothy Oliver on 29/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "Languages.h"

#define LANGUAGE_SYSTEM_ENGLISH @"en"
#define LANGUAGE_SYSTEM_JAPANESE @"ja"

#define LANGUAGE_LOCAL_ENGLISH @"en"
#define LANGUAGE_LOCAL_JAPANESE @"jp"

#define LANGUAGE_SETTING_AUTOMATIC 0
#define LANGUAGE_SETTING_ENGLISH 1
#define LANGUAGE_SETTING_JAPANESE 2

#define APPLE_LANGUAGES @"AppleLanguages"

static Languages *sharedLanguages = nil;

@implementation Languages

@synthesize languageSetting, languageCode, isDefault;

+ (Languages*)sharedLanguages
{
    @synchronized(self)
    {
        if (sharedLanguages == nil)
			sharedLanguages = [[Languages alloc] init];
    }
    return sharedLanguages;
}

- (id) init
{
    if ( sharedLanguages != nil ) {
        [NSException raise:NSInternalInconsistencyException
					format:@"[%@ %@] cannot be called; use +[%@ %@] instead"],
		NSStringFromClass([self class]), NSStringFromSelector(_cmd), 
		NSStringFromClass([self class]),
		NSStringFromSelector(@selector(sharedDex));
    } 
    else if( (self = [super init]) ) { }
    
    return self;
}

#pragma mark Init Code
//called at the beginning of app execution to
//retrieve and or change the app language settings
- (void)synchronizeLanguageSettings
{    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults]; 
    
    //preferred language from iOS device settings
    NSArray *systemLanguages = [userDefaults objectForKey: APPLE_LANGUAGES];
    NSString *systemLanguage = [systemLanguages objectAtIndex: 0];
        
    //Enable for Japanese localization
    if( [systemLanguage isEqualToString: LANGUAGE_SYSTEM_JAPANESE] )
    {
        //set the internal settings
        self.languageSetting = LanguageSettingModeJapanese;
        self.languageCode = LANGUAGE_LOCAL_JAPANESE;
        self.isDefault = NO;
    }
    else
    {
        self.languageSetting = LanguageSettingModeEnglish;
        self.languageCode = LANGUAGE_LOCAL_ENGLISH;
        self.isDefault = YES;  
    }
}

#pragma mark Language Query Methods
- (NSString*) currentLanguageSuffixWithUnderscore: (BOOL)underscore inCapitals: (BOOL)capitals
{
    //the default language doesn't use language codes
    if( self.isDefault )
        return @"";
    
    NSString *language = @"";
    
    //prepend a '_'
    if( underscore )
        language = [language stringByAppendingString: @"_"];
    
    //force all capitals if requested
    if( capitals )
        language = [language stringByAppendingString: [self.languageCode uppercaseString]];
    else
        language = [language stringByAppendingString:self.languageCode];
    
    return language;
}

- (BOOL) isJapanese
{
    return (self.languageSetting == LanguageSettingModeJapanese);
}

#pragma mark - Singleton Controls
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

@end
