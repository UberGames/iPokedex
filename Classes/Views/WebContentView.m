//
//  WebContentView.m
//  iPokedex
//
//  Created by Timothy Oliver on 23/03/11.
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

#import "WebContentView.h"
#import <QuartzCore/QuartzCore.h>

@interface WebContentView ()

- (void) ensureScrollsToTop: (UIView*) ensureView;

@end

@implementation WebContentView

@synthesize activityView, webView, finishedLoading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.finishedLoading = NO;
        
        //create the activity indicator
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        activityView.center = self.center;
        activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview: activityView];
    }
    return self;
}

- (void)dealloc
{
    [activityView release];
    [webView release];
    [super dealloc];
}

- (void)setHeightOffWebView
{
    //set webview height to 1
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    
    //derive the height of the web content
    CGSize fitSize = [webView sizeThatFits: CGSizeZero];
    frame.size.height = fitSize.height;
    webView.frame = frame;

    height = fitSize.height;
}

- (void)setHTML: (NSString *)html withBaseURL: (NSURL *)baseURL withDelegate: (id)delegate
{
    if( webView != nil )
        self.webView = nil;
    
    webView = [[UIWebView alloc] initWithFrame: self.bounds]; 
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    webView.opaque = NO;
    webView.delegate = delegate;
    webView.scalesPageToFit = NO;

    //kill the grey BG and shadows in the webview
    webView.backgroundColor = [UIColor whiteColor];
    for (UIView* subView in [webView subviews])
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
   
    //star filling the view with data
    NSData *data = [html dataUsingEncoding: NSUTF8StringEncoding];
    [webView loadData: data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL: baseURL];
    [self addSubview: webView];
    [webView setHidden: YES];
    
    [activityView setHidden: NO];
    [activityView startAnimating];
    
    self.finishedLoading = NO;
}

- (CGFloat)height
{
    if( webView == nil )
        return 44.0f;
    
    return height;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)loadingComplete
{
    [activityView removeFromSuperview];
    
    [webView setHidden: NO];
    [webView setNeedsDisplay];
    [webView becomeFirstResponder];
    
    [self ensureScrollsToTop: webView];
    self.finishedLoading = YES;
}

//pilfered from http://stackoverflow.com/questions/2175281/uiscrollview-uiwebview-no-scrollstotop
//this disables the webview as a potential candidate for the 'scroll to top' status bar message
//ensuring the parent view gets to keep it
- (void) ensureScrollsToTop: (UIView*) ensureView {
    ((UIScrollView *)[[webView subviews] objectAtIndex:0]).scrollsToTop = NO;
}


@end
