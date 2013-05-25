//
//  EggGroupsListViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 6/03/11.
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

#import "EggGroupsListViewController.h"
#import "UIImage+TabIcon.h"
#import "UIViewController+TagTitle.h"

@implementation EggGroupsListViewController

#pragma mark -
#pragma mark View lifecycle

- (id)init
{
    if( (self = [super init]) )
    {
        //set this view's title
        self.tableCellIdentifier = @"EggGroupEntryCell";	
        
        self.tabBarItem.title = NSLocalizedString(@"Egg Groups", @"Nav Title");
        self.tabBarItem.image = [UIImage tabIconWithName: @"Eggs" ];        
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.title = NSLocalizedString(@"Egg Groups", @"Nav Title");
    self.footerCountMessage = NSLocalizedString( @"%d Egg Groups", nil );
}

- (NSArray *) loadTableContent
{
	return [EggGroupEntryFinder eggGroupsFromDatabase];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

#pragma mark -
#pragma mark Memory management


#pragma mark -
#pragma mark Table view data source


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL isSearch = ( _tableView == searchController.searchResultsTableView );
	
    //create a cell
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier: self.tableCellIdentifier];
    if( cell == nil )
    {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: self.tableCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	ListEntry *egg;
	if( isSearch )
		egg = [tableSearchedEntries objectAtIndex: indexPath.row];
	else
		egg = [tableEntries objectAtIndex: indexPath.row];
	
	cell.textLabel.text = egg.name;
    
    if( isSearch && searchWasWithLanguage )
        cell.detailTextLabel.text = egg.nameAlt;
    else
        cell.detailTextLabel.text = nil;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];	
	
	ListEntry *eggGroup = [tableEntries objectAtIndex: indexPath.row];
	
	EggGroupMainViewController *eggController = [[EggGroupMainViewController alloc] initWithEggGroup1ID: eggGroup.dbID];
	[self.parentViewController.navigationController pushViewController: eggController animated: YES];
	[eggController release];
}

#pragma mark - 
#pragma mark Tag Title
- (NSString *)tagTitle
{
    return @"Egg_Groups";
}

@end

