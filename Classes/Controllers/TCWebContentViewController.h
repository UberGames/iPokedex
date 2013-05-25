//
//  TCWebContentViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 22/03/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TCWebContentViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    NSString *filePath;
    NSURL *baseURL;
    
    UIWebView *contentView;
    UIActivityIndicatorView *contentLoaderView;
    
    NSURL *urlToLoad;
}

- (id)initWithURL: (NSString *)_filePath withBaseURL: (NSURL *)_baseURL;

@property (nonatomic, retain) UIWebView *contentView;
@property (nonatomic, retain) UIActivityIndicatorView *contentLoaderView;

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSURL *baseURL;

@property (nonatomic, retain) NSURL *urlToLoad;

@end
