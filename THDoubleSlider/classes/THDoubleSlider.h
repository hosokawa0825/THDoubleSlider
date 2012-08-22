//
//  THDoubleSlider.h
//
//  Created by hosokawa0825 on 21/08/2012.
//  Copyright 2012 hosokawa0825 All rights reserved.
//  https://github.com/hosokawa0825/THDoubleSlider
//

#import <Foundation/Foundation.h>
#import "THDoubleSliderHandle.h"

#define DRAGGING_NOTIFICATION @"DRAGGING_NOTIFICATION"
#define DID_DRAG_NOTIFICATION @"DID_DRAG_NOTIFICATION"
#define TOUCH_OBJECT_KEY @"DEFAULT_OBJECT_KEY"

@class THDoubleSlider;

// Implement if customized value change curve is needed.
// Otherwise, value change linearly.
@protocol THDoubleSliderDelegate
@optional
- (NSNumber *)slider:(THDoubleSlider *)slider roundSelectedValue:(NSNumber *)selectedValue;

// must both valueWithXPosRatio and xPosRatioWithValue are implemented or both not
// xPosRatio is between 0 and 1.
- (NSNumber *)slider:(THDoubleSlider *)slider valueWithXPosRatio:(CGFloat)xPosRatio;
// inverse function of valueWithXPosRatio
- (float)slider:(THDoubleSlider *)slider xPosRatioWithValue:(NSNumber *)value;
@end

@interface THDoubleSlider : UIControl
@property (nonatomic, strong) NSNumber *minSelectedValue;
@property (nonatomic, strong) NSNumber *maxSelectedValue;
@property (nonatomic, assign, readonly) float minValue;
@property (nonatomic, assign, readonly) float maxValue;
@property(nonatomic, weak) NSObject<THDoubleSliderDelegate> *delegate;
@property(nonatomic, strong) NSNumberFormatter *numberFormatter;

// initializer
- (void)setMinValue:(float)aMinValue maxValue:(float)aMaxValue minHandleView:(UIView *)minHandleView highlightedMinHandleView:(UIView *)highlightedMinHandleView maxHandleView:(UIView *)maxHandleView highlightedMaxHandleView:(UIView *)highlightedMaxHandleView;

// convenience initializer
// use if min max handles are same images.
- (void)setMinValue:(float)aMinValue maxValue:(float)aMaxValue handleImageName:(NSString *)handleImageName highlightedHandleImageName:(NSString *)highlightedHandleImageName;

- (BOOL)isMinValueChanged;
- (BOOL)isMaxValueChanged;

- (void)setMinSelectedValue:(NSNumber *)aMinSelectedValue animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent;
- (void)setMaxSelectedValue:(NSNumber *)aMaxSelectedValue animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent;

// set string value from text field
- (void)setMinSelectedValueWithStringVale:(NSString *)value animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent;
- (void)setMaxSelectedValueWithStringVale:(NSString *)value animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent;

// selected values formatted by numberFormatter property
- (NSString *)minSelectedValueString;
- (NSString *)maxSelectedValueString;
@end