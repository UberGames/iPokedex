//
//  TCWebLinker.m
//  iPokedex
//
//  Created by Timothy Oliver on 13/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCWebLinker.h"
#import "TCWebBrowserViewController.h"

#define LOAD_LINKS_IN_SAFARI [[NSUserDefaults standardUserDefaults] boolForKey: @"loadLinksInSafari"] 

static TCWebLinker *sharedLinker = nil;

@implementation TCWebLinker

@synthesize targetURL, linkPrompt;

+ (TCWebLinker *)sharedLinker
{
    @synchronized(self)
    {
        if (sharedLinker == nil)
			sharedLinker = [[TCWebLinker alloc] init];
    }
    return sharedLinker;
}

- (id) init
{
    if ( sharedLinker != nil ) {
        [NSException raise:NSInternalInconsistencyException
					format:@"[%@ %@] cannot be called; use +[%@ %@] instead"],
		NSStringFromClass([self class]), NSStringFromSelector(_cmd), 
		NSStringFromClass([self class]),
		NSStringFromSelector(@selector(sharedDex));
    } 
    else if( (self = [super init]) ) { }
    
    return self;
}

#pragma mark -
#pragma mark Accessible Elements

- (void) openURL: (NSURL *)url fromController: (UIViewController *)controller
{
    //we already have one in progress. don't start a new one
    if( linkPrompt != nil || controller == nil )
        return;
    
    if( LOAD_LINKS_IN_SAFARI )
    {
        [self openURLInSafari: url fromController: controller];
    }
    else
    {
        UINavigationController *navController = controller.parentViewController.navigationController;
        if( navController == nil ) { navController = controller.navigationController; }
        
        TCWebBrowserViewController *webController = [[TCWebBrowserViewController alloc] initWithURL: url];
        [navController pushViewController: webController animated: YES];
        [webController release];
    }
}

- (void) openURLInSafari: (NSURL *)url fromController: (UIViewController *)controller 
{
    //save the needed info
    self.targetURL = url;
    
    linkPrompt = [[UIActionSheet alloc] initWithTitle: [url absoluteString]
                                             delegate: self 
                                    cancelButtonTitle: NSLocalizedString( @"Cancel", nil ) 
                               destructiveButtonTitle: nil 
                                    otherButtonTitles: NSLocalizedString( @"Open in Safari", nil ), NSLocalizedString( @"Copy", nil ), nil];
    
    if (controller.parentViewController.view )
        [linkPrompt showInView: controller.parentViewController.view];
    else
        [linkPrompt showInView: controller.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if( targetURL == nil )
    {
        self.linkPrompt = nil;
        return;
    }
    
    if (buttonIndex == 0 ) //Open in Safari
    {
        [[UIApplication sharedApplication] openURL: targetURL];
    }
    else if( buttonIndex == 1 ) //Copy
    {
        NSString *sourceURL = [targetURL absoluteString];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = sourceURL;
    }
    
    self.linkPrompt = nil;
}

#pragma mark -
#pragma mark Singleton references

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
