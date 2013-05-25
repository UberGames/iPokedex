//
//  PokemonInfoHeader.m
//  iPokedex
//
//  Created by Timothy Oliver on 29/12/10.
//  Copyright 2010 UberGames. All rights reserved.
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

#import "PokemonInfoHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "TCQuartzFunctions.h"
#import "UIImage+ImageLoading.h"
#import "UIColor+CustomColors.h"
#import "TCBeveledButton.h"

#define POKEMON_HEADER_IMAGE_SIZE 131
#define CRIES_BUTTON_SIZE 35

@interface PokemonInfoHeader (hidden)

- (void)initCryButton;

#ifdef PRIVATE_APIS_ARE_COOL
- (void)initSpeechButton;
#endif

@end

@implementation PokemonInfoHeader

@synthesize pokemonPic, pokemonName, pokemonLangName, pokemonForme, type1Image, type2Image, nDex, cryButton;

#ifdef PRIVATE_APIS_ARE_COOL
@synthesize speechButton;
#endif

- (id) initWithFrame: (CGRect)frame
{
	if( (self = [super initWithFrame: frame]) )
	{
		self.backgroundColor = [UIColor clearColor];
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.contentStretch = CGRectMake( 1.0f, 0.0f, 1.0f, 1.0f );
        
        [self initCryButton];
        
#ifdef PRIVATE_APIS_ARE_COOL
        [self initSpeechButton];
#endif
	}
	
	return self;
}

- (void)initCryButton
{
    //create and add the cry button
    self.cryButton = [TCBeveledButton buttonWithRadius: 5.0f];
    cryButton.showsTouchWhenHighlighted = YES;
    cryButton.frame = CGRectMake( self.frame.size.width-(CRIES_BUTTON_SIZE+10), (POKEMON_HEADER_IMAGE_SIZE+10)-(CRIES_BUTTON_SIZE), CRIES_BUTTON_SIZE, CRIES_BUTTON_SIZE+1    );
    cryButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    //set up the draw style
    /*cryButton.layer.cornerRadius = 5.0f;
    cryButton.layer.borderWidth = 1.0f;
    cryButton.backgroundColor = [UIColor whiteColor];
    cryButton.layer.borderColor = [[UIColor colorWithRed: 0.6f green: 0.6f blue: 0.6f alpha: 1.0f] CGColor];*/
    
    //create the image
    UIImage *cryButtonImage = [UIImage imageFromResourcePath: @"Images/Interface/SoundButton.png"];
    UIImageView *cryImageView = [[UIImageView alloc] initWithImage: cryButtonImage];
    [cryButton addSubview: cryImageView];
    [cryImageView release];
    
    [self addSubview: cryButton];
}

#ifdef PRIVATE_APIS_ARE_COOL
- (void)initSpeechButton
{
    //create and add the cry button
    self.speechButton = [TCBeveledButton buttonWithRadius: 5.0f];
    speechButton.showsTouchWhenHighlighted = YES;
    speechButton.frame = CGRectMake( self.frame.size.width-((CRIES_BUTTON_SIZE*2)+15), (POKEMON_HEADER_IMAGE_SIZE+10)-(CRIES_BUTTON_SIZE), CRIES_BUTTON_SIZE, CRIES_BUTTON_SIZE+1    );
    speechButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    //set up the draw style
    /*speechButton.layer.cornerRadius = 5.0f;
    speechButton.layer.borderWidth = 1.0f;
    speechButton.backgroundColor = [UIColor whiteColor];
    speechButton.layer.borderColor = [[UIColor colorWithRed: 0.6f green: 0.6f blue: 0.6f alpha: 1.0f] CGColor];*/
    
    //create the image
    UIImage *speechButtonImage = [UIImage imageFromResourcePath: @"Images/Interface/PokedexButton.png"];
    UIImageView *speechImageView = [[UIImageView alloc] initWithImage: speechButtonImage];
    [speechButton addSubview: speechImageView];
    [speechImageView release];
    
    [self addSubview: speechButton];  
}
#endif

-(void) drawRect:(CGRect)rect
{
	CGRect drawRect;
	UIFont *font;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//draw the image BG
	drawRect = CGRectMake( 10, 10, POKEMON_HEADER_IMAGE_SIZE, POKEMON_HEADER_IMAGE_SIZE+1 );
	//TCDrawRoundedRect( context, drawRect, 5.0f, [UIColor whiteColor] );
	TCDrawBeveledRoundedRect( context, drawRect, 10.0f, [UIColor whiteColor] );
    //draw the image
	//[pokemonPic drawInRect: drawRect ];
    [pokemonPic drawAtPoint: CGPointMake( drawRect.origin.x, drawRect.origin.y) ];
	
	//draw the text labels next to the image
	NSInteger x = drawRect.origin.x + POKEMON_HEADER_IMAGE_SIZE + 10;
	NSInteger y = (pokemonForme != nil) ? 35 : 45;
	
	//pokemon name
	font = [UIFont boldSystemFontOfSize: 20.0f];
	drawRect = CGRectMake( x, y, 152, 22 );
    
    CGContextSaveGState(context);
    CGContextSetBlendMode( context, kCGBlendModeNormal);
	[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
	[pokemonName drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
    
    CGContextSetBlendMode( context, kCGBlendModeCopy);
	[[UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.8f] set];
	[pokemonName drawInRect: drawRect withFont: font];
	CGContextRestoreGState(context);
    
	//if there is a forme name, add that underneath
	if( pokemonForme != nil )
	{
		y += 22;
		
		font = [UIFont boldSystemFontOfSize: 14.0f];
		drawRect = CGRectMake( x, y, 200, 20 );
        
        CGContextSaveGState(context);
        //bevel highlight
        CGContextSetBlendMode( context, kCGBlendModeNormal);
		[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
		[pokemonForme drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
        //text
        CGContextSetBlendMode( context, kCGBlendModeCopy);
		[[UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.8f] set];
		[pokemonForme drawInRect: drawRect withFont: font];	
        CGContextRestoreGState(context);
        
		y += 20;		
	}
	else {
		y += 25;
	}

	//pokemon Language name
    CGContextSaveGState(context);
	font = [UIFont systemFontOfSize: 14.0f];
	drawRect = CGRectMake( x, y, 200, 15 );
    CGContextSetBlendMode( context, kCGBlendModeNormal);
	[[UIColor colorWithWhite: 1.0f alpha: 0.75f] set];
	[pokemonLangName drawInRect: CGRectOffset(drawRect, 0, 1.0f) withFont: font];
    
    CGContextSetBlendMode( context, kCGBlendModeCopy);
	[[UIColor colorWithRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.8f] set];
	[pokemonLangName drawInRect: drawRect withFont: font];	
	CGContextRestoreGState(context);
    
    y += 23;
    
	//add the pokemon type images
	drawRect = CGRectMake( x, y, 32, 14 );
	[type1Image drawInRect: drawRect];
	
	if( type2Image != nil )
	{
		drawRect = CGRectMake( x+37, y, 32, 14 );
		[type2Image drawInRect: drawRect];		
	}
	
	//finally, draw the nDex number in the corner
	drawRect = CGRectMake( self.bounds.size.width-60, 10, 52, 30 );
    TCDrawBeveledRoundedRect( context, drawRect, 5.0f, [UIColor whiteColor] );
    //TCDrawRoundedRect( context, drawRect, 5.0f, [UIColor whiteColor] );
    font = [UIFont boldSystemFontOfSize: 17.0f];
	[[UIColor blackColor] set];
	[nDex drawInRect: CGRectOffset(drawRect, 0, 4 ) withFont: font lineBreakMode: UILineBreakModeClip alignment: UITextAlignmentCenter];
}

- (void)dealloc {
	[pokemonPic release];
	[pokemonName release];
	[pokemonLangName release];
	[type1Image release];
	[type2Image release];
	[nDex release];
    
    [cryButton release];
	
#ifdef PRIVATE_APIS_ARE_COOL
    [speechButton release];
#endif
    
    [super dealloc];
}



@end
