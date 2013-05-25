//
//  TCTabBarItem.h
//  iPokedex
//
//  Created by Timothy Oliver on 4/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCTabBarItem : UITabBarItem {
	
	IBOutlet UIViewController *viewController;
	UIImage *highlightedImage;
}

- (id) initWithViewController: (UIViewController *)controller title: (NSString *) title image: (UIImage *)image;

@property (nonatomic, retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) UIImage *highlightedImage;

@end