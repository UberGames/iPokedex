//
//  LegacyHandler.h
//  iPokedex
//
//  Created by Timothy Oliver on 3/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCLegacyHandler : NSObject {

}

+ (void)appLaunched;
+ (BOOL) shouldSyncronizeCurrentVersion: (NSString *)currentVersion fromVersion: (NSString *)oldVersion;

@end
