//
//  PokemonProfileExternalLinks.m
//  iPokedex
//
//  Created by Timothy Oliver on 14/05/11.
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

#import "ExternalLinksView.h"
#import "UIImage+ImageLoading.h"
#import "TCWebLinker.h"
#import "UIColor+CustomColors.h"
#import "Pokemon.h"

#define IMAGE_PADDING 5
#define BUTTON_HEIGHT 70

#define MAX_GENERATION 5

@implementation ExternalLinksView

@synthesize linkButtons, generation, targetController, hideTitle, titleLabel;

#pragma mark -
#pragma mark View lifecycle methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        //determine the number of buttons and initialize each one
        NSInteger numButtons = [self numberOfLinks];
        
        self.linkButtons = [NSMutableArray array];
        for( NSInteger i = 0; i < numButtons; i++ )
        {
            UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            [button addTarget: self action: @selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside];
            button.tag = i;
            
            UIImage *image = [self imageForLinkWithIndex: i];
            [button setImage: image forState: UIControlStateNormal];
            
            [linkButtons addObject: button];
            [self addSubview: button];
        }
        
        //create the label
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake( floor(self.center.x)-45, self.frame.size.height-22, 90, 18)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        titleLabel.font = [UIFont boldSystemFontOfSize: 13.0f];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor tableCellCaptionColor];
        titleLabel.text = NSLocalizedString( @"External links", nil );
        [self addSubview:  titleLabel];
    }
    
    return self;
}

- (void)dealloc
{
    [linkButtons release];
    [titleLabel release];
    
    [super dealloc];
}

- (void)setHideTitle:(BOOL)hide
{
    if( hideTitle == hide )
        return;
    
    hideTitle = hide;
    
    [titleLabel setHidden: hideTitle];
}

#pragma mark -
#pragma mark View Drawing Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    NSInteger numButtons = [linkButtons count];
    
    NSInteger totalPadding = (numButtons-1) * IMAGE_PADDING;
    NSInteger buttonWidth = floor( (width - totalPadding) / numButtons );
    
    NSInteger x = 1;
    for( UIButton *button in linkButtons )
    {
        button.frame = CGRectMake( x, 0, buttonWidth, BUTTON_HEIGHT );
        x += (buttonWidth+IMAGE_PADDING);
    }
}

#pragma mark -
#pragma mark Button Handling Methods
- (void)buttonPressed:(id)sender
{
    NSInteger pressedIndex = [(UIButton *)sender tag];
    
    NSArray *linkChoices = [self choicesForLinkWithIndex: pressedIndex];
    //if no choices (or only one was found), just get the default URL and jump to it
    if( linkChoices == nil || [linkChoices count] <= 1 )
    {
        NSURL *url = [self URLForLinkWithIndex: pressedIndex withGen: MAX_GENERATION];
        [[TCWebLinker sharedLinker] openURL: url fromController: targetController];
        return;
    }
    
    NSString *sourceTitle = [self titleForLinkWithIndex: pressedIndex];
    
    //create an action sheet prompt
    UIActionSheet *genChoicePrompt = [[UIActionSheet alloc] initWithTitle: sourceTitle 
                                                                 delegate: self cancelButtonTitle: nil
                                                   destructiveButtonTitle: nil otherButtonTitles: nil];
    for( NSString *choiceTitle in linkChoices )
        [genChoicePrompt addButtonWithTitle: choiceTitle];
    
    [genChoicePrompt addButtonWithTitle: NSLocalizedString(@"Cancel",nil)];
    [genChoicePrompt setCancelButtonIndex: [linkChoices count]];
    
    //let the delegate know which button was pressed
    genChoicePrompt.tag = pressedIndex;
    
    [genChoicePrompt showInView: targetController.view];
    [genChoicePrompt release];
}

#pragma mark -
#pragma mark Manual Accessors
- (void)setGeneration:(NSInteger)newGen
{
    if( newGen == generation )
        return;
    
    generation = newGen;
    
    for( UIButton *button in linkButtons )
    {
        if( [self buttonIsDisabledWithIndex: button.tag] )
            [button setEnabled: NO];
    }
}

#pragma mark -
#pragma mark UIActionSheet Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger linkIndex = actionSheet.tag;
    NSInteger targetGen = 0;
    
    //determine the generation that was pressed
    targetGen = -buttonIndex + 5;
    
    //get the URL for this link with its generation
    NSURL *targetLink = [self URLForLinkWithIndex: linkIndex withGen: targetGen];
    if( targetLink )
        [[TCWebLinker sharedLinker] openURL:targetLink fromController: targetController];
}

#pragma mark - 
#pragma mark Button Feedbacks

- (NSInteger) numberOfLinks
{
    return 1;
}

- (BOOL)buttonIsDisabledWithIndex: (NSInteger)index
{
    return NO;
}

- (NSString *)titleForLinkWithIndex: (NSInteger)index
{
    return nil;
}
                                      
- (UIImage *)imageForLinkWithIndex: (NSInteger)index
{
    return nil;
}

- (NSArray *)choicesForLinkWithIndex: (NSInteger)index
{
    return nil;
}

- (NSURL *)URLForLinkWithIndex: (NSInteger)index withGen: (NSInteger)gen
{
    return nil;
}

@end
