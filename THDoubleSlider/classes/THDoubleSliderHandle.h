//
//  THDoubleSliderHandle.h
//
//  Created by hosokawa0825 on 21/08/2012.
//  Copyright 2012 hosokawa0825 All rights reserved.
//  https://github.com/hosokawa0825/THDoubleSlider
//

#import <UIKit/UIKit.h>

@protocol THDoubleSliderHandleDelegate
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
@end

@interface THDoubleSliderHandle : UIControl
@property (nonatomic, weak) UIView *handleView;
@property (nonatomic, weak) UIView *highlightedHandleView;
@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, weak) NSObject <THDoubleSliderHandleDelegate> *delegate;

- (id)initWithHandleView:(UIView *)handleView hilightedHandleView:(UIView *)highlightedHandleView;
- (void)setHandleView:(UIView *)handleView hilightedHandleView:(UIView *)highlightedHandleView;
@end