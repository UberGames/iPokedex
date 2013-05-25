//
//  AboutTabController.m
//  iPokedex
//
//  Created by Timothy Oliver on 29/11/10.
//  Copyright 2010 UberGames. All rights reserved.
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

#import "AboutViewController.h"
#import "UIImage+ImageLoading.h"
#import "UIColor+HexString.h"
#import "TCGroupedTableSectionHeaderView.h"
#import "AboutTableHeaderView.h"
#import "AboutTableSourcesView.h"
#import "AboutTableArtists.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "GANTracker.h"
#import "TCWebLinker.h"
#import "TCTableViewCell.h"

#define SECTION_MAIN    0
#define SECTION_CREDITS 1

#define ABOUT_ACTIONSHEET_HOMEPAGE  0
#define ABOUT_ACTIONSHEET_TIM       1
#define ABOUT_ACTIONSHEET_ARTISTS   2
#define ABOUT_ACTIONSHEET_THANKS    3
#define ABOUT_ACTIONSHEET_SHOUTOUT  4

#define ABOUT_HEIGHT 70
#define ABOUT_THANKS_NAMES [NSArray arrayWithObjects: @"peppyhax", @"lordmortis", @"jetha", @"sonictail", @"ellji", @"kodex", nil]

#define ABOUT_ARTISTS_NAMES [NSArray arrayWithObjects: @"Xous54", @"PokeFaktory", nil]
#define ABOUT_ARTISTS_WORKS [NSArray arrayWithObjects: [NSArray arrayWithObjects: NSLocalizedString(@"Meloetta",nil), NSLocalizedString( @"Keldeo", nil ), nil], \
                                                        [NSArray arrayWithObjects: NSLocalizedString( @"Darmanitan Zen", nil), NSLocalizedString( @"Genesect", nil), nil], nil]
#define ABOUT_ARTISTS_URL           @"http://%@.deviantart.com/"
#define ABOUT_ARTISTS_LINK_NAMES    [NSArray arrayWithObjects: @"xous54", @"pokefaktory", nil]

#define ABOUT_UBERGAMES_PAGE    @"http://www.ubergames.org/projects/ipokedex"

#define ABOUT_TIM_TWITTER       @"http://www.twitter.com/tim0liver"
#define ABOUT_TIM_TWITTER_JP    @"http://www.twitter.com/Tim_JA"
#define ABOUT_TIM_BLOG          @"http://www.tim-oliver.com"

#define ABOUT_EGORAPTOR_ORIGINAL_VIDEO  @"http://www.youtube.com/watch?v=CugguiCVfPw"
#define ABOUT_EGORAPTOR_NEWGROUNDS      @"http://egoraptor.newgrounds.com"
#define ABOUT_EGORAPTOR_YOUTUBE         @"http://www.youtube.com/user/egoraptor"
#define ABOUT_EGORAPTOR_EGORAPTORNET    @"http://www.egoraptor.net"

#define ABOUT_DONATE_LINK @"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=8FZUPVWWQBYTL"

@interface AboutViewController ()

- (void)initHeader;
- (void)initCopyright;
- (void)initThanksBar;
- (void)initSources;
- (void)initArtists;

@end

@implementation AboutViewController

@synthesize aboutSheet, uberGamesCopyright, thanksView, artistsView;

#pragma mark -
#pragma mark Initialization

- (id)init {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle: UITableViewStyleGrouped ])) {
		
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = NSLocalizedString(@"About", @"About Title");
	self.tableView.backgroundColor = [UIColor colorWithHexString: @"#e2e5e9"];
    self.tableView.sectionHeaderHeight = 9.0f;
    self.tableView.sectionFooterHeight = 9.0f;
    
    //init the header cell
    [self initHeader];
    //init copyright notice
    [self initCopyright];
    //init the thanks view
    [self initThanksBar];
    //init Sources
    [self initSources];
    //init Artists
    [self initArtists];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [[GANTracker sharedTracker] trackPageview: @"/iPokédex/About" withError: nil];
    //NSLog( @"Logged GAN Dispatch: /iPokédex/About" );
}

#pragma mark Init Code
- (void)initHeader
{
    AboutTableHeaderView *headerView = [[AboutTableHeaderView alloc] init];
    headerView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableHeaderView = headerView;
    [headerView release]; 
}

- (void)initCopyright
{
    uberGamesCopyright = [[UIView alloc] initWithFrame: CGRectMake( 0, 12, 280, 40)];
    uberGamesCopyright.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    uberGamesCopyright.backgroundColor = [UIColor whiteColor];
    
    CGRect drawRect = CGRectMake( 0, 0, 280, 15);
    
    //Top
    /*drawRect.origin.y = 40;
    UILabel *copyRightLabelTop = [[UILabel alloc] initWithFrame: drawRect];
    copyRightLabelTop.text = @"www.ubergames.org";
    copyRightLabelTop.font = [UIFont systemFontOfSize: 14.0f];
    copyRightLabelTop.textAlignment = UITextAlignmentCenter;
    
    [uberGamesCopyright addSubview: copyRightLabelTop];
    [copyRightLabelTop release];*/
    
    //MIddlecopyright notice
    drawRect.origin.y = 0;
    UILabel *copyRightLabelMiddle = [[UILabel alloc] initWithFrame: drawRect];
    copyRightLabelMiddle.text = NSLocalizedString( @"iPokédex © UberGames 2010-2011", nil );
    copyRightLabelMiddle.font = [UIFont systemFontOfSize: 14.0f];
    copyRightLabelMiddle.textAlignment = UITextAlignmentCenter;
    
    [uberGamesCopyright addSubview: copyRightLabelMiddle];
    [copyRightLabelMiddle release];
    
    //Bottom copyright notice
    drawRect.origin.y = 20;
    UILabel *copyRightLabelBottom = [[UILabel alloc] initWithFrame: drawRect];
    copyRightLabelBottom.text = NSLocalizedString( @"All rights reserved.", nil );
    copyRightLabelBottom.font = [UIFont systemFontOfSize: 14.0f];
    copyRightLabelBottom.textAlignment = UITextAlignmentCenter;
    
    [uberGamesCopyright addSubview: copyRightLabelBottom];
    [copyRightLabelBottom release];
}

- (void)initThanksBar
{
    NSArray *thanksNames = ABOUT_THANKS_NAMES;
    
    thanksView = [[AboutTableThanksView alloc] initWithFrame: CGRectMake( 83, 0, 195, 1 )];
    
    NSMutableArray *thanksViewNames = [[NSMutableArray alloc] init];
    //generate the names too assign
    for( NSString *name in thanksNames )
        [thanksViewNames addObject: [NSString stringWithFormat: @"@%@", name]];
         
    thanksView.names = thanksViewNames;
    [thanksViewNames release];
}

-(void)initSources
{
    //set up the footer view
    AboutTableSourcesView *footerView = [[AboutTableSourcesView alloc] init];
    footerView.targetController = self;
    self.tableView.tableFooterView = footerView;
    [footerView release];
}

-(void)initArtists
{
    artistsView = [[AboutTableArtists alloc] initWithFrame: CGRectMake( 0, 0, 320, 55 )];
    artistsView.names = ABOUT_ARTISTS_NAMES;
    artistsView.artPieces = ABOUT_ARTISTS_WORKS;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.uberGamesCopyright = nil;
    self.aboutSheet = nil;
    self.thanksView = nil;
    self.artistsView = nil;
    
    [super viewDidUnload];
}

- (void)dealloc {
    [uberGamesCopyright release];
    [aboutSheet release];
    [thanksView release];
    [artistsView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section )
    {
        case SECTION_MAIN: 
            return 4;
        case SECTION_CREDITS:
            return 4;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    if ( indexPath.section == SECTION_MAIN && indexPath.row == 3 )
        return 60.0f;
    else if ( indexPath.section == SECTION_CREDITS && indexPath.row == 2 )
        return [thanksView frameHeight]+20;
    else if ( indexPath.section == SECTION_CREDITS && indexPath.row == 1 )
        return [artistsView frameHeight]+15;
        
	return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch( section )
    {
        case SECTION_CREDITS:
            return GROUP_TABLE_SECTION_HEADER_HEIGHT+2;
    }
    
    return tableView.sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TCGroupedTableSectionHeaderView *headerView = nil;
    
    switch (section)
    {
        case SECTION_CREDITS:
            headerView = [[[TCGroupedTableSectionHeaderView alloc] initWithTitle: NSLocalizedString( @"Credits / Special Thanks", nil )] autorelease];
            break;            
    }
    
    return headerView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifierEmpty = @"AboutCell";
    static NSString *cellIdentifierValue2 = @"AboutCellValue2";
    
    TCTableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case SECTION_MAIN:
        {
            cell = (TCTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifierEmpty];
            if( cell == nil )
            {
                cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifierEmpty] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
            }
            
            switch( indexPath.row )
            {
                case 0: 
                    //set the cell as tappable
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    
                    cell.textLabel.text = NSLocalizedString( @"Official iPokédex Homepage", nil );
                    break;
                case 1:
                    //set the cell as tappable
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    
                    cell.textLabel.text = NSLocalizedString( @"Send us feedback/report bugs", nil );
                    break;
                case 2:
                    //set the cell as tappable
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;                    
                    
                    cell.textLabel.text = NSLocalizedString( @"Donate to the developer", nil );
                    break;
                case 3:
                    //set the cell as blank/untappable
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    //set the content view to remove any offsets
                    cell.contentView.frame = CGRectInset(cell.bounds, 1.0f, 1.0f);
                    
                    //re-align UberGames to fit it
                    CGRect drawRect = uberGamesCopyright.frame;
                    drawRect.origin.x = (cell.contentView.frame.size.width/2)-(drawRect.size.width/2);
                    uberGamesCopyright.frame = drawRect;
                    
                    [cell.contentView addSubview: uberGamesCopyright];
                    break;
            }
        }
            break;
        case SECTION_CREDITS: 
            cell = (TCTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifierValue2];
            if( cell == nil )
            {
                cell = [[[TCTableViewCell alloc] initWithStyle: UITableViewCellStyleValue2 reuseIdentifier: cellIdentifierValue2] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            cell.drawView = nil;
            
            switch( indexPath.row )
            {
                case 0:
                    cell.textLabel.text = NSLocalizedString( @"Developer", nil );
                    cell.detailTextLabel.text = NSLocalizedString( @"Timothy 'TiM' Oliver", nil );
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString( @"Art", nil );
                    cell.detailTextLabel.text = @"";
                    
                    artistsView.frame = CGRectMake(83, 8, cell.contentView.frame.size.width-85, 55);
                    cell.drawView = artistsView;
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString( @"Thanks", nil );
                    cell.detailTextLabel.text = @"";
                    
                    //insert the thanks view
                    thanksView.frame = CGRectMake( 83, 8, cell.contentView.frame.size.width-85, 1);
                    cell.drawView = thanksView;
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString( @"Shout-out", nil );
                    cell.detailTextLabel.text = NSLocalizedString( @"Arin 'Egoraptor' Hanson", nil );
                    break;
            }
            break;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//play deselect animation
	[_tableView deselectRowAtIndexPath: indexPath animated: YES ];	
    
    switch (indexPath.section )
    {
        case SECTION_MAIN:
            switch ( indexPath.row ) {
                case 0: //UberGames Homepage
                    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_UBERGAMES_PAGE] fromController: self];
                    
                    break;
                case 1: //UberGames mail
                {
                    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                    controller.mailComposeDelegate = self;
                    [controller setToRecipients: [NSArray arrayWithObject: @"feedback@ubergames.org"]];
                    [controller setSubject: NSLocalizedString( @"iPokédex Feedback", nil )];
                    if (controller) { [self presentModalViewController:controller animated:YES]; }
                    [controller release];
                }
                    break;
                case 2: {
                    [[TCWebLinker sharedLinker] openURLInSafari: [NSURL URLWithString: ABOUT_DONATE_LINK] fromController: self];
                }
                    break;
                default:
                    break;
            }
            break;
        case SECTION_CREDITS:
            switch ( indexPath.row )
            {
                case 0: //TiM. Oh jeez. THAT guy. XD
                {
                    aboutSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString( @"Timothy 'TiM' Oliver", nil )
                                                             delegate: self 
                                                    cancelButtonTitle: NSLocalizedString( @"Cancel", nil ) 
                                               destructiveButtonTitle: nil 
                                                    otherButtonTitles: NSLocalizedString( @"Twitter", nil ), NSLocalizedString( @"Blog", nil ), nil];
                    aboutSheet.tag = ABOUT_ACTIONSHEET_TIM;
                    [aboutSheet showInView: self.parentViewController.view];
                }
                    break;
                case 1: //The dudes who let me use their artwork
                    aboutSheet = [[UIActionSheet alloc] initWithTitle: @"http://www.deviantart.com/"
                                                             delegate: self 
                                                    cancelButtonTitle: nil 
                                               destructiveButtonTitle: nil 
                                                    otherButtonTitles: nil ];
                    aboutSheet.tag = ABOUT_ACTIONSHEET_ARTISTS;
                    
                    NSArray *artistNames = ABOUT_ARTISTS_NAMES;
                    
                    for( NSString *artistName in artistNames )
                        [aboutSheet addButtonWithTitle: artistName];
                    
                    //set cancel button
                    [aboutSheet addButtonWithTitle: NSLocalizedString( @"Cancel", nil )];
                    [aboutSheet setCancelButtonIndex: [artistNames count]];
                    
                    [aboutSheet showInView: self.parentViewController.view];
                    break;
                case 2: //The dudes who put up with me talking about this thing XD
                {
                    NSMutableArray *names = [[NSMutableArray alloc] init];
                    //put '@' in front of each name
                    for( NSString *name in ABOUT_THANKS_NAMES )
                        [names addObject: [NSString stringWithFormat: @"@%@", name]];
                        
                    aboutSheet = [[UIActionSheet alloc] initWithTitle: @"http://www.twitter.com/"
                                                             delegate: self 
                                                    cancelButtonTitle: nil 
                                               destructiveButtonTitle: nil 
                                                    otherButtonTitles: nil ];
                    aboutSheet.tag = ABOUT_ACTIONSHEET_THANKS;
                    
                    //add the buttons from the arry
                    for( NSString *name in names )
                        [aboutSheet addButtonWithTitle: name ];
                    
                    //add cancel button
                    [aboutSheet addButtonWithTitle: NSLocalizedString(@"Cancel",nil)];
                    aboutSheet.cancelButtonIndex = [names count];
                    
                    [aboutSheet showInView: self.parentViewController.view];
                    
                    [names release];
                    break;
                }
                case 3: //Egoraptor. Epic win is epic
                {
                    aboutSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString( @"Arin 'Egoraptor' Hanson", nil )
                                                             delegate: self 
                                                    cancelButtonTitle: NSLocalizedString( @"Cancel", nil )
                                               destructiveButtonTitle: nil 
                                                    otherButtonTitles: @"Original Video", @"Newgrounds.com", @"YouTube", nil];
                    aboutSheet.tag = ABOUT_ACTIONSHEET_SHOUTOUT;
                    [aboutSheet showInView: self.parentViewController.view];                    
                
                }
                    break;
            }
            break;
    }
}
 
#pragma mark ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch ( actionSheet.tag )
    {
        case ABOUT_ACTIONSHEET_HOMEPAGE:

            break;
        case ABOUT_ACTIONSHEET_TIM:
            switch (buttonIndex) {
                case 0: //Twitter
                    if( LANGUAGE_IS_JAPANESE )
                        [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_TIM_TWITTER_JP] fromController: self];
                    else
                        [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_TIM_TWITTER] fromController: self];
                    break;
                case 1: //Blog
                    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_TIM_BLOG] fromController: self];
                    break;
                case 2:
                default:
                    break;
            }
            break;
        case ABOUT_ACTIONSHEET_ARTISTS:
        {
            NSArray *urlNames = ABOUT_ARTISTS_LINK_NAMES;
            if ( buttonIndex < [urlNames count] )
            {
                NSString *url = [NSString stringWithFormat: ABOUT_ARTISTS_URL, [urlNames objectAtIndex: buttonIndex]];
                [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: url] fromController: self];
            }
        }
            break;
        case ABOUT_ACTIONSHEET_THANKS:
            {
                if( buttonIndex < [ABOUT_THANKS_NAMES count] )
                {
                    NSString *twitterName = [ABOUT_THANKS_NAMES objectAtIndex: buttonIndex];
                    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: [NSString stringWithFormat: @"http://www.twitter.com/%@", twitterName]] fromController: self];
                }
            }
            break;
        case ABOUT_ACTIONSHEET_SHOUTOUT:
            switch (buttonIndex) {
                case 0:
                    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_EGORAPTOR_ORIGINAL_VIDEO] fromController: self];
                    break;
                case 1: //Newgrounds.com
                    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_EGORAPTOR_NEWGROUNDS] fromController: self];
                    break;
                case 2: //YouTube Account
                    [[TCWebLinker sharedLinker] openURL: [NSURL URLWithString: ABOUT_EGORAPTOR_YOUTUBE] fromController: self];
                    break;
                case 3:
                default:
                    break;
            }            
            break;
    }
    
    self.aboutSheet = nil;
}


#pragma mark Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    [self dismissModalViewControllerAnimated:YES];
}


@end

