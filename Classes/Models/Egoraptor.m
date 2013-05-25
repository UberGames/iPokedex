//
//  Egoraptor.m
//  iPokedex
//
//  Created by Timothy Oliver on 18/03/11.
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

#import "Egoraptor.h"

static Egoraptor *sharedRaptor;

@implementation Egoraptor

@synthesize av;

+ (Egoraptor *)sharedRaptor
{
    @synchronized(self)
    {
        if (sharedRaptor == nil)
			sharedRaptor = [[Egoraptor alloc] init];
    }
    return sharedRaptor;
}

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

- (void)performAwesomeness
{
    //if one is already playing, stop it
    if( [av isPlaying] )
        [av stop];
    
    static NSInteger playIndex = 1;
    NSString *soundByte = [NSString stringWithFormat:@"Sounds/Egoraptor/Egoraptor%d.m4a", playIndex];
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: soundByte];
    
    NSError *err;
    av = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: filePath] error: &err];
    if( err )
        NSLog( @"Audio failed with reason: %@", [err description] );
    
    av.delegate = self;
    [av play];
    
    //wrap it around
    if( ++playIndex > 4 )
        playIndex = 1;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.av = nil;
}

@end
