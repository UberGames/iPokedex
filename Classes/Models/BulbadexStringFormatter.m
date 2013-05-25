//
//  BulbadexStringFormatter.m
//  iPokedex
//
//  Created by Timothy Oliver on 12/03/11.
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

#import "BulbadexStringFormatter.h"

#import "PokemonEntryFinder.h"
#import "PokemonProfileTabController.h"
#import "MoveEntryFinder.h"
#import "MoveProfileTabController.h"
#import "AbilityEntryFinder.h"
#import "AbilityProfileTabController.h"

#define BULBADEX_BOLD @"**"
#define BULBADEX_LINK_START @"{{"
#define BULBADEX_LINK_END @"}}"
#define BULBADEX_LINKS [NSArray arrayWithObjects: @"ability",  @"move", @"p", @"item", nil]
#define BULBADEX_LINKS_REPLACE [NSArray arrayWithObjects: @"ipokedex://ability/?name=", \
                                                            @"ipokedex://move/?name=", \
                                                            @"ipokedex://pokemon/?name=", @"", nil];

#define BULBADEX_HTML_FRAME @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\
                                <html xmlns=\"http://www.w3.org/1999/xhtml\"> \
                                <head> \
                                <link rel=\"stylesheet\" type=\"text/css\" href=\"CSS/TableCell.css\" /> \
                                <meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0;\"> \
                                <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /> \
                                <script type=\"text/javascript\"> \
                                document.onload = function(){ \
                                document.ontouchmove = function(e){ e.preventDefault(); } \
                                }; \
                                </script> \
                                </head> \
                                <body> \
                                %@ \
                                </body> \
                                </html>"

@implementation BulbadexStringFormatter

+ (NSString *)htmlStringWithBulbadexText: (NSString *)entryText
{ 
    NSArray *links = BULBADEX_LINKS;
    NSArray *replaceLinks = BULBADEX_LINKS_REPLACE;
    NSString *outputText = entryText;
    
    //format the bold
    NSRange start = NSMakeRange(0, [outputText length]);
    while (start.location != NSNotFound)
    {
        start = [outputText rangeOfString: BULBADEX_BOLD];
        if ( start.location == NSNotFound )
            break;
        
        //get the end
        NSRange end = [outputText rangeOfString: BULBADEX_BOLD options: NSCaseInsensitiveSearch range: NSMakeRange( start.location+start.length, [outputText length]-(start.location+start.length)) ];
        if( end.location == NSNotFound )
            break;
        
        NSString *content = [outputText substringWithRange: NSMakeRange( start.location+start.length, end.location-(start.location+start.length) )];
        
        //build the find/replace parameters
        NSString *search = [NSString stringWithFormat: @"%@%@%@", BULBADEX_BOLD, content, BULBADEX_BOLD];
        NSString *replace = [NSString stringWithFormat: @"%@%@%@", @"<strong>", content, @"</strong>"];
        
        //replace
        outputText = [outputText stringByReplacingOccurrencesOfString: search withString: replace]; 
    }
    
    //format the links
    start = NSMakeRange(0, [outputText length]);
    while(start.location != NSNotFound)
    {
        start = [outputText rangeOfString: BULBADEX_LINK_START];
        
        if ( start.location == NSNotFound )
            break;
        
        //get the end
        NSRange end = [outputText rangeOfString: BULBADEX_LINK_END];
        
        //calculate the midpoint
        NSString *midPoint = [outputText substringWithRange: NSMakeRange(start.location+start.length, end.location-(start.location+start.length))];
        
        //derive the values (Assuming the string is now 'ability|name' etc)
        NSArray *linkKeyValue = [midPoint componentsSeparatedByString: @"|"];
        NSString *keyName = [linkKeyValue objectAtIndex: 0]; //'ability'
        NSString *entryName = [linkKeyValue lastObject]; //'name'
        
        //find what type it is
        NSInteger index = [links indexOfObject: keyName];
        
        //generate the name
        NSString *search = [NSString stringWithFormat: @"%@%@%@", BULBADEX_LINK_START, midPoint, BULBADEX_LINK_END];
        
        //format for URL conformance
        NSString *urlName = [entryName stringByReplacingOccurrencesOfString: @" " withString: @"_"];
        
        //generate final release format
        NSString *replaceString = [replaceLinks objectAtIndex:index];
        
        //if there is no replace value, strip out the whole thing
        NSString *replace = @"";
        if( [replaceString length] > 0 )
            replace = [NSString stringWithFormat: @"<a href=\"%@%@\">%@</a>", replaceString, urlName, entryName];
        else
            replace = entryName;
        
        //replace
        outputText = [outputText stringByReplacingOccurrencesOfString: search withString: replace];        
    }
    
    //format with line breaks
    outputText = [[outputText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"<br/>\n"];

    //place the output inside a properly HTNML formatted framework
    outputText = [NSString stringWithFormat: BULBADEX_HTML_FRAME, outputText];
    
    return outputText;
}

+ (void) handleLocalURLRequestWithURL: (NSURL *)url fromController: (UIViewController *)controller
{
    NSArray *parameters = [[[url.absoluteString componentsSeparatedByString: @"?"] objectAtIndex:1] componentsSeparatedByString: @"&"];
    NSString *name = @"";
 
    //retrieve the name parameter
    for( NSString *parameter in parameters )
    {
        if( [parameter rangeOfString: @"name="].location == NSNotFound )
            continue;
        
        name = [[parameter componentsSeparatedByString: @"="] lastObject];
    }
    
    if( [name length] <= 0 )
        return;
    
    name = [name stringByReplacingOccurrencesOfString: @"_" withString: @" "];
    
    if( [url.host isEqualToString: @"ability"] )
    {
        NSInteger dbID = [AbilityEntryFinder databaseIDOfAbilityWithName: name];
        if( dbID )
        {
            AbilityProfileTabController *abilityController = [[AbilityProfileTabController alloc] initWithDatabaseID: dbID abilityEntry: nil];
            if( controller.parentViewController.navigationController )
                [controller.parentViewController.navigationController pushViewController: abilityController animated: YES];
            else
                [controller.navigationController pushViewController: abilityController animated: YES];
            [abilityController release];
        }
    }
    else if( [url.host isEqualToString: @"move"] )
    {
        NSInteger dbID = [MoveEntryFinder databaseIDOfMoveWithName: name];
        if( dbID )
        {
            MoveProfileTabController *moveController = [[MoveProfileTabController alloc] initWithDatabaseID: dbID moveEntry: nil];
            if( controller.parentViewController.navigationController )
                [controller.parentViewController.navigationController pushViewController: moveController animated: YES];
            else
                [controller.navigationController pushViewController: moveController animated: YES];
            [moveController release];
        }
    }
    else if( [url.host isEqualToString: @"pokemon"] )
    {
        NSInteger dbID = [PokemonEntryFinder databaseIDOfPokemonWithName: name];
        if( dbID )
        {
            PokemonProfileTabController *pokemonController = [[PokemonProfileTabController alloc] initWithDatabaseID: dbID pokemonEntry: nil];
            if( controller.parentViewController.navigationController )
                [controller.parentViewController.navigationController pushViewController: pokemonController animated: YES];
            else
                [controller.navigationController pushViewController: pokemonController animated: YES];
            [pokemonController release];
        }
    }
}

@end
