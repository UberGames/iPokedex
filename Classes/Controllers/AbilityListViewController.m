//
//  AbilityListViewController.m
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

#import "AbilityListViewController.h"
#import "UIImage+TabIcon.h"

@implementation AbilityListViewController

- (id)init 
{
    if ( (self = [super init]) )
    {
        //set this view's title
        self.tableCellIdentifier = @"AbilityEntryCell";	
        
        self.tabBarItem.title = NSLocalizedString(@"Abilities", @"");
        self.tabBarItem.image = [UIImage tabIconWithName: @"Abilities"];  
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.title = NSLocalizedString(@"Abilities", nil);
    self.footerCountMessage = NSLocalizedString( @"%d Abilities", nil );
}

- (NSArray *) loadTableContent
{
	return [AbilityEntryFinder abilitiesFromDatabase];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

#pragma mark - View lifecycle

-(BOOL) sectionIndexIsVisible
{
	return YES;
}

-(BOOL) sectionHeadersAreVisible
{
	return YES;
}

-(void) buildSectionHeaders
{
	NSDictionary *sectionEntries = [EntryFinder alphabeticalSectionEntryListWithEntries: tableEntries];
	self.sectionHeaderTitles = [EntryFinder alphabeticalSectionHeaderTitleListWithDictionary: sectionEntries];
	self.sectionHeaderEntries = [EntryFinder alphabeticalSectionHeaderEntryListWithDictionary: sectionEntries titleList: self.sectionHeaderTitles];
}

-(void) buildSectionIndex
{
	//bit of a hack, but since it's the same content, we can make it a tad more efficient by sharing
	self.sectionIndexTitles = [EntryFinder alphabeticalSectionIndexTitleListWithSectionHeaderTitleList: self.sectionHeaderTitles search: YES];
}


#pragma mark - Table Delegates

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL isSearch = ( _tableView == searchController.searchResultsTableView );
	
	//generate a cell from the class parent
	UITableViewCell *cell = [super tableView: _tableView cellForRowAtIndexPath: indexPath];	
	
	ListEntry *ability;
	if( isSearch )
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		ability = [tableSearchedEntries objectAtIndex: indexPath.row];
    }
	else
    {
		ability = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
	}
        
	cell.textLabel.text = ability.name;
    
    if( isSearch && searchWasWithLanguage )
        cell.detailTextLabel.text = ability.nameAlt;
    else
        cell.detailTextLabel.text = ability.caption;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL isSearch = ( _tableView == searchController.searchResultsTableView );
    
    //play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];	
	
    ListEntry *ability;
	if( isSearch )
		ability = [tableSearchedEntries objectAtIndex: indexPath.row];
	else
		ability = [[sectionHeaderEntries objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
    
	AbilityProfileTabController *abilityController = [[AbilityProfileTabController alloc] initWithDatabaseID: ability.dbID abilityEntry: ability];
	[self.parentViewController.navigationController pushViewController: abilityController animated: YES];
	[abilityController release];
}

#pragma mark - 
#pragma mark Tag Title
- (NSString *)tagTitle
{
    return @"Abilities";
}

@end
