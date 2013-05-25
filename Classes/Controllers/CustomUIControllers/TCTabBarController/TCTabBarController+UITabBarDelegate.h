//
//  TCTabBarController+UITabBarDelegate.h
//
//  Created by Timothy Oliver on 4/12/10.
//
//	The UITabBarDelegate events for the
//	TCTabBarController class. This includes
//	custom code for when the active tab gets changed
//	and delegate events when the 'Edit' bar appears
//	and disappears.

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCTabBarController ( UITabBarDelegate )

- (void)beginCustomizingTabItems;

@end
