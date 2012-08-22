//
//  THDoubleSlider.m
//
//  Created by hosokawa0825 on 21/08/2012.
//  Copyright 2012 hosokawa0825 All rights reserved.
//  https://github.com/hosokawa0825/THDoubleSlider
//

#import <CoreLocation/CoreLocation.h>
#import "THDoubleSlider.h"
#import "THSliderBar.h"

#define AnimationDuration    0.2
#define MOVE_SPEED_1_DISTANCE 50
#define DELTA_THRESHHOLD 0.0001

@interface THDoubleSlider () <THDoubleSliderHandleDelegate>
@property(nonatomic, strong) THDoubleSliderHandle *minHandle;
@property(nonatomic, strong) THDoubleSliderHandle *maxHandle;
@property(nonatomic, strong) THSliderBar *sliderBar;
@property(nonatomic, assign) CGPoint previousTouchPoint;
@property(nonatomic, assign) float minValue;
@property(nonatomic, assign) float maxValue;
@property(nonatomic, strong) NSNumber *previousMinSelectedValue;
@property(nonatomic, strong) NSNumber *previousMaxSelectedValue;
@end

@implementation THDoubleSlider
@synthesize minSelectedValue = minSelectedValue_;
@synthesize maxSelectedValue = maxSelectedValue_;
@synthesize minValue = minValue_;
@synthesize maxValue = maxValue_;
@synthesize previousMinSelectedValue = previousMinSelectedValue_;
@synthesize previousMaxSelectedValue = previousMaxSelectedValue_;
@synthesize minHandle = minHandle_;
@synthesize maxHandle = maxHandle_;
@synthesize previousTouchPoint = previousTouchPoint_;
@synthesize sliderBar = sliderBar_;
@synthesize delegate = delegate_;

#pragma mark dealloc method
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark accessor method
- (float)sliderBarStartPosX{
    return self.sliderBar.frame.origin.x;
}

- (float)sliderBarEndPosX{
    return self.sliderBar.frame.origin.x + self.sliderBar.frame.size.width;
}

- (float)sliderBarWidth{
    return self.sliderBar.frame.size.width;
}

- (float)handleCenterPosY{
    return self.frame.size.height / 2;
}

#pragma mark minSelectedValue accessor method
// designated setter
- (void)setMinSelectedValue:(NSNumber *)aMinSelectedValue animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent {
    minSelectedValue_ = aMinSelectedValue;
    float duration = animated ? AnimationDuration : 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.minHandle.center = [self centerOfHandleWithValue:aMinSelectedValue xPosIfNil:self.sliderBarStartPosX];
        [self.sliderBar setNeedsDisplay];
        if (fireValueChangeEvent){
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }];
}

- (void)setMinSelectedValue:(NSNumber *)aMinSelectedValue {
    [self setMinSelectedValue:aMinSelectedValue animated:YES fireValueChangeEvent:NO];
}

- (void)setMinSelectedValueWithStringVale:(NSString *)value animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent {
    [self setMinSelectedValue:[self emptyToNilWithString:value] animated:animated fireValueChangeEvent:fireValueChangeEvent];
}

#pragma mark maxSelectedValue accessor method
// designated setter
- (void)setMaxSelectedValue:(NSNumber *)aMaxSelectedValue animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent {
    maxSelectedValue_ = aMaxSelectedValue;
    float duration = animated ? AnimationDuration : 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.maxHandle.center = [self centerOfHandleWithValue:aMaxSelectedValue xPosIfNil:self.sliderBarEndPosX];
        [self.sliderBar setNeedsDisplay];
        if (fireValueChangeEvent){
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }];
}

- (void)setMaxSelectedValue:(NSNumber *)aMaxSelectedValue {
    [self setMaxSelectedValue:aMaxSelectedValue animated:YES fireValueChangeEvent:NO];
}

- (void)setMaxSelectedValueWithStringVale:(NSString *)value animated:(BOOL)animated fireValueChangeEvent:(BOOL)fireValueChangeEvent {
    [self setMaxSelectedValue:[self emptyToNilWithString:value] animated:animated fireValueChangeEvent:fireValueChangeEvent];
}

- (NSString *)minSelectedValueString {
    return [self.numberFormatter stringForObjectValue:self.minSelectedValue];
}

- (NSString *)maxSelectedValueString {
    return [self.numberFormatter stringForObjectValue:self.maxSelectedValue];
}

#pragma mark Lifecycle method
- (id)init {
    self = [super init];
    if (self){
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.minHandle = [[THDoubleSliderHandle alloc] init];
    self.minHandle.delegate = self;
    [self addSubview:self.minHandle];

    self.maxHandle = [[THDoubleSliderHandle alloc] init];
    self.maxHandle.delegate = self;
    [self addSubview:self.maxHandle];

    self.sliderBar = [[THSliderBar alloc] init];
    [self insertSubview:self.sliderBar atIndex:0];

    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(draggingNotificationUpdated:) name:DRAGGING_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDragNotificationUpdated:) name:DID_DRAG_NOTIFICATION object:nil];
}

- (void)draggingNotificationUpdated:(NSNotification *)notification {
    UITouch *touch = [notification.userInfo objectForKey:TOUCH_OBJECT_KEY];
    [self continueTrackingWithTouch:touch withEvent:nil];
}

- (void)didDragNotificationUpdated:(NSNotification *)notification {
    UITouch *touch = [notification.userInfo objectForKey:TOUCH_OBJECT_KEY];
    [self endTrackingWithTouch:touch withEvent:nil];
}

#pragma mark move slider method
- (CGPoint)centerOfHandleWithValue:(NSNumber *)value xPosIfNil:(float)xPosIfNil {
    if (value == nil){
        return CGPointMake(xPosIfNil, self.handleCenterPosY);
    } else {
        float xPosRatio = 0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(slider:xPosRatioWithValue:)]){
            xPosRatio = [self.delegate slider:self xPosRatioWithValue:value];
        } else {
            xPosRatio = [self xPosRatioWithValue:value];
        }
        xPosRatio = MAX(xPosRatio, 0);
        xPosRatio = MIN(xPosRatio, 1);
        return CGPointMake(xPosRatio * self.sliderBarWidth + self.sliderBarStartPosX, self.handleCenterPosY);
    }
}

- (float)xPosRatioWithValue:(NSNumber *)value {
    float valueSpan = self.maxValue - self.minValue;
    return (value.floatValue - self.minValue) / valueSpan;
}

- (NSNumber *)emptyToNilWithString:(NSString *)string{
    if (string == nil || [string isEqualToString:@""]){
        return nil;
    } else {
        return [NSNumber numberWithFloat:[string floatValue]];
    }
}

#pragma mark THDoubleSliderHandleDelegate method
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    self.previousTouchPoint = touchPoint;
    [self setLatchWithTouchPoint:touchPoint];
    return YES;
}

#pragma mark Touch tracking
-(void)setLatchWithTouchPoint:(CGPoint)touchPoint{
    BOOL minHandleTouched = CGRectContainsPoint(self.minHandle.frame, touchPoint);
    BOOL maxHandleTouched = CGRectContainsPoint(self.maxHandle.frame, touchPoint);

    // When handles are overlapped, drag nearer one.
    if (minHandleTouched && maxHandleTouched){
        CLLocationDistance distanceMin = [self distanceBetweenPoint1:touchPoint point2:self.minHandle.center];
        CLLocationDistance distanceMax = [self distanceBetweenPoint1:touchPoint point2:self.maxHandle.center];
        if (distanceMin < distanceMax){
            self.minHandle.dragging = YES;
            self.maxHandle.dragging = NO;
        } else {
            self.minHandle.dragging = NO;
            self.maxHandle.dragging = YES;
        }
    } else if(minHandleTouched) {
        self.minHandle.dragging = YES;
        self.maxHandle.dragging = NO;
    } else if (maxHandleTouched){
        self.minHandle.dragging = NO;
        self.maxHandle.dragging = YES;
    }
}

- (float)distanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2{
    float dx = point2.x - point1.x;
    float dy = point2.y - point1.y;
    return (float)sqrt(dx*dx + dy*dy);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (!self.maxHandle.dragging && !self.minHandle.dragging){
        return NO;
    }
	CGPoint touchPoint = [touch locationInView:self];

	if (self.minHandle.dragging) {
        float x = [self calcHandleXPos:touchPoint centerOfHandle:self.minHandle.center];
        self.minHandle.center = CGPointMake(x, self.minHandle.center.y);
        self.maxHandle.center = CGPointMake(MAX(self.maxHandle.center.x, self.minHandle.center.x), self.handleCenterPosY);
        [self updateValues];
	} else if (self.maxHandle.dragging) {
        float x = [self calcHandleXPos:touchPoint centerOfHandle:self.maxHandle.center];
        self.maxHandle.center = CGPointMake(x, self.maxHandle.center.y);
        self.minHandle.center = CGPointMake(MIN(self.maxHandle.center.x, self.minHandle.center.x), self.handleCenterPosY);
        [self updateValues];
	}

    self.previousTouchPoint = touchPoint;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	[self.sliderBar setNeedsDisplay];
	return YES;
}

- (void)updateValues{
    self.previousMinSelectedValue = self.minSelectedValue;
    self.previousMaxSelectedValue = self.maxSelectedValue;
    [self updateMinSelectedValue];
    [self updateMaxSelectedValue];
}

- (void)updateMinSelectedValue {
    if (self.minSelectedValue != nil || self.minHandle.dragging){
        float xPosRatioMin = (self.minHandle.center.x - self.sliderBarStartPosX) / self.sliderBarWidth;
        if (self.delegate && [self.delegate respondsToSelector:@selector(slider:valueWithXPosRatio:)]){
            NSNumber *minSelectedValue = [self.delegate slider:self valueWithXPosRatio:xPosRatioMin];
            if ([self.delegate respondsToSelector:@selector(slider:roundSelectedValue:)]){
                minSelectedValue = [self.delegate slider:self roundSelectedValue:minSelectedValue];
            }
            self.minSelectedValue = minSelectedValue;
        } else {
            self.minSelectedValue = [self valueWithXPosRatio:xPosRatioMin];
        }
    }
}

- (void)updateMaxSelectedValue {
    if (self.maxSelectedValue != nil || self.maxHandle.dragging){
        float xPosRatioMax = (self.maxHandle.center.x - self.sliderBarStartPosX) / self.sliderBarWidth;
        if (self.delegate && [self.delegate respondsToSelector:@selector(slider:valueWithXPosRatio:)]){
            NSNumber *maxSelectedValue = [self.delegate slider:self valueWithXPosRatio:xPosRatioMax];
            if ([self.delegate respondsToSelector:@selector(slider:roundSelectedValue:)]){
                maxSelectedValue = [self.delegate slider:self roundSelectedValue:maxSelectedValue];
            }
            self.maxSelectedValue = maxSelectedValue;
        } else {
            self.maxSelectedValue = [self valueWithXPosRatio:xPosRatioMax];
        }
    }
}

- (NSNumber *)valueWithXPosRatio:(float)xPosRatio {
    float value = self.minValue + (self.maxValue - self.minValue) * xPosRatio;
    return [NSNumber numberWithFloat:value];
}

- (float)calcHandleXPos:(CGPoint)touchPoint centerOfHandle:(CGPoint)centerOfHandle {
    float distanceY = ABS(touchPoint.y - self.handleCenterPosY);
    float previousDistanceY = ABS(self.previousTouchPoint.y - self.handleCenterPosY);
    float dx = touchPoint.x - self.previousTouchPoint.x;
    float dy = touchPoint.y - self.previousTouchPoint.y;
    float x = centerOfHandle.x + dx * [self handleMoveSpeed:distanceY];

    // move handle when dragging finger to direction to approach slider bar.
    if (distanceY < previousDistanceY){
        float relativeX = touchPoint.x - centerOfHandle.x;
        // If dy / distanceY > 1, handle move strangely.
        x = x + relativeX * MIN(1, ABS(dy / distanceY));
    }
    // handle must be inside of slide bar.
    x = MAX(x, self.sliderBarStartPosX);
    x = MIN(x, self.sliderBarEndPosX);
    return x;
}

- (float)handleMoveSpeed:(float)distanceY {
    if (distanceY < MOVE_SPEED_1_DISTANCE){
        return 1;
    } else {
        return MOVE_SPEED_1_DISTANCE / distanceY;
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    self.minHandle.dragging = NO;
    self.maxHandle.dragging = NO;
}

#pragma is changed method
- (BOOL)isMinValueChanged{
    // calc delta to remove effect of rounding error
    float delta =  self.minSelectedValue.floatValue * DELTA_THRESHHOLD;
    return delta < ABS(self.minSelectedValue.floatValue - self.previousMinSelectedValue.floatValue);
}

- (BOOL)isMaxValueChanged{
    float delta =  self.maxSelectedValue.floatValue * DELTA_THRESHHOLD;
    return delta < ABS(self.maxSelectedValue.floatValue - self.previousMaxSelectedValue.floatValue);
}

#pragma initialize method
- (void)setMinValue:(float)aMinValue maxValue:(float)aMaxValue minHandleView:(UIView *)minHandleView highlightedMinHandleView:(UIView *)highlightedMinHandleView maxHandleView:(UIView *)maxHandleView highlightedMaxHandleView:(UIView *)highlightedMaxHandleView {
    [self setIvars:aMinValue aMaxValue:aMaxValue];
    [self setMinHandleView:minHandleView highlightedMinHandleView:highlightedMinHandleView maxHandleView:maxHandleView highlightedMaxHandleView:highlightedMaxHandleView];
    [self setSliderBarProperties];
}

- (void)setIvars:(float)aMinValue aMaxValue:(float)aMaxValue {
    self.minValue = aMinValue;
    self.maxValue = aMaxValue;
}

- (void)setMinHandleView:(UIView *)minHandleView highlightedMinHandleView:(UIView *)highlightedMinHandleView maxHandleView:(UIView *)maxHandleView highlightedMaxHandleView:(UIView *)highlightedMaxHandleView{
    [self.minHandle setHandleView:minHandleView hilightedHandleView:highlightedMinHandleView];
    self.minHandle.center = CGPointMake(self.minHandle.frame.size.width / 2, self.handleCenterPosY);
    [self.maxHandle setHandleView:maxHandleView hilightedHandleView:highlightedMaxHandleView];
    self.maxHandle.center = CGPointMake(self.frame.size.width - self.maxHandle.frame.size.width / 2, self.handleCenterPosY);
}

- (void)setSliderBarProperties {
    float barHeight = 10;
    float x = self.minHandle.frame.size.width / 2;
    float y = self.bounds.size.height / 2 - barHeight / 2;
    float width = self.frame.size.width - x - self.maxHandle.frame.size.width / 2;
    [self.sliderBar setFrame:CGRectMake(x, y, width, barHeight) minHandle:self.minHandle maxHandle:self.maxHandle];
}

- (void)setMinValue:(float)aMinValue maxValue:(float)aMaxValue handleImageName:(NSString *)handleImageName highlightedHandleImageName:(NSString *)highlightedHandleImageName {
    UIImageView *minHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:handleImageName]];
    UIImageView *highlightedMinHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:highlightedHandleImageName]];
    UIImageView *maxHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:handleImageName]];
    UIImageView *highlightedMaxHandleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:highlightedHandleImageName]];
    [self setMinValue:aMinValue maxValue:aMaxValue minHandleView:minHandleView highlightedMinHandleView:highlightedMinHandleView maxHandleView:maxHandleView highlightedMaxHandleView:highlightedMaxHandleView];
}
@end