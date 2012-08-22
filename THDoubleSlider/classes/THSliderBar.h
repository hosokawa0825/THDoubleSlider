//
//  THSliderBar.h
//
//  Created by hosokawa0825 on 21/08/2012.
//  Copyright 2012 hosokawa0825 All rights reserved.
//  https://github.com/hosokawa0825/THDoubleSlider
//


#import <Foundation/Foundation.h>

@class THDoubleSliderHandle;

@interface THSliderBar : UIView
@property(nonatomic, strong) THDoubleSliderHandle *minHandle;
@property(nonatomic, strong) THDoubleSliderHandle *maxHandle;
@property(nonatomic, strong) UIColor *centerColor;
@property(nonatomic, strong) UIColor *sideColor;

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius centerColor:(UIColor *)centerColor  sideColor:(UIColor *)sideColor minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle;
- (id)initWithFrame:(CGRect)frame minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle;
- (void)setFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius centerColor:(UIColor *)centerColor  sideColor:(UIColor *)sideColor minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle;
- (void)setFrame:(CGRect)frame minHandle:(THDoubleSliderHandle *)minHandle maxHandle:(THDoubleSliderHandle *)maxHandle;
@end