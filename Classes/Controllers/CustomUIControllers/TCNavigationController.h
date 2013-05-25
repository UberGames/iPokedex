//
//  UICustomNavigationController.h
//  NavTab
//
//  Created by Timothy Oliver on 17/11/10.
//  Copyright 2010 UberGames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TCNavigationController : UINavigationController <UIGestureRecognizerDelegate, UINavigationControllerDelegate> {
	UILongPressGestureRecognizer *tapHoldRecognizer;
}

@property (retain, nonatomic) UILongPressGestureRecognizer *tapHoldRecognizer;

@end

