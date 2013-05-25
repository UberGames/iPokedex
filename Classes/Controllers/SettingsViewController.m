//
//  SettingsViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 25/04/11.
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

#import "SettingsViewController.h"
#import "GANTracker.h"
#import "UIImage+TabIcon.h"

@implementation SettingsViewController

- (id) init
{
    if ( (self = [super initWithNibName:@"IASKAppSettingsView" bundle: nil]) )
    {
        self.showCreditsFooter = NO; //Sorry guys. Credits have been moved to the Legal menu. I'd rather keep the credits location consistent :)
        self.showDoneButton = NO; //Un-necessary as long as the settings are saved automatically
    
        self.title = NSLocalizedString( @"Settings", @"Settings tab" );
        self.tabBarItem.title = NSLocalizedString( @"Settings", @"Settings tab" );
        self.tabBarItem.image = [UIImage tabIconWithName: @"Settings"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[super viewDidAppear: animated];
    //[[GANTracker sharedTracker] trackPageview: @"/iPokédex/Settings" withError: nil];    
}

#pragma mark - 
#pragma mark Tag Title
- (NSString *)tagTitle
{
    return @"Settings";
}

@end
