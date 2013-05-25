//
//  TCWebLinker.h
//  iPokedex
//
//  Created by Timothy Oliver on 13/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCWebLinker : NSObject <UIActionSheetDelegate> {
    NSURL *targetURL;
    
    UIActionSheet *linkPrompt;
}

+ (TCWebLinker *)sharedLinker;
- (void) openURL: (NSURL *)url fromController: (UIViewController *)controller;
- (void) openURLInSafari: (NSURL *)url fromController: (UIViewController *)controller;

@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, retain) UIActionSheet *linkPrompt;

@end
