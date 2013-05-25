//
//  TCListViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 12/01/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 When loading an icon asyncronously, this object
 stores the necessary info to pass between the different selectors
 */
@interface TCAsyncIconEntry : NSObject {
    UITableView *tableView;
    NSObject *iconIndexData; //Can either be an array of indexPaths or a single index
    NSObject *tableEntry;
}

- (id)initWithTableView: (UITableView *)_tableView indexData: (NSObject *)_indexData tableEntry: (NSObject *)entry;
+ (TCAsyncIconEntry *)asyncIconEntryWithTableView: (UITableView *)_tableView indexData: (NSObject *)_indexData tableEntry: (NSObject *)entry;

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) NSObject *iconIndexData;
@property (nonatomic, assign) NSObject *tableEntry;

@end

@interface TCListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {

	//controller is currently loading the content
	BOOL isLoading;
	
    //each cell will have a unique image, so load it in a new thread
    BOOL deferIconLoading;
    
	//icons for each table cell have indeed been loaded
	BOOL imagesLoaded;
	
	//Main table view, and array of objects it will be populated with
	NSString *tableCellIdentifier;
	UITableView *tableView;
	NSMutableArray *tableEntries;
	
	//when the content is loaded/timed out, these elements are displayed
	UIActivityIndicatorView *loadingActivityView;
	UILabel *noResultsLabel;
	NSString *noResultsMessage;
	
	//custom footer view to display at the base of the table
	UIView *footerView;
	UILabel *footerViewCountLabel;
	NSString *footerCountMessage; 
	NSString *footerCountMessageSingular; 
	
	//Data to manage a section index bar in the table view
	NSArray *sectionIndexTitles; //Strings to be displayed in the bar
	NSArray *sectionIndexIndicies; //Specific row indices that each title in the bar conforms to
	
	//When table items are filtered into discrete sections
	NSArray *sectionHeaderTitles; //strings of the name of each section
	NSArray *sectionHeaderEntries; //containing an array of database entries conforming to that particlar section
    
    BOOL noLoadOnInit; //an override in case a subclass wants to initiate the loading method itself
    
    //an edit button for the main table
    UIBarButtonItem *editButton;
    
    //message at the top of the list
    NSString *tableMessage;
    UILabel *tableMessageLabel;
    
    //data required for lazy loading of images
    BOOL lazyLoadImages;
    NSInteger numLazyLoadedImages;
    NSTimer *lazyLoadTimer;
    
    //thread used to load icons concurrently
    NSThread *loadIconThread; 
}

//- (void)resetTableView;

- (void)initTableFooterView;
- (void)updateTableFooterView;

- (void)initTableMessageView;
- (void)updateTableMessageView;

- (NSArray *) loadTableContent;
- (void)loadTableContentOnNewThread;

- (void)loadTableEntriesOnNewThread;
- (void)insertEntriesIntoTable;

- (void)unloadImages;

- (void) reloadTableContent;

- (UIImage *) loadCellImageWithDataSourceEntry: (id)dataSourceEntry;
- (BOOL) cellImageisLoadedWithDataSourceEntry: (id)dataSourceEntry;

- (void) loadCellImagesOnNewThread;
- (void) reloadTableCellContentViewWithIconEntryData: (TCAsyncIconEntry *)iconEntryData;

- (UITableView *)lazyLoadTableViewInFocus;
- (void) lazyLoadVisibleCellImages;
- (void) lazyLoadVisibleCellImagesOnNewThreadWithIconEntryData: (TCAsyncIconEntry *)iconEntryData;

- (BOOL) sectionIndexIsVisible;
- (void) buildSectionIndex;

- (BOOL) sectionHeadersAreVisible;
- (void) buildSectionHeaders;

- (void) editButtonTapped:(id)sender;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL deferIconLoading;
@property (nonatomic, assign) BOOL imagesLoaded;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *tableEntries;
@property (nonatomic, copy) NSString *tableCellIdentifier;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivityView;
@property (nonatomic, retain) UILabel *noResultsLabel;
@property (nonatomic, retain) NSString *noResultsMessage;
@property (nonatomic, retain) UIView *footerView;
@property (nonatomic, retain) NSString *footerCountMessage;
@property (nonatomic, retain) NSString *footerCountMessageSingular;
@property (nonatomic, retain) UILabel *footerViewCountLabel;
@property (nonatomic, retain) NSArray *sectionIndexTitles;
@property (nonatomic, retain) NSArray *sectionIndexIndicies;
@property (nonatomic, retain) NSArray *sectionHeaderEntries;
@property (nonatomic, retain) NSArray *sectionHeaderTitles;
@property (nonatomic, assign) BOOL noLoadOnInit;
@property (nonatomic, readonly) UIBarButtonItem *editButton;;
@property (nonatomic, retain) NSString *tableMessage;
@property (nonatomic, retain) UILabel *tableMessageLabel;

@end
