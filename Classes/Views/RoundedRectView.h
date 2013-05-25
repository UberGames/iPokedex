//
//  RoundedRectView.h
//
//  Created by Jeff LaMarche on 11/13/08.

#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor whiteColor]
#define kDefaultRectColor           [UIColor whiteColor]
#define kDefaultStrokeWidth         0
#define kDefaultCornerRadius        10.0

@interface RoundedRectView : UIView {
    CGFloat     cornerRadius;
	UIColor     *strokeColor;
    NSInteger	strokeWidth;
	UIColor     *rectColor;
}


@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property NSInteger strokeWidth;
@property CGFloat cornerRadius;

@end