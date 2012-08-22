//
//  ViewController.m
//  THDoubleSlider
//
//  Created by hosokawa toru on 08/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate, THDoubleSliderDelegate>
@property (weak, nonatomic) IBOutlet THDoubleSlider *linearDoubleSlider;
@property (weak, nonatomic) IBOutlet UITextField *linearMinTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *linearMaxTextFiled;
- (IBAction)linearMinTextFiledEditingDidEnd:(id)sender;
- (IBAction)linearMaxTextFiledEditingDidEnd:(id)sender;
@property (weak, nonatomic) IBOutlet THDoubleSlider *expDoubleSlider;
@property (weak, nonatomic) IBOutlet UITextField *expMinTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *expMaxTextFiled;
- (IBAction)expMinTextFiledEditingDidEnd:(id)sender;
- (IBAction)expMaxTextFiledEditingDidEnd:(id)sender;
- (IBAction)expDoubleSliderValueChanged:(id)sender;

@end

@implementation ViewController
@synthesize expDoubleSlider;
@synthesize expMinTextFiled;
@synthesize expMaxTextFiled;
@synthesize linearMinTextFiled;
@synthesize linearMaxTextFiled;
@synthesize linearDoubleSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.linearMinTextFiled.delegate = self;
    self.linearMaxTextFiled.delegate = self;
    self.expMinTextFiled.delegate = self;
    self.expMaxTextFiled.delegate = self;

    [self.linearDoubleSlider setMinValue:10 maxValue:100 handleImageName:@"handle.png" highlightedHandleImageName:@"handle_highlight.png"];
    [self.linearDoubleSlider addTarget:self action:@selector(linearDoubleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    UIImageView *minHandleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handleMin.png"]];
    UIImageView *minHighlightedHandleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handleMin.png"]];
    UIImageView *maxHandleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handleMax.png"]];
    UIImageView *maxHighlightedHandleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handleMax.png"]];
    [self.expDoubleSlider setMinValue:0 maxValue:(float)pow(2, 20) minHandleView:minHandleImageView highlightedMinHandleView:minHighlightedHandleImageView maxHandleView:maxHandleImageView highlightedMaxHandleView:maxHighlightedHandleImageView];
    self.expDoubleSlider.delegate = self;
}

- (void)linearDoubleSliderValueChanged:(THDoubleSlider *)slider{
    self.linearMinTextFiled.text = slider.minSelectedValueString;
    self.linearMaxTextFiled.text = slider.maxSelectedValueString;
}

- (IBAction)linearMinTextFiledEditingDidEnd:(id)sender {
    [self.linearDoubleSlider setMinSelectedValueWithStringVale:self.linearMinTextFiled.text animated:YES fireValueChangeEvent:NO];
    if(![self.linearMinTextFiled.text isEqualToString:@""] &&
            ![self.linearMaxTextFiled.text isEqualToString:@""] &&
            self.linearMinTextFiled.text.intValue > self.linearMaxTextFiled.text.intValue){
        self.linearMaxTextFiled.text = self.linearMinTextFiled.text;
        [self linearMaxTextFiledEditingDidEnd:self.linearMaxTextFiled];
    }
}

- (IBAction)linearMaxTextFiledEditingDidEnd:(id)sender {
    [self.linearDoubleSlider setMaxSelectedValueWithStringVale:self.linearMaxTextFiled.text animated:YES fireValueChangeEvent:NO];
    if(![self.linearMinTextFiled.text isEqualToString:@""] &&
            ![self.linearMaxTextFiled.text isEqualToString:@""] &&
            self.linearMaxTextFiled.text.intValue < self.linearMinTextFiled.text.intValue){
        self.linearMinTextFiled.text = self.linearMaxTextFiled.text;
        [self linearMinTextFiledEditingDidEnd:self.linearMinTextFiled];
    }
}

- (IBAction)expMinTextFiledEditingDidEnd:(id)sender {
    [self.expDoubleSlider setMinSelectedValueWithStringVale:self.expMinTextFiled.text animated:YES fireValueChangeEvent:NO];
    if(![self.expMinTextFiled.text isEqualToString:@""] &&
            ![self.expMaxTextFiled.text isEqualToString:@""] &&
            self.expMinTextFiled.text.intValue > self.expMaxTextFiled.text.intValue){
        self.expMaxTextFiled.text = self.expMinTextFiled.text;
        [self expMaxTextFiledEditingDidEnd:self.expMaxTextFiled];
    }
}

- (IBAction)expMaxTextFiledEditingDidEnd:(id)sender {
    [self.expDoubleSlider setMaxSelectedValueWithStringVale:self.expMaxTextFiled.text animated:YES fireValueChangeEvent:NO];
    if(![self.expMinTextFiled.text isEqualToString:@""] &&
            ![self.expMaxTextFiled.text isEqualToString:@""] &&
            self.expMaxTextFiled.text.intValue < self.expMinTextFiled.text.intValue){
        self.expMinTextFiled.text = self.expMaxTextFiled.text;
        [self expMinTextFiledEditingDidEnd:self.expMinTextFiled];
    }
}

- (IBAction)expDoubleSliderValueChanged:(id)sender {
    THDoubleSlider *slider = sender;
    if (slider.isMinValueChanged) {
        self.expMinTextFiled.text = [NSString stringWithFormat:@"%0.0f", slider.minSelectedValue.floatValue];
    }
    if (slider.isMaxValueChanged) {
        self.expMaxTextFiled.text = [NSString stringWithFormat:@"%0.0f", slider.maxSelectedValue.floatValue];
    }
}

#pragma mark THDoubleSliderDelegate method
- (NSNumber *)slider:(THDoubleSlider *)slider roundSelectedValue:(NSNumber *)selectedValue {
    // round by 2 significant digits
    if(selectedValue.floatValue == 0) {
        return [NSNumber numberWithInt:0];
    }

    double d = ceil(log10(selectedValue.floatValue < 0 ? -selectedValue.floatValue: selectedValue.floatValue));
    int power = 2 - (int)d;

    double magnitude = pow(10, power);
    double shifted = round(selectedValue.floatValue * magnitude);
    float rounded = (float)(shifted / magnitude);
    return [NSNumber numberWithFloat:rounded];
}

- (NSNumber *)slider:(THDoubleSlider *)slider valueWithXPosRatio:(CGFloat)xPosRatio{
    if (xPosRatio == 0){
        return [NSNumber numberWithFloat:slider.minValue];
    } else if (xPosRatio == 1){
        return [NSNumber numberWithFloat:slider.maxValue];
    } else {
        float val = slider.minValue + (float)pow(2, xPosRatio * 20);
        return [NSNumber numberWithFloat:val];
    }
}

- (float)slider:(THDoubleSlider *)slider xPosRatioWithValue:(NSNumber *)value{
    if (value.floatValue == 0){
        return 0;
    } else {
        return (float)log2(value.doubleValue) / 20;
    }
}

#pragma mark - UITextFieldDelegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end