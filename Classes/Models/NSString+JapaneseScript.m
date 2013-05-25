//
//  NSString+JapaneseScript.m
//  iPokedex
//
//  Created by Timothy Oliver on 18/05/11.
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

#import "NSString+JapaneseScript.h"

#define HIRAGANA_START  0x3041
#define HIRAGANA_END    0x309F

#define KATAKANA_START  0x30A1
#define KATAKANA_END    0x30FF

@implementation NSString (JapaneseScript)

+ (BOOL) symbolIsHiragana: (unichar)symbol
{
    return ( symbol >= HIRAGANA_START && symbol <= HIRAGANA_END );
}

+ (BOOL) symbolIsKatakana: (unichar)symbol
{
    return ( symbol >= KATAKANA_START && symbol <= KATAKANA_END );
}

- (BOOL)isJapaneseScript
{
    if( [self length] == 0 )
        return NO;
    
    //for speed sake, we'll only check the first letter
    unichar firstLetter = [self characterAtIndex: 0];
    
    //code is within the hiragana bounds
    if( [NSString symbolIsHiragana: firstLetter] )
        return YES;
    
    //code is within the katakana bounds
    if ( [NSString symbolIsKatakana: firstLetter] )
        return YES;
    
    //code is outside of the bounds
    return NO;
}

- (NSString *)hiraganaScript
{
    NSString *output = @"";
    
    for( NSInteger i = 0; i< [self length]; i++ )
    {
        unichar symbol = [self characterAtIndex: i];
        
        if( [NSString symbolIsKatakana: symbol] == YES )
            symbol = HIRAGANA_START + (symbol-KATAKANA_START);
        
        output = [output stringByAppendingFormat: @"%C", symbol];
    }
    
    return output;
}

- (NSString *)katakanaScript
{
    NSString *output = @"";
    
    for( NSInteger i = 0; i< [self length]; i++ )
    {
        unichar symbol = [self characterAtIndex: i];
        
        if( [NSString symbolIsHiragana: symbol] == YES )
            symbol = KATAKANA_START + (symbol-HIRAGANA_START);
        
        output = [output stringByAppendingFormat: @"%C", symbol];
    }
    
    return output;
}
@end
