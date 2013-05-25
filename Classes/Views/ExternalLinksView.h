//
//  PokemonProfileExternalLinks.h
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

#import <UIKit/UIKit.h>

#define EXTERNAL_LINKS_HEIGHT 95

@interface ExternalLinksView : UIView <UIActionSheetDelegate> {
    NSMutableArray *linkButtons;
    UIViewController *targetController;
    UILabel *titleLabel;
    
    NSInteger generation;
    BOOL hideTitle;
}

- (void)buttonPressed: (id)sender;

- (NSInteger) numberOfLinks;
- (BOOL)buttonIsDisabledWithIndex: (NSInteger)index;
- (NSString *)titleForLinkWithIndex: (NSInteger)index;
- (NSArray *)choicesForLinkWithIndex: (NSInteger)index;

- (NSURL *)URLForLinkWithIndex: (NSInteger)index withGen: (NSInteger)gen;
- (UIImage *)imageForLinkWithIndex: (NSInteger)index;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) NSMutableArray *linkButtons;
@property (nonatomic, assign) UIViewController *targetController;

@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) BOOL hideTitle;

@end
