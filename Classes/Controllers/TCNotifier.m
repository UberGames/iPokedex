//
//  TCNotifier.m
//  iPokedex
//
//  Created by Timothy Oliver on 27/04/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCNotifier.h"
#import "TBXML.h"

NSString *const kNotifierLastUse            = @"kNotifierLastUse";
NSString *const kNotifierDismissedEntries   = @"kNotifierDismissedEntries";

@interface TCNotifier (hidden)
+ (TCNotifier *)sharedInstance;
+ (BOOL)shouldCheckForNotification;
+ (void)dismissNotificationID: (NSInteger)notificationID;
- (void)performNotification;
- (void)checkForNotification;
- (BOOL)latestNotificationFromServer;
- (void)showNotification;
@end

@implementation TCNotifier

@synthesize latestNotification;

+ (TCNotifier *)sharedInstance
{
    static TCNotifier *notifier = nil;
    
    if( notifier == nil )
    {
        @synchronized(self) {
            if( notifier == nil )
                notifier = [[TCNotifier alloc] init];
        }
    }
    
    return notifier;
}

+ (BOOL)shouldCheckForNotification
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //get the last time this app performed a check
    NSTimeInterval lastUse = [userDefaults floatForKey: kNotifierLastUse];
    //first time
    if( lastUse <= 0 )
    {
        CGFloat lastUse = [[NSDate date] timeIntervalSince1970];
        [userDefaults setDouble: lastUse forKey: kNotifierLastUse];
        [userDefaults synchronize];
        
        return YES;
    }

    //current time
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    //time between updates
    NSTimeInterval period = NOTIFIER_DAYS_BEFORE_CHECK * 24 * 60 * 60;

    //last check was beyond the period
    if( (now-lastUse) > period )
    {
        //update settings to now
        [userDefaults setDouble: now forKey: kNotifierLastUse];
        [userDefaults synchronize];
    
        return YES;
    }

    return NO;
}

+ (void)dismissNotificationID: (NSInteger)notificationID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //get the list from user settings (or create a null array otherwise)
    NSMutableArray *dismissedIDList = [NSMutableArray arrayWithArray: [userDefaults arrayForKey: kNotifierDismissedEntries]];
    
    //add the new ID
    [dismissedIDList addObject: [NSNumber numberWithInt: notificationID]];
     
    //re-add to user settings 
    [userDefaults setObject: dismissedIDList forKey: kNotifierDismissedEntries];

    //re-sync
    [userDefaults synchronize];
}

- (BOOL)serverHasNewNotification
{
    //Check which URL to grab
    NSString *notifierLink = nil;
    if( NOTIFIER_DEBUG )
        notifierLink = NOTIFIER_DEBUG_URL;
    else
        notifierLink = NOTIFIER_URL;
    
    //download the data from the server and feed into TBXML
    TBXML *xml = [TBXML tbxmlWithURL: [NSURL URLWithString: notifierLink]];
    if( xml == nil || xml.rootXMLElement == nil )
        return NO;

    //get the list of dismissed IDs (eg IDs of notifications where 'remind me later' wasn't pushed)
    NSArray *handledIDList = [[NSUserDefaults standardUserDefaults] arrayForKey: kNotifierDismissedEntries];
    
    //app version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];

    TBXMLElement *root = xml.rootXMLElement;
    
    //get the first notification element in the list
    TBXMLElement *xmlNotification = [TBXML childElementNamed: @"notification" parentElement: root];
    if ( xmlNotification == nil )
        return NO;
    
    //loop through each one
    do {
        //get the id of the notification
        NSInteger notificationID = [[TBXML valueOfAttributeNamed: @"id" forElement: xmlNotification] intValue];
        //min and max versions
        NSString *minVersion = [TBXML valueOfAttributeNamed: @"minversion" forElement: xmlNotification];
        NSString *maxVersion = [TBXML valueOfAttributeNamed: @"maxversion" forElement: xmlNotification];
        
        //if a minimum version was supplied, check the app's version is above it
        if( [minVersion length] > 0 )
        { 
            if( [TCNotifier version: version isNewerOrEqualTo: minVersion] == NO )
                continue;
        }
        
        //if a max version was specified check the app's version is below it
        if( [maxVersion length] > 0 )
        { 
            if( [TCNotifier version: maxVersion isNewerOrEqualTo: version] == NO )
                continue;
        }
        
        //Check this ID hasn't been dismissed and placed in the dismissed list before
        BOOL isDismissed = FALSE;
        for( NSNumber *dismissedNumber in handledIDList )
        {
            if( [dismissedNumber intValue] == notificationID )
            {
                isDismissed = YES;
                break;
            }
        }
        
        //At this point, we've reached a valid notification object that we should push to the user
        if( isDismissed )
            continue;
        else
            break;
        
    } while ((xmlNotification = [TBXML nextSiblingNamed: @"notification" searchFromElement: xmlNotification]));
    
    //No new notifications found. Maybe next time
    if( xmlNotification == nil )
        return NO;
    
    //a notification was found. flush out any old ones
    self.latestNotification = nil;
    
    //Make sure it has all of the necessary info before proceeding
    NSInteger notificationID = [[TBXML valueOfAttributeNamed: @"id" forElement: xmlNotification] intValue];
    NSString *notificationTitle = [TBXML textForElement: [TBXML childElementNamed: @"title" parentElement: xmlNotification]];
    NSString *notificationMessage = [TBXML textForElement: [TBXML childElementNamed: @"message" parentElement: xmlNotification]];
    NSString *notificationURL = [TBXML textForElement: [TBXML childElementNamed: @"link" parentElement: xmlNotification]];
    
    if( notificationID <= 0 || [notificationTitle length] == 0 || [notificationMessage length] == 0 || [notificationURL length] == 0 )
        return NO;
    
    //set up the store
    latestNotification = [[TCNotifierNotification alloc] init];
    
    //ID of notification 
    latestNotification.notificationID = notificationID;
    //Title of message
    latestNotification.title = notificationTitle;
    //message body
    latestNotification.message = notificationMessage;
    //accept URL
    latestNotification.acceptURL = [NSURL URLWithString: notificationURL];
    
    return YES;
}

- (void)performNotification
{
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
        //see if it's time to perform a check again
        if( [TCNotifier shouldCheckForNotification] == YES || NOTIFIER_DEBUG )
        {
            //perform the check (the latest notification will be saved internally)
            if( [self serverHasNewNotification] )
            {
                [self performSelectorOnMainThread: @selector(showNotification) withObject: nil waitUntilDone: NO];
            }
        }
    
    [pool release];
}

- (void)showNotification
{
    TCNotifierNotification *n = [self latestNotification];
    
    if( latestNotification != nil )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: n.title 
                                                        message: n.message 
                                                       delegate: self 
                                              cancelButtonTitle: n.declineButtonText 
                                              otherButtonTitles: n.acceptButtonText, n.remindMeLaterButtonText, nil];
        [alert show];
        [alert release];
    }

}

+ (void)appLaunched
{
    [[TCNotifier sharedInstance] performSelectorInBackground: @selector(performNotification) withObject: nil];
}

+ (void)appEnteredForeground
{
    [[TCNotifier sharedInstance] performSelectorInBackground: @selector(performNotification) withObject: nil];
}

+ (BOOL)version: (NSString *)version1 isNewerOrEqualTo: (NSString *)version2
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
        
        //skip if they're the same
        if( version1Value == version2Value )
            continue;
        
        //perform the check
        if( version1Value > version2Value ) 
            return YES;
        else
            return NO;
    }
    
    return YES;
}

#pragma mark UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //not sure how this would have been triggered, but just in case
    if( self.latestNotification == nil )
        return;
    
    switch ( buttonIndex )
    {
        case 1: //Accept Button
            [TCNotifier dismissNotificationID: latestNotification.notificationID];
            [[UIApplication sharedApplication] openURL: latestNotification.acceptURL];
            break;
        case 0: //No button
            //dismiss the ID, then do nothing
            [TCNotifier dismissNotificationID: latestNotification.notificationID];
            break;
        default:
        case 2: //Remind Me Later Button
            //do nothing
            break;
    }
    
    //done with this object. free it up
    self.latestNotification = nil;
}

@end

@implementation TCNotifierNotification

@synthesize notificationID, title, message, acceptButtonText, remindMeLaterButtonText, declineButtonText, acceptURL;

-(id) init
{
    if( (self = [super init]) )
    {
        self.acceptButtonText = NOTIFIER_ACCEPT;
        self.remindMeLaterButtonText = NOTIFIER_REMIND_ME_LATER;
        self.declineButtonText = NOTIFIER_DECLINE;
    }
    
    return self;
}

-(NSString*)description
{
    return [NSString stringWithFormat: @"[TCNotifierNotification] Name: %@, Body: %@, URL: %@", self.title, self.message, self.acceptURL];
}

-(void) dealloc
{
    [title release];
    [message release];
    [acceptButtonText release];
    [remindMeLaterButtonText release];
    [declineButtonText release];
    
    [super dealloc];
}

@end
