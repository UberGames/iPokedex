//
//  TCWebContentViewController.m
//  iPokedex
//
//  Created by Timothy Oliver on 22/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import "TCWebContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TCWebLinker.h"

@interface TCWebContentViewController ()

- (void)initWebView;

@end

@implementation TCWebContentViewController

@synthesize contentView, contentLoaderView, filePath, baseURL, urlToLoad;

- (id)initWithURL: (NSString *)_filePath withBaseURL: (NSURL *)_baseURL
{
    if( (self = [super init] ) )
   {
       self.filePath    = _filePath;
       self.baseURL     = _baseURL;
   }
    
    return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [filePath release];
    [baseURL release];
    
    [contentView release];
    [contentLoaderView release];
    [urlToLoad release];
    
    [super dealloc];
}
#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if( contentView == nil )
        [self initWebView];
}

- (void)initWebView
{
    //create/add the webview
    contentView = [[UIWebView alloc] initWithFrame: self.view.bounds];
    contentView.contentMode = UIViewContentModeRedraw;
    contentView.autoresizingMask = (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth);
    contentView.delegate = self;
    contentView.scalesPageToFit = NO;
    contentView.opaque = NO;
    [self.view addSubview: contentView];
    
    //add an activity indicator to show the page is loading
    contentLoaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    contentLoaderView.center = CGPointMake( self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    contentLoaderView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin);
    [self.view addSubview: contentLoaderView];
    
    [contentLoaderView setHidden: NO];
    [contentLoaderView startAnimating];    
    
    NSData *html = [NSData dataWithContentsOfFile: filePath];
    [contentView loadData: html MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL: baseURL];
    [contentView setHidden: YES];
    
    //kill the grey BG and shadows in the webview
    contentView.backgroundColor = [UIColor whiteColor];
    for (UIView* subView in [contentView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.contentView = nil;
    self.contentLoaderView = nil;
}

#pragma mark UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5f;
    animation.delegate = self;
    
    [contentView.layer addAnimation: animation forKey: nil];
    [contentView setHidden: NO];
    
    [self.view bringSubviewToFront: contentView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if( navigationType == UIWebViewNavigationTypeOther )
        return YES;
    
    NSURL *url = request.URL;
	
	//loading an external link in the HTML. Open it in Safari
    if( [url.scheme isEqualToString: @"http"] || [url.scheme isEqualToString: @"https"] )
    {
        [[TCWebLinker sharedLinker] openURL: url fromController: self];
        
        return NO;
    }
    
    return NO;
}

#pragma mark Animation Delegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    [contentLoaderView removeFromSuperview];
}

@end
