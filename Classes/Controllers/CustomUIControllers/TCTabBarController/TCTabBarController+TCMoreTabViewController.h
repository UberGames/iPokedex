//
//  TCMoreTabViewController.h
//
//  Created by Timothy Oliver on 4/12/10.
//
//	When a tab's view controller is pushed from
//	the 'More' menu, it is placed inside this abstract
//	view controller so the dimensions can be properly
//	maintained, in addition so the parent tabController
//	can track it.
//
//	NB: This class is only used if the parent TCTabController itself
//	is a child of a UINavigationController, so it is ALWAYS assumed
//	that self.navigationController != nil

#import <Foundation/Foundation.h>
#import "TCTabBarController.h"

@interface TCMoreTabViewController : UIViewController
{
	TCTabBarController *parentTabController;
	UIViewController *viewController;
}

- (id)initWithParentControllor: (TCTabBarController *)parent viewController: (UIViewController *)_controller;

@property (nonatomic, retain) TCTabBarController *parentTabController;
@property (nonatomic, retain) UIViewController *viewController;

@end