/*
* TCNotifier.h
* Notifier
*
* A framework that allows app developers to send notifications
* to users. Based loosely on Appirater by Arash Payan.
*
* Created by Timothy Oliver on 27/04/11.
* Copyright 2011 UberGames. All rights reserved.
*/

#import <Foundation/Foundation.h>

/*
 The URL to the XML file to parse
 */
#define NOTIFIER_URL @"http://apps.ubergames.org/ipokedex/notices.xml"

/*
 The URL to the XML file to parse (for testing)
 */
#define NOTIFIER_DEBUG_URL @"http://localhost/notices.xml"

/*
 The title of the alert box
 */
#define NOTIFIER_TITLE @"Message from the Developer!"

/*
 The text of the accept button.
 */
#define NOTIFIER_ACCEPT NSLocalizedString( @"Sure! Let's go!", @"Notifier Accept")

/*
 The text of the 'Remind me later' button
 */
#define NOTIFIER_REMIND_ME_LATER NSLocalizedString( @"Remind me later", @"Notifier Remind Me Later" )

/*
The text of the decline button
 */
#define NOTIFIER_DECLINE NSLocalizedString( @"No, Thanks", @"Notifier No Thanks" )
 
/*
The number of days between checking
 */
#define NOTIFIER_DAYS_BEFORE_CHECK 1

/*
 Debug mode
 */
#define NOTIFIER_DEBUG NO

@interface TCNotifierNotification : NSObject {
    NSInteger notificationID;
    NSString *title;
    NSString *message;
    NSString *acceptButtonText;
    NSString *remindMeLaterButtonText;
    NSString *declineButtonText;
    NSURL *acceptURL;
}

@property (nonatomic, assign) NSInteger notificationID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *acceptButtonText;
@property (nonatomic, copy) NSString *remindMeLaterButtonText;
@property (nonatomic, copy) NSString *declineButtonText;
@property (nonatomic, retain) NSURL *acceptURL;

@end

@interface TCNotifier : NSObject <UIAlertViewDelegate> {
    TCNotifierNotification *latestNotification;
}

@property (nonatomic, retain) TCNotifierNotification *latestNotification;

/* App was just launched. */
+ (void)appLaunched;

/* App just entered foreground. */
+ (void)appEnteredForeground;

/*Compare 2 version strings*/
+ (BOOL)version: (NSString *)version1 isNewerOrEqualTo: (NSString *)version2;

@end
