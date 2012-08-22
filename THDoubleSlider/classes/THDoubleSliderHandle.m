//
//  THDoubleSliderHandle.m
//
//  Created by hosokawa0825 on 21/08/2012.
//  Copyright 2012 hosokawa0825 All rights reserved.
//  https://github.com/hosokawa0825/THDoubleSlider
//

#import "THDoubleSliderHandle.h"

// For usability, minimum handle size is 44x44.
const CGFloat MinHandleSideLength = 44;

@interface THDoubleSliderHandle ()
@end

@implementation THDoubleSliderHandle
@synthesize handleView = imageView_;
@synthesize highlightedHandleView = highlightedHandleView_;
@synthesize dragging = dragging_;
@synthesize delegate = delegate_;

#pragma mark Lifecycle method
- (id)initWithHandleView:(UIView *)handleView hilightedHandleView:(UIView *)highlightedHandleView{
    CGRect frame = [self frameWithHandleView:handleView];
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWIthHandleView:handleView highlightedHandleView:highlightedHandleView];
    }
    return self;
}

- (void)commonInitWIthHandleView:(UIView *)handleView highlightedHandleView:(UIView *)highlightedHandleView {
    self.handleView = handleView;
    self.handleView.center = [self convertPoint:self.center fromView:self.superview];
    self.highlightedHandleView = highlightedHandleView;
    self.highlightedHandleView.center = [self convertPoint:self.center fromView:self.superview];
    [self addSubview:self.handleView];
    [self addSubview:self.highlightedHandleView];
    self.highlightedHandleView.hidden = YES;
    self.dragging = NO;
}

#pragma mark setter method
- (void)setHandleView:(UIView *)handleView hilightedHandleView:(UIView *)highlightedHandleView {
    self.frame = [self frameWithHandleView:handleView];
    [self commonInitWIthHandleView:handleView highlightedHandleView:highlightedHandleView];
}

- (CGRect)frameWithHandleView:(UIView *)handleView {
    CGRect result = handleView.frame;
    result.size.height = MAX(result.size.height, MinHandleSideLength);
    result.size.width = MAX(result.size.width, MinHandleSideLength);
    return result;
}

- (void)setDragging:(BOOL)dragging {
    dragging_ = dragging;
    if (self.dragging){
        self.highlightedHandleView.hidden = NO;
        self.handleView.hidden = YES;
    } else {
        self.highlightedHandleView.hidden = YES;
        self.handleView.hidden = NO;
    }
}

#pragma mark Touch tracking
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginTrackingWithTouch:withEvent:)]){
        return [self.delegate beginTrackingWithTouch:touch withEvent:event];
    } else {
        return NO;
    }
}
@end
