//
//  AboutTableSourcesView.m
//  iPokedex
//
//  Created by Timothy Oliver on 20/03/11.
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

#import "AboutTableSourcesView.h"
#import "UIImage+ImageLoading.h"
#import "TCGroupedTableSectionHeaderView.h"
#import "TCWebLinker.h"
#import "TCBeveledButton.h"

#define ABOUT_SOURCES_NAMES [NSArray arrayWithObjects: @"Bulbapedia", \
                                                        @"veekun", \
                                                        @"ポケモンWiki", \
                                                        @"ポケモン徹底攻略", nil]

#define ABOUT_SOURCES_URLS [NSArray arrayWithObjects: @"http://bulbapedia.bulbagarden.net/", \
                                                        @"http://www.veekun.com/", \
                                                        @"http://wiki.xn--rckteqa2e.com/", \
                                                        @"http://www.yakkun.com/", nil]

#define ABOUT_SOURCES_PICTURES [NSArray arrayWithObjects: @"Images/Logos/Bulbapedia.png", \
                                                            @"Images/Logos/Veekun.png", \
                                                            @"Images/Logos/PokemonWiki.png", \
                                                            @"Images/Logos/Yakkun.png", nil]


#define ABOUT_SOURCES_BUTTON_SIZE 145

@interface AboutTableSourcesView ()

- (void) sourceTapped: (id)sender;

@end

@implementation AboutTableSourcesView

@synthesize buttons, sourceNames, sourceURLs, targetController;

- (id)init
{
    self = [super initWithFrame:CGRectMake(10, 0, 300, 350)];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.sourceURLs = ABOUT_SOURCES_URLS;
        
        NSArray *pictureNames = ABOUT_SOURCES_PICTURES;
        
        //create the header
        TCGroupedTableSectionHeaderView *headerView = [[TCGroupedTableSectionHeaderView alloc] initWithTitle: NSLocalizedString( @"Sources", nil )];    
        headerView.frame = CGRectInset(headerView.frame, -10, 0);
        [self addSubview: headerView];
        [headerView release];
        
        NSMutableArray *_buttons = [[NSMutableArray alloc] init];
        
        //instantiate each button
        NSInteger i = 0;
        for( NSString *picName in pictureNames)
        {
            //load the image
            UIImage *image = [UIImage imageFromResourcePath: picName];
            
            //create the button
            TCBeveledButton *button = [TCBeveledButton buttonWithRadius: 10.0f];
            button.tag = i;
            [button setImage: image forState: UIControlStateNormal];
            
            //add to this view view
            [self addSubview: button];
        
            //save to array
            [_buttons addObject: button];
            
            i++;
        }    
        
        self.buttons = _buttons;
        [_buttons release];
    }
    return self;
}

- (void)dealloc
{
    [buttons release];
    [sourceNames release];
    [sourceURLs release];
    
    [super dealloc];    
}

#pragma mark redraw method
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger y = GROUP_TABLE_SECTION_HEADER_HEIGHT + 2;
    NSInteger buttonMargin = 10;

    //position the buttons
    NSInteger width = ((self.frame.size.width-10)/2) - buttonMargin;
    
    NSInteger i = 0;
    for( UIButton *button in buttons )
    {
        CGRect drawRect = CGRectMake( (i%2)*(width+buttonMargin), y, width, ABOUT_SOURCES_BUTTON_SIZE);
        button.frame = drawRect;
        [button addTarget: self action: @selector(sourceTapped:) forControlEvents: UIControlEventTouchUpInside];
        
        if( ((i+1)%2) == 0 )
            y += ABOUT_SOURCES_BUTTON_SIZE + buttonMargin;
        
        i++;
    }
}

#pragma mark Source Tapped
- (void)sourceTapped: (id)sender
{
    UIView *parent = (UIView *)sender;
    NSString *url = [sourceURLs objectAtIndex: parent.tag];
    
    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: url] fromController: targetController];
}

@end
