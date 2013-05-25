//
//  TCWebBrowserViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 13/05/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCWebBrowserViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    NSURL *url;
    
    UIToolbar *toolBarView;
    UIWebView *webContentView;

    UIBarButtonItem *refreshButton;
    UIBarButtonItem *stopButton;
    
    UIActivityIndicatorView *loadingIndicator;
}

- (id)initWithURL: (NSURL *)_url;

- (void)refreshButtonPressed;
- (void)moreButtonPressed;

- (void)resetNavButtons;

@property (nonatomic, retain) UIToolbar *toolBarView;
@property (nonatomic, retain) UIWebView *webContentView;
@property (nonatomic, retain) NSURL *url;

@property (nonatomic, retain) UIBarButtonItem *refreshButton;
@property (nonatomic, retain) UIBarButtonItem *stopButton;

@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;

@end
