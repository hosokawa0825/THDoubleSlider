//
//  UIWindow+MySendEvent.m
//  THDoubleSlider
//
//  Created by hosokawa toru on 12/08/21.
//
//

#import "UIWindow+MySendEvent.h"
#import "THDoubleSlider.h"

@implementation UIWindow (MySendEvent)

- (void)mySendEvent:(UIEvent *)event {
    NSSet* touches = [event allTouches];
    // One finger drag is expected to operate double slider.
    if (touches.count == 1){
        UITouch *touch = [touches.allObjects objectAtIndex:0];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:touch forKey:TOUCH_OBJECT_KEY];
        if (touch.phase == UITouchPhaseMoved){
            [[NSNotificationCenter defaultCenter] postNotificationName:DRAGGING_NOTIFICATION object:self userInfo:userInfo];
        } else if (touch.phase == UITouchPhaseEnded){
            [[NSNotificationCenter defaultCenter] postNotificationName:DID_DRAG_NOTIFICATION object:self userInfo:userInfo];
        }
    }
    [self mySendEvent:event];
}

@end
