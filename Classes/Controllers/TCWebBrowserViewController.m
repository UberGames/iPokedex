//
//  TCWebBrowserViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 13/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCWebBrowserViewController.h"
#import "UIImage+ImageLoading.h"

#define NAV_IMAGES_PATH @"Images/Interface/"
#define TOOLBAR_HEIGHT 44

//array keys
#define ITEM_BACK 0
#define ITEM_SPACE_1
#define ITEM_FORWARD 2
#define ITEM_SPACE_2 3
#define ITEM_REFRESH 4
#define ITEM_SPACE_3 5
#define ITEM_MORE 6

@interface TCWebBrowserViewController (hidden)

- (void)setToolBarLoading: (BOOL)loading;

@end

@implementation TCWebBrowserViewController

@synthesize toolBarView, webContentView, url, refreshButton, stopButton, loadingIndicator;

- (id)initWithURL: (NSURL *)_url
{
    if( (self = [super init]) )
    {
        self.url = _url;
    }
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [url release];
    
    [toolBarView release];
    [webContentView release];
        
    [refreshButton release];
    [stopButton release];
        
    [loadingIndicator release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //set up the view for this controller. Consists of a background and the tab bar
	UIView *mainView = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    
    if( [UIColor respondsToSelector: NSSelectorFromString( @"scrollViewTexturedBackgroundColor" )] )
        mainView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    else
        mainView.backgroundColor = [UIColor blackColor];
	
    mainView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	mainView.autoresizesSubviews = YES;
	mainView.clipsToBounds = YES;
	self.view = mainView;
	[mainView release];
    
    //create the web view
    webContentView = [[UIWebView alloc] init];
    webContentView.delegate = self;
    webContentView.frame = CGRectMake( 0, 0, self.view.frame.size.width, self.view.frame.size.height - TOOLBAR_HEIGHT );
    webContentView.scalesPageToFit = YES;
    webContentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview: webContentView];
    
    
	//create the tool bar
    toolBarView = [[UIToolbar alloc] init];   
    toolBarView.frame = CGRectMake( 0, self.view.frame.size.height - TOOLBAR_HEIGHT, self.view.frame.size.width, TOOLBAR_HEIGHT);
    toolBarView.barStyle = UIBarStyleBlack;
    toolBarView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
    [self.view addSubview: toolBarView];    
    
    //set up the buttons

    //refresh button
    refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(refreshButtonPressed)];
    stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemStop target: webContentView action: @selector(stopLoading)];
    
    //back button
    UIImage *backImage = [UIImage imageFromResourcePath: [NSString stringWithFormat: @"%@BackButton.png", NAV_IMAGES_PATH ]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage: backImage style: UIBarButtonItemStylePlain target: webContentView action: @selector(goBack)];
    backButton.enabled = NO;
    
    UIBarButtonItem *navGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    navGap.width = 30.0f;
    
    //forward button
    UIImage *forwardImage = [UIImage imageFromResourcePath: [NSString stringWithFormat: @"%@ForwardButton.png", NAV_IMAGES_PATH ]];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithImage: forwardImage style: UIBarButtonItemStylePlain target: webContentView action: @selector(goForward)];
    forwardButton.enabled = NO;
    
    //gap dummy item
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];

    //extras button
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction target: self action: @selector(moreButtonPressed)];

    UIBarButtonItem *refreshGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    refreshGap.width = 40.0f;
    
    //bundle them up
    NSArray *toolbarItems = [NSArray arrayWithObjects: backButton, navGap, forwardButton, spaceButton, refreshButton, refreshGap, moreButton, nil];
    
    //release the references made here
    [backButton release];
    [navGap release];
    [forwardButton release];
    [spaceButton release];
    [refreshGap release];
    [moreButton release];
    
    //send to the toolbar
    [toolBarView setItems: toolbarItems animated: NO];
    
    //set up an activity indicator for loading
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    loadingIndicator.hidesWhenStopped = YES;
    [loadingIndicator stopAnimating];
}

- (void)viewDidLoad
{
    //attach the loading icon to the navbar
    if( self.navigationController != nil )
    {
        UIBarButtonItem *loadingItem = [[UIBarButtonItem alloc] initWithCustomView: loadingIndicator];
        self.navigationItem.rightBarButtonItem = loadingItem;
        [loadingItem release];
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [webContentView loadRequest: [NSURLRequest requestWithURL: url]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.toolBarView = nil;
    self.webContentView = nil;
}

#pragma mark -
#pragma mark Toolbar button callbacks
- (void)refreshButtonPressed
{
    [webContentView loadRequest: [NSURLRequest requestWithURL: self.url]];
}

- (void)moreButtonPressed
{
    UIActionSheet *morePrompt = [[UIActionSheet alloc] initWithTitle: [url absoluteString] 
                                                            delegate:self 
                                                   cancelButtonTitle: NSLocalizedString(@"Cancel", nil) 
                                              destructiveButtonTitle: nil 
                                                   otherButtonTitles: NSLocalizedString(@"Open in Safari", nil), NSLocalizedString(@"Copy", nil), nil];
    if( self.parentViewController )
        [morePrompt showInView: self.parentViewController.view];
    else
        [morePrompt showInView: self.view]; 
    
    [morePrompt release];
}

#pragma mark - 
#pragma mark UIWebView Delegate Callbacks
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self setToolBarLoading: YES];
    [self resetNavButtons];
    
    if( [self.title length] <= 0 )
        self.title = [self.url absoluteString];
    
    //swap out the button
    NSMutableArray *items = [NSMutableArray arrayWithArray: toolBarView.items];
    [items replaceObjectAtIndex: ITEM_REFRESH withObject: stopButton];
    toolBarView.items = items;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{   
    [self setToolBarLoading: NO];
    [self resetNavButtons];
    
    //maaan this is dodgey. The only way to get the page title. :(
    NSString *pageTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if( [pageTitle length] > 0 )
        self.title = pageTitle;
    else
        self.title = [self.url absoluteString];
    
    //update the current URL to match
    self.url = [webView.request URL];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self setToolBarLoading: NO];
    [self resetNavButtons];    
    
    //user canceled request. this one is OK to ignore
    if( [error code] == -999 )
    {
        return;
    }
    
    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Unable to load page.", nil)
                                                           message: [error localizedDescription] 
                                                          delegate: nil 
                                                 cancelButtonTitle: nil 
                                                 otherButtonTitles: NSLocalizedString( @"OK", nil), nil];
    [errorMessage show];
    [errorMessage release];
}

#pragma mark -
#pragma mark Toolbar handling

- (void)setToolBarLoading: (BOOL)loading
{
    if( loading )
    {
        [loadingIndicator startAnimating];
        
        //swap out the button
        NSMutableArray *items = [NSMutableArray arrayWithArray: toolBarView.items];
        [items replaceObjectAtIndex: ITEM_REFRESH withObject: refreshButton];
        toolBarView.items = items;
    }
    else
    {
        [loadingIndicator stopAnimating];
        
        //swap out the button
        NSMutableArray *items = [NSMutableArray arrayWithArray: toolBarView.items];
        [items replaceObjectAtIndex: ITEM_REFRESH withObject: refreshButton];
        toolBarView.items = items;
    }
}

- (void)resetNavButtons
{
    UIBarButtonItem *backButton = [toolBarView.items objectAtIndex: ITEM_BACK];
    UIBarButtonItem *forwardButton = [toolBarView.items objectAtIndex: ITEM_FORWARD];
                      
    if( webContentView.canGoBack )
        backButton.enabled = YES;
    else
        backButton.enabled = NO;
    
    if( webContentView.canGoForward )
        forwardButton.enabled = YES;
    else
        forwardButton.enabled = NO;
}

#pragma mark - 
#pragma mark UIActionSheet Delegates
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 ) //Open in Safari
    {
        [[UIApplication sharedApplication] openURL: url];
    }
    else if( buttonIndex == 1 ) //Copy
    {
        NSString *sourceURL = [url absoluteString];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = sourceURL;
    }
}

@end
