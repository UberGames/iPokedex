//
//  CopyrightTabController.m
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

#import "CopyrightViewController.h"
#import "UIScreen+isRetinaDisplay.h"
#import "LicenseViewController.h"
#import "GANTracker.h"

#define COPYRIGHT_HTML_PATH @"HTML/Legal%@.html"

@implementation CopyrightViewController

#pragma mark -
#pragma mark Initialization
- (id)init
{
    NSString *fileName = [NSString stringWithFormat: COPYRIGHT_HTML_PATH, [[Languages sharedLanguages] currentLanguageSuffixWithUnderscore: NO inCapitals: YES]];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcePath stringByAppendingPathComponent: fileName];
    NSURL *_baseURL = [NSURL fileURLWithPath: resourcePath];
    
    if( (self = [super initWithURL: htmlPath withBaseURL: _baseURL]) )
     {
         
     }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = NSLocalizedString(@"Legal", @"Legal Title");
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [[GANTracker sharedTracker] trackPageview: @"/iPokédex/Copyright" withError: nil];
    //NSLog( @"Logged GAN Dispatch: /iPokédex/Copyright" );
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //License Pages
    if( [request.URL.scheme isEqualToString: @"ipokedex"] )
    {
        if( [request.URL.host isEqualToString: @"veekun_mit"] )
        {
            LicenseViewController *veekunController = [[LicenseViewController alloc] initWithHTMLFile: @"HTML/Licenses/VeekunMITLicense.html" withTitle: @"Veekun MIT License" withTagTitle:@"VeekunMITLicense"];
            [self.navigationController pushViewController: veekunController animated: YES];
            [veekunController release];
        }
        else if( [request.URL.host isEqualToString: @"fmdatabase_mit"] )
        {
            LicenseViewController *fmDatabaseController = [[LicenseViewController alloc] initWithHTMLFile: @"HTML/Licenses/FMDatabaseMITLicense.html" withTitle: @"FMDatabase MIT License" withTagTitle:@"FMDatabaseMITLicense"];
            [self.navigationController pushViewController: fmDatabaseController animated: YES];
            [fmDatabaseController release];           
        }
        else if( [request.URL.host isEqualToString: @"appirater_mit"] )
        {
            LicenseViewController *appiraterController = [[LicenseViewController alloc] initWithHTMLFile: @"HTML/Licenses/AppiraterMITLicense.html" withTitle: @"Appirater MIT License" withTagTitle:@"AppiraterMITLicense"];
            [self.navigationController pushViewController: appiraterController animated: YES];
            [appiraterController release];            
        }
        else if( [request.URL.host isEqualToString: @"creative_commons"] )
        {
            LicenseViewController *ccController = [[LicenseViewController alloc] initWithHTMLFile: @"HTML/Licenses/CCAttributionNonCommercialShareAlikeLicense.html" withTitle: @"Creative Commons Agreement" withTagTitle: @"CCAttributionNonCommercialShareAlikeLicense"];
            [self.navigationController pushViewController: ccController animated: YES];
            [ccController release];
        }
        else if( [request.URL.host isEqualToString: @"iask_bsd"] )
        {
            LicenseViewController *iaskController = [[LicenseViewController alloc] initWithHTMLFile: @"HTML/Licenses/IASKBSDLicense.html" withTitle: @"InAppSettingsKit BSD License" withTagTitle: @"IASKBSDLicense"];
            [self.navigationController pushViewController: iaskController animated: YES];
            [iaskController release];
        }
        else if( [request.URL.host isEqualToString: @"tbxml_mit"] )
        {
            LicenseViewController *tbxmlController = [[LicenseViewController alloc] initWithHTMLFile: @"HTML/Licenses/TBXMLMITLicense.html" withTitle:@"TBXML MIT License" withTagTitle: @"TBXMLMITLicense"];
            [self.navigationController pushViewController: tbxmlController animated: YES];
            [tbxmlController release];
        }
            
        return NO;
    }
    
	//if the mail button is clicked, set up a mail message
    if( [request.URL.scheme isEqualToString: @"mailto"] )
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients: [NSArray arrayWithObject: @"admin@ubergames.org"]];
        [controller setSubject: NSLocalizedString(@"iPokédex Query", nil)];
        if (controller)
            [self presentModalViewController:controller animated:YES];
        [controller release];
        
		return NO;
    } 
    
    return [super webView: webView shouldStartLoadWithRequest: request navigationType: navigationType];
}

#pragma mark Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    [self dismissModalViewControllerAnimated:YES];
}


@end

