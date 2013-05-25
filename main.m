//
//  main.m
//  iPokedex
//
//  Created by Timothy Oliver on 16/11/10.
//  Copyright 2010 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    setenv("CLASSIC", "0", 1);
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

