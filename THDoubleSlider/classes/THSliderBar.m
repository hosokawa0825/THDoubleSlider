//
//  THSliderBar.h
//
//  Created by hosokawa0825 on 21/08/2012.
//  Copyright 2012 hosokawa0825 All rights reserved.
//  https://github.com/hosokawa0825/THDoubleSlider
//

#import <QuartzCore/QuartzCore.h>
#import "THSliderBar.h"
#import "THDoubleSliderHandle.h"
#import "UIView+InnerShadow.h"
#import "UIColor+MoreColors.h"

@interface THSliderBar ()
@end

@implementation THSliderBar
@synthesize minHandle = minHandle_;
@synthesize maxHandle = maxHandle_;
@synthesize centerColor = centerColor_;
@synthesize sideColor = sideColor_;

#pragma mark Lifecycle method
- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius centerColor:(UIColor *)centerColor  sideColor:(UIColor *)sideColor minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle{
    self = [super initWithFrame:frame];
    if (self){
        [self commonInit];
        [self setFrame:frame cornerRadius:cornerRadius centerColor:centerColor sideColor:sideColor minHandle:minHandle maxHandle:maxHandle];
    }
    return self;
}

- (void)commonInit {
    [self addInnerShadowToTop:YES toLeft:NO];
    self.layer.masksToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle{
    return [self initWithFrame:frame cornerRadius:5.0f centerColor:[UIColor mayaBlue] sideColor:[UIColor whiteColor] minHandle:minHandle maxHandle:maxHandle];
}

- (id)init{
    return [self initWithFrame:CGRectMake(0, 0, 0, 0) cornerRadius:5.0f centerColor:[UIColor mayaBlue] sideColor:[UIColor whiteColor] minHandle:nil maxHandle:nil];
}

- (void)setFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius centerColor:(UIColor *)centerColor  sideColor:(UIColor *)sideColor minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle{
    self.frame = frame;
    self.layer.cornerRadius = cornerRadius;
    self.centerColor = centerColor;
    self.sideColor = sideColor;
    self.minHandle = minHandle;
    self.maxHandle = maxHandle;
}

- (void)setFrame:(CGRect)frame minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle{
    [self setFrame:frame cornerRadius:5.0f centerColor:[UIColor mayaBlue] sideColor:[UIColor whiteColor] minHandle:minHandle maxHandle:maxHandle];
}

#pragma mark Custom Drawing
- (void)drawRect:(CGRect)rect{
    if (!self.minHandle && !self.maxHandle) return;

    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);

    CGPoint minHandleCenter = [self convertPoint:self.minHandle.center fromView:self.superview];
    CGPoint maxHandleCenter = [self convertPoint:self.maxHandle.center fromView:self.superview];

    CGRect rect1 = CGRectMake(0, 0, minHandleCenter.x, self.frame.size.height);
    CGRect rect2 = CGRectMake(minHandleCenter.x, 0, maxHandleCenter.x - minHandleCenter.x, self.frame.size.height);
    CGRect rect3 = CGRectMake(maxHandleCenter.x, 0, self.frame.size.width - maxHandleCenter.x, self.frame.size.height);

    CGContextSetFillColorWithColor(context, self.sideColor.CGColor);
    CGContextFillRect(context, rect1);
    CGContextSetFillColorWithColor(context, self.centerColor.CGColor);
    CGContextFillRect(context, rect2);
    CGContextSetFillColorWithColor(context, self.sideColor.CGColor);
    CGContextFillRect(context, rect3);

    [super drawRect:rect];
}
@end