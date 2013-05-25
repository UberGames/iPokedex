//
//  iPokedexAppDelegate.m
//  iPokedex
//
//  Created by Timothy Oliver on 16/11/10.
//  Copyright 2010 UberGames. All rights reserved.
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

#import "iPokedexAppDelegate.h"
#import "TCNotifier.h"
#import "Appirater.h"
#import "iPokedexLegacyHandler.h"

//Google Analytics
#define IPOKEDEX_GOOGLE_ANALYTICS_ID @""

// Dispatch aggregated stat data every 5 minutes
static const NSInteger kGANDispatchPeriodSec = 60*5; 

@implementation iPokedexAppDelegate

@synthesize window;
@synthesize navController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
	//launch Google Analytics Tracking
	[[GANTracker sharedTracker] startTrackerWithAccountID: IPOKEDEX_GOOGLE_ANALYTICS_ID dispatchPeriod: kGANDispatchPeriodSec delegate: self];
	
    //Log the initial activation of the app
	[[GANTracker sharedTracker] trackPageview: @"/iPokédex" withError: nil];
	[[GANTracker sharedTracker] dispatch];
	//NSLog( @"Logged GAN Dispatch: %@", @"/iPokédex" );
	
	// call the Appirater launched delegate method
	//(Will periodically ask the user to rate us on the App Store)
    [Appirater appLaunched:YES];
    
    //call the notifier class to check if any updates have come from the UberGames server
    [TCNotifier appLaunched];

    //Check if this version of the app is newer than the last time (eg, the user upgraded)
    //If so, a one-off action may be performed here (eg updating save settings)
    [iPokedexLegacyHandler appLaunched];
    
    //Syncronize the database language settings to the system language
    [[Languages sharedLanguages] synchronizeLanguageSettings];
    
    //------------------------------------------------------------
    
	// Add the nav bar controller's view to the window and display.
    [window setRootViewController: navController];
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	//Call Appirater to see if we should display a 'rate now' dialog
	[Appirater appEnteredForeground: YES];

    //call the notifier class to see if any updates have come from the UberGames server
    [TCNotifier appEnteredForeground];    
    
	//Log the re-activation of the app
	[[GANTracker sharedTracker] trackPageview: @"/iPokédex" withError: nil];
	//NSLog( @"Logged GAN Dispatch: %@", @"/iPokédex" );
}

- (void)trackerDispatchDidComplete:(GANTracker *)tracker
                  eventsDispatched:(NSUInteger)eventsDispatched
              eventsFailedDispatch:(NSUInteger)eventsFailedDispatch
{
	//NSLog( @"GA Dispatch Received! %d events dispatched. %d failed.", eventsDispatched, eventsFailedDispatch );
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[[GANTracker sharedTracker] stopTracker];
	
    [navController release];
    [window release];
    [super dealloc];
}

@end

