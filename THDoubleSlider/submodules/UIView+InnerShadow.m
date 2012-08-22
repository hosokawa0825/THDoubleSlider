//
//  UIView+InnerShadow.m
//  InnerShadow
//
//  Created by toru hosokawa on 2012/08/17.
//  Copyright (c) 2012 hosokawa0825. All rights reserved.
//

#import "UIView+InnerShadow.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

static char const * const ShadowKey = "shadow";
static char const * const TopShadowKey = "topShadow";
static char const * const LeftShadowKey = "leftShadow";
static float const ShadowOffset = 2.5;

@interface UIView (InnerShadow)
@property (nonatomic, strong) CALayer *shadow;
@property (nonatomic, strong) CALayer *topShadow;
@property (nonatomic, strong) CALayer *leftShadow;
@end

@implementation UIView (InnerShadow)
@dynamic shadow;
@dynamic topShadow;
@dynamic leftShadow;

#pragma mark instance value method
- (id)shadow {
    return objc_getAssociatedObject(self, ShadowKey);
}

- (void)setShadow:(CALayer *)shadow {
    objc_setAssociatedObject(self, ShadowKey, shadow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)topShadow {
    return objc_getAssociatedObject(self, TopShadowKey);
}

- (void)setTopShadow:(CALayer *)shadow {
    objc_setAssociatedObject(self, TopShadowKey, shadow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)leftShadow {
    return objc_getAssociatedObject(self, LeftShadowKey);
}

- (void)setLeftShadow:(CALayer *)shadow {
    objc_setAssociatedObject(self, LeftShadowKey, shadow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark shadowing method
- (void)addInnerShadowToTop:(BOOL)topShadowing toLeft:(BOOL)leftShadowing{
    self.shadow = [CALayer layer];
    self.shadow.frame = self.bounds;
    self.shadow.masksToBounds = YES;
    [self.layer addSublayer:self.shadow];
    if (topShadowing){
        self.topShadow = [self createLayerForShadow];
        self.topShadow.frame = CGRectMake(-ShadowOffset, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self.shadow addSublayer:self.topShadow];
    }
    if (leftShadowing){
        self.leftShadow = [self createLayerForShadow];
        self.leftShadow.frame = CGRectMake(-self.frame.size.width, -ShadowOffset, self.frame.size.width, self.frame.size.height);
        [self.shadow addSublayer:self.leftShadow];
    }
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]){
        NSValue *val = [change objectForKey:NSKeyValueChangeNewKey];
        CGRect frame;
        [val getValue:&frame];
        self.shadow.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.topShadow.frame = CGRectMake(-ShadowOffset, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.leftShadow.frame = CGRectMake(-self.frame.size.width, -ShadowOffset, self.frame.size.width, self.frame.size.height);
    }
}

- (CALayer *)createLayerForShadow{
    CALayer *layerForShadow = [CALayer layer];
    layerForShadow.shadowOffset = CGSizeMake(ShadowOffset, ShadowOffset);
    layerForShadow.shadowColor = [[UIColor blackColor] CGColor];
    layerForShadow.shadowOpacity = 0.5;
    layerForShadow.backgroundColor = [UIColor blackColor].CGColor;
    return layerForShadow;
}
@end
