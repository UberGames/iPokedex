//
//  LicenseViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 27/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "GANTracker.h"
#import "LicenseViewController.h"


@implementation LicenseViewController

@synthesize tagTitle;

- (id)initWithHTMLFile: (NSString *)htmlFile withTitle: (NSString *)title withTagTitle: (NSString *)_tagTitle
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcePath stringByAppendingPathComponent: htmlFile];
    NSURL *_baseURL = [NSURL fileURLWithPath: [resourcePath stringByAppendingPathComponent: @"HTML"]];
    
    if( (self = [super initWithURL: htmlPath withBaseURL: _baseURL]) )
    {
        self.title = title;
        self.tagTitle = _tagTitle;
    }
    
    return self;

}

- (void)dealloc
{
    [tagTitle release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    NSString *logTitle = [NSString stringWithFormat: @"/Legal/%@", tagTitle];
    [[GANTracker sharedTracker] trackPageview: logTitle withError: nil];
    //NSLog( @"Logged GAN Dispatch: %@", logTitle );
}

@end
