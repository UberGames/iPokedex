//
//  TCSearchableListViewController.h
//  iPokedex
//
//  Created by Timothy Oliver on 14/02/11.
//  Copyright 2011 UberGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRefinableListViewController.h"

@interface TCSearchableListViewController : TCRefinableListViewController <UISearchBarDelegate,UISearchDisplayDelegate> {
	
	//search controller for table
	UISearchDisplayController *searchController;
	NSMutableArray *tableSearchedEntries;
	UISearchBar *searchBar;	
	
	//Our own reference to any potential parent navigation controllers.
	//This is because if the navigation controller pops this controller,
	//by the time the event reaches us, the 'viewController.navigationController'
	//property has become nil.
	UINavigationController *parentNavigationController;
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    BOOL            searchWasWithLanguage; //search was performed in another language
}

-(void) searchListWithString: (NSString *)searchString;

@property (nonatomic, retain) NSMutableArray *tableSearchedEntries;
@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UINavigationController *parentNavigationController;
@property (nonatomic, retain) NSString *savedSearchTerm;
@property (nonatomic, assign) NSInteger savedScopeButtonIndex;
@property (nonatomic, assign) BOOL searchWasActive;
@property (nonatomic, assign) BOOL searchWasWithLanguage;

@end


