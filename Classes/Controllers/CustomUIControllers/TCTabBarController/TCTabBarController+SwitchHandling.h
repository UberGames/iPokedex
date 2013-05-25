//
//  TCTabBarController+SwitchHandling.h
//	Created by Tim Oliver on 22/5/11.
//
//	A category component for the TCTabBarController class.
//  This category handles all of the methods and functionality
//  in switching between visible view controllers when the 
//  user taps a tab on the UITabBar menu.
//

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCTabBarController (SwitchHandling)

- (void)transitionToNewSelectedItem: (UITabBarItem *) newItem;
- (void)switchToSelectedIndex: (NSInteger) index;
- (void)switchToNewSelectedItem: (UITabBarItem *) newItem;

@end
