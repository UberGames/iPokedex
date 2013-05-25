//
//  RoundedRectView.m
//
//  Created by Jeff LaMarche on 11/13/08.
//	Modified by Tim Oliver (January 2011)

#import "RoundedRectView.h"

@implementation RoundedRectView

@synthesize strokeColor;
@synthesize rectColor;
@synthesize strokeWidth;
@synthesize cornerRadius;

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder]))
    {
        self.strokeColor = kDefaultStrokeColor;
        self.strokeWidth = kDefaultStrokeWidth;
        self.rectColor = kDefaultRectColor;
        self.cornerRadius = kDefaultCornerRadius;
		self.contentMode = UIViewContentModeRedraw;
		
		//set the super BGColor to clear and lock out the public property
		[super setBackgroundColor: [UIColor clearColor]];
		[super setOpaque: NO];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Initialization code
        self.strokeColor = kDefaultStrokeColor;
        self.rectColor = kDefaultRectColor;
        self.strokeWidth = kDefaultStrokeWidth;
        self.cornerRadius = kDefaultCornerRadius;
		self.contentMode = UIViewContentModeRedraw;
		
		//set the super properties, and then disable their accessors here
		[super setBackgroundColor: [UIColor clearColor]];
		[super setOpaque: NO];
    }
    return self;
}

//
- (void)setBackgroundColor:(UIColor *)newBGColor
{
	//backgroundColor must remain clear to allow for the corners, so ignore any attempts to override it here.
}

- (void)setOpaque:(BOOL)newIsOpaque
{
    // Ignore attempt to set opaque to YES.
}

+(CGMutablePathRef) CGMutablePathCreateForRoundedRectWithRect: (CGRect)rect strokeWidth: (NSInteger)_strokeWidth radius: (CGFloat) _radius
{
	CGRect rrect = CGRectInset(rect, _strokeWidth, _strokeWidth);
    
    CGFloat radius = _radius;
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0)
        radius = width/2.0;
    if (radius > height/2.0)
        radius = height/2.0;    
    
	//The CG stroke operation draws the line directly down the middle of the specified path.
	//However, if the stroke width is odd, this means it will try to draw the line
	//directly down the middle of the pixels, which results in anti-aliasing smudging it across 2 pixels.
	//This offset will counter that effect, ensuring a solid line is drawn.
	CGFloat offset = ((_strokeWidth > 0 && (_strokeWidth % 2) != 0) ? -0.5f : 0 );
	
    CGFloat minx = CGRectGetMinX(rrect)+offset;
    CGFloat midx = CGRectGetMidX(rrect)+offset;
    CGFloat maxx = CGRectGetMaxX(rrect)+offset;
    CGFloat miny = CGRectGetMinY(rrect)+offset;
    CGFloat midy = CGRectGetMidY(rrect)+offset;
    CGFloat maxy = CGRectGetMaxY(rrect)+offset;
	
	CGMutablePathRef path = CGPathCreateMutable();
	
    CGPathMoveToPoint(path, NULL, minx, midy);
    CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, radius);
    CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, radius);
    CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, radius);
    CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, radius);
	CGPathCloseSubpath(path);
	
	return path;
}

-(CGMutablePathRef) CGMutablePathCreateForRoundedRect
{
	return [RoundedRectView CGMutablePathCreateForRoundedRectWithRect: self.bounds strokeWidth: strokeWidth radius: cornerRadius ];
}

- (void)drawRect:(CGRect)rect {
    //Quartz Context
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	//Set draw parameters
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.rectColor.CGColor);
	
	//get the path 
	CGMutablePathRef path = [self CGMutablePathCreateForRoundedRect];
	
	//draw the path+stroke to the context
	CGContextSaveGState(context);
	CGContextAddPath(context, path);
	CGContextDrawPath(context, kCGPathFillStroke);
	CGContextRestoreGState( context );
	
	CGPathRelease(path);
}

- (void)dealloc {
    [strokeColor release];
    [rectColor release];
    [super dealloc];
}

@end