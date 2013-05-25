//
//  AboutTableHeaderView.m
//  iPokedex
//
//  Created by Timothy Oliver on 19/03/11.
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

#import "AboutTableHeaderView.h"
#import "UIImage+ImageLoading.h"

#define IPOKEDEX_LOGO @"Images/Logos/iPokedex%@.png"

@implementation AboutTableHeaderView

@synthesize versionNumber, ipokedexLogo, uberGamesTitle;

- (id)init
{
    self = [super initWithFrame: CGRectMake( 10, 0, 300, 160)];
    if (self) {
        //init draw parameters
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        //init class members
        self.uberGamesTitle     = NSLocalizedString( @"By UberGames", nil );
        
        self.versionNumber = [NSString stringWithFormat: NSLocalizedString( @"Version %@", nil), 
                              [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleVersion"]];
        
        NSString *pokedexLogo = [NSString stringWithFormat: IPOKEDEX_LOGO, [[Languages sharedLanguages] currentLanguageSuffixWithUnderscore:NO inCapitals:YES] ];
        self.ipokedexLogo = [UIImage imageFromResourcePath: pokedexLogo];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect viewRect = self.bounds;
    CGRect drawRect;
    
    //draw the iPokedex logo
    drawRect = CGRectMake( (viewRect.size.width/2)-(ipokedexLogo.size.width/2), 15, ipokedexLogo.size.width, ipokedexLogo.size.height);
    [ipokedexLogo drawInRect: drawRect];
    
    //draw the UberGames text
    UIFont *font = [UIFont boldSystemFontOfSize: 17.0f];
    CGSize textSize = [uberGamesTitle sizeWithFont: font];
    drawRect = CGRectMake( (viewRect.size.width/2)-(textSize.width/2), 110.0f, textSize.width, textSize.height);
 
    [[UIColor whiteColor] set];
    [uberGamesTitle drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
    
    [[UIColor colorWithRed: 91.0f/255.0f green: 91.0f/255.0f blue: 91.0f/255.0f alpha: 1.0f] set];
    [uberGamesTitle drawInRect: drawRect withFont: font];    
    
    //draw the version text
    font = [UIFont boldSystemFontOfSize: 20.0f];
    textSize = [versionNumber sizeWithFont: font];
    drawRect = CGRectMake( (viewRect.size.width/2)-(textSize.width/2), 131.0f, textSize.width+50, textSize.height);

    //draw the white shadow
    [[UIColor whiteColor] set];
    [versionNumber drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
    
    [[UIColor colorWithRed: 91.0f/255.0f green: 91.0f/255.0f blue: 91.0f/255.0f alpha: 1.0f] set];
    [versionNumber drawInRect: drawRect withFont: font];
}

- (void)dealloc
{
    [ipokedexLogo release];
    [versionNumber release];
    [uberGamesTitle release];
    
    [super dealloc];
}

@end
