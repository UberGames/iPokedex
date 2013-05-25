//
//  LegacyHandler.m
//  iPokedex
//
//  Created by Timothy Oliver on 3/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCLegacyHandler.h"

NSString * const kLHCurrentVersionKey = @"kLHCurrentVersion";

@interface TCLegacyHandler (hidden)

+ (void)checkForAppUpdate;
+ (BOOL)version: (NSString *)version1 isNewerThan: (NSString *)version2;
+ (void) syncronizeToLatestVersion;

@end

@implementation TCLegacyHandler

+ (void)appLaunched
{
    //get the current app version and the last app version that we recorded
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey: kLHCurrentVersionKey];
    
    //cancel if we're already at the latest version
    if( [lastVersion length] > 0 && [TCLegacyHandler version: appVersion isNewerThan: lastVersion] == NO )
        return;
    
    //send a message to the subclass so they can perform any updates to the code
    if( [[self class] shouldSyncronizeCurrentVersion: appVersion fromVersion: lastVersion] )
    {
        [TCLegacyHandler syncronizeToLatestVersion];
    }
}

+ (BOOL) shouldSyncronizeCurrentVersion: (NSString *)currentVersion fromVersion: (NSString *)oldVersion
{
    //overridden by subclasses
    return NO;
}

+ (void)syncronizeToLatestVersion
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]; 
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject: appVersion forKey: kLHCurrentVersionKey];
    [userDefaults synchronize];
}

+ (BOOL)version: (NSString *)version1 isNewerThan: (NSString *)version2
{
    NSArray *version1Components = [version1 componentsSeparatedByString: @"."];
    NSArray *version2Components = [version2 componentsSeparatedByString: @"."];
    
    //find the max number of components to test
    NSInteger numComponents = [version1Components count];
    if( [version2Components count] > numComponents )
        numComponents = [version2Components count];
    
    //loop through each component and compare
    for ( NSInteger i = 0; i < numComponents; i++ )
    {
        //grab the component, or substitute 0 if it goes beyond the bounds
        NSInteger version1Value = 0;
        if( i < [version1Components count] )
            version1Value = [[version1Components objectAtIndex: i] intValue];
        
        NSInteger version2Value = 0;
        if( i < [version2Components count] )
            version2Value = [[version2Components objectAtIndex: i] intValue];
        
        //perform the check
        if( version1Value > version2Value ) 
            return YES;
    }
    
    return NO;
}


@end
