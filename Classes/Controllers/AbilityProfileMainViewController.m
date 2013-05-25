//
//  AbilityProfileMainViewController.m
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

#import "AbilityProfileMainViewController.h"
#import "BulbadexStringFormatter.h"
#import "TCGroupedTableSectionHeaderView.h"
#import "TCTableViewCell.h"
#import "UIImage+TabIcon.h"
#import "UITableView+CellRect.h"

#define ABILITY_SECTION_FLAVORTEXT 0

@interface AbilityProfileMainViewController ()

- (void)initExternalLinks;
- (BOOL)inBattleEffectIsVisible;
- (BOOL)outBattleEffectIsVisible;

@end

@implementation AbilityProfileMainViewController

@synthesize dbID, ability, abilityGeneration, flavorTextView, inBattleEffectView, outBattleEffectView, externalLinksView;

- (id)initWithDatabaseID: (NSInteger) databaseID
{
    if( (self = [super initWithStyle: UITableViewStyleGrouped]) )
    {
        self.dbID = databaseID;
        
        self.tabBarItem.title = NSLocalizedString( @"Ability", nil);
        self.tabBarItem.image = [UIImage tabIconWithName: @"Abilities"];
        
        //set ability
        ability = [[Ability alloc] initWithDatabaseID: dbID];
    }
    
    return self;
}

- (void)dealloc
{
    self.ability = nil;
    self.abilityGeneration = nil;
    
    self.flavorTextView = nil;
    self.inBattleEffectView = nil;
    self.outBattleEffectView = nil;   
    self.externalLinksView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    //set the BG color
	self.tableView.sectionFooterHeight = 10.0f;
	self.tableView.sectionHeaderHeight = 0.0f;
    
    //load the ability
    if( ability.loaded == NO ) {
        [ability loadAbility];
        [self initExternalLinks];
        
        self.abilityGeneration = [Generations generationWithDatabaseID: ability.generation];
    }
}

- (void)initExternalLinks
{
    externalLinksView = [[AbilityExternalLinksView alloc] initWithFrame: CGRectMake( 0, 4, 280, EXTERNAL_LINKS_HEIGHT)];
    externalLinksView.targetController = self.parentViewController;
    externalLinksView.generation = ability.generation;
    externalLinksView.hideTitle = YES;
    
    if( LANGUAGE_IS_JAPANESE )
        externalLinksView.abilityName = ability.nameJP;
    else
        externalLinksView.abilityName = ability.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
        
    //set the BG Color off the move
    UIView *background = [[UIView alloc] initWithFrame: self.view.bounds];
    background.backgroundColor =  ability.color;
	self.tableView.backgroundView = background;
    [background release];
    
    //init the table header
    if( self.tableView.tableHeaderView == nil )
    {
        TableHeaderContentView *tableHeader = [[TableHeaderContentView alloc] initWithFrame: CGRectMake( 0, 0, 300, 80)];
        tableHeader.contentIndent = 20;
        if( LANGUAGE_IS_JAPANESE )
        {
            tableHeader.subTitle = ability.name;
            tableHeader.title = ability.nameJP;
        }
        else
        {
            tableHeader.title = ability.name;
            tableHeader.subTitle = [NSString stringWithFormat: @"%@ %@", ability.nameJP, ability.nameJPMeaning];
        }
        
        tableHeader.generation = [NSString stringWithFormat: NSLocalizedString( @"Generation %@", nil), abilityGeneration.name]; 
        
        self.tableView.tableHeaderView = tableHeader;
        [tableHeader release];
    }
    
    //init the flavor text view
    if( flavorTextView == nil )
    {
        flavorTextView = [[TextBoxContentView alloc] initWithFrame: CGRectMake( 0, 0, 280.0f, 1)];
        flavorTextView.flavorText = ability.flavorText; 
    }
    
    if( [ability.inBattleEffect length] > 0 && inBattleEffectView == nil )
    {
        NSString *html = [BulbadexStringFormatter htmlStringWithBulbadexText: ability.inBattleEffect];

        inBattleEffectView = [[WebContentView alloc] initWithFrame: CGRectMake( 0, 0, 280, 44)];
        [inBattleEffectView setHTML: html withBaseURL: [NSURL fileURLWithPath: [[NSBundle mainBundle] resourcePath]] withDelegate: self];
    }
    
    if( [ability.outBattleEffect length] > 0 && outBattleEffectView == nil )
    {
        NSString *html = [BulbadexStringFormatter htmlStringWithBulbadexText: ability.outBattleEffect];
        
        outBattleEffectView = [[WebContentView alloc] initWithFrame: CGRectMake( 0, 0, 280, 44)];
        [outBattleEffectView setHTML: html withBaseURL: [NSURL fileURLWithPath: [[NSBundle mainBundle] resourcePath]] withDelegate: self];
    }    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.ability = nil;
    self.flavorTextView = nil;
    self.inBattleEffectView = nil;
    self.outBattleEffectView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if( [self inBattleEffectIsVisible] && [self outBattleEffectIsVisible] )
        return 4;
    
    if( [self inBattleEffectIsVisible] || [self outBattleEffectIsVisible] )
        return 3;
        
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 )
        return 0.0f;
    
    return GROUP_TABLE_SECTION_HEADER_HEIGHT+2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    switch (section) {
        case 1:
            if( [self inBattleEffectIsVisible] )
                title = NSLocalizedString( @"In-battle Effect", nil);
            else if ( [self outBattleEffectIsVisible] )
                title = NSLocalizedString( @"Out-of-battle Effect", nil);
            else
                title = NSLocalizedString( @"External links", nil );
            break;
        case 2:
            if( [self outBattleEffectIsVisible] )
               title = NSLocalizedString( @"Out-of-battle Effect", nil);
            else
                title = NSLocalizedString( @"External links", nil );
            break;
        case 3:
            title = NSLocalizedString( @"External links", nil );
            break;
    }

    if( [title length] > 0 )
    {
        TCGroupedTableSectionHeaderView *headerView = [[TCGroupedTableSectionHeaderView alloc] initWithTitle: title];
        headerView.alpha = 1.0f;
        return [headerView autorelease];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return the number of rows in the section.
	switch( indexPath.section )
	{
		case ABILITY_SECTION_FLAVORTEXT:
            flavorTextView.frame = [self.tableView boundsRectWithCellRect: flavorTextView.frame widthInset: 10.0f];
			return [flavorTextView height]+20;
        case 1:
            if( [self inBattleEffectIsVisible] )
            {
                //Reload the view to the right height
                [inBattleEffectView setHeightOffWebView];
                return [inBattleEffectView height]+24;
            }
            else if ( [self outBattleEffectIsVisible] )
            {
                //Reload the view to the right height
                [outBattleEffectView setHeightOffWebView];
                return [outBattleEffectView height]+24;
            }
            else
                return EXTERNAL_LINKS_HEIGHT;
            break;
        case 2: 
            if( [self outBattleEffectIsVisible] )
            {
                //Reload the view to the right height
                [outBattleEffectView setHeightOffWebView];
                return [outBattleEffectView height]+24;
            }
            else
                return EXTERNAL_LINKS_HEIGHT;
        case 3:
            return EXTERNAL_LINKS_HEIGHT;
            break;
        default:
			return 45;
	}
	
	return 45;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AbilityContentCell";
    
    TCTableViewCell *cell = (TCTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
	}

	switch ( indexPath.section )
	{
		case ABILITY_SECTION_FLAVORTEXT:
			flavorTextView.frame = CGRectInset( cell.contentView.bounds, 10.0f, 12.0f );
			cell.drawView = flavorTextView;
			break;
        case 1:
            if( [self inBattleEffectIsVisible] )
            {
                inBattleEffectView.frame = CGRectInset( cell.contentView.bounds, 10.0f, 12.0f );
                cell.drawView = inBattleEffectView;
            }
            else if( [self outBattleEffectIsVisible] )
            {
                outBattleEffectView.frame = CGRectInset( cell.contentView.bounds, 10.0f, 12.0f );
                cell.drawView = outBattleEffectView;       
            }else
            {
                externalLinksView.frame = CGRectMake( 7, 11, cell.contentView.frame.size.width-14, cell.contentView.frame.size.height-14 ); 
                cell.drawView = externalLinksView;
            } 
            
            break;
        case 2:
            if( [self outBattleEffectIsVisible] )
            {
                outBattleEffectView.frame = CGRectInset( cell.contentView.bounds, 10.0f, 12.0f );
                cell.drawView = outBattleEffectView;
            }
            else
            {
                externalLinksView.frame = CGRectMake( 7, 11, cell.contentView.frame.size.width-14, cell.contentView.frame.size.height-14 );
                cell.drawView = externalLinksView;
            }               
                break;
        case 3:
            externalLinksView.frame = CGRectMake( 7, 11, cell.contentView.frame.size.width-14, cell.contentView.frame.size.height-14 );
            cell.drawView = externalLinksView;            
            break;
        default:
            break;
	}
	
    return cell;
}

#pragma mark Visibility
- (BOOL)inBattleEffectIsVisible
{
    return [ability.inBattleEffect length] > 0;
}

- (BOOL)outBattleEffectIsVisible
{
    return [ability.outBattleEffect length] > 0;
}

#pragma mark UIWebViewDelegates
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if( [webView isEqual: inBattleEffectView.webView] )
    {
        [inBattleEffectView loadingComplete];
    }
        
    if( [webView isEqual: outBattleEffectView.webView] )
    {
        [outBattleEffectView loadingComplete];
    }
    
    //reload the tables if they're done
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if(navigationType == UIWebViewNavigationTypeOther)
		return YES;
 
    //handle the request
    [BulbadexStringFormatter handleLocalURLRequestWithURL: request.URL fromController: self];
    
    return NO;
}

#pragma mark -
#pragma mark Statistics Tracking
- (NSString *)tagTitle
{
    return @"";
}

@end
