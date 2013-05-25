//
//  TCTabBarController+TransitionHandling.h
//	Created by Tim Oliver on 22/5/11.
//
//	A category component for the TCTabBarController class.
//  This category handles all of the methods and functionality
//  in transitioning the main tab bar controller between its
//  'more tab' dummy controller and back, ensuring the location
//  and positioning of the UITabBar element is handled properly
//

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCTabBarController (TransitionHandling)

- (void)moveTabBarToController: (UIViewController *) viewController;

@end
