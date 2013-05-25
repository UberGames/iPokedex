//
//  TCTabBarController+UITableViewDelegate.h
//
//  Created by Timothy Oliver on 4/12/10.
//
//	An extended view controller class that allows
//	sets up a view to display multiple subviews in
//	a UITabBar configuration similar to UITabBarController
//
//	The class automatically saves the TabBarItem order upon program exit
//	and has special code in place to handle view transitions in the event
//	it is pushed onto a UINavigationController

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCTabBarController ( UITableViewDelegate ) <UITableViewDelegate, UITableViewDataSource>

@end
