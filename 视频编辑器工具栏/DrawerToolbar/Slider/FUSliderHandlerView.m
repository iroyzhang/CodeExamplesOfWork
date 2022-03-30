//
//  FUSliderHandlerView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/9/17.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUSliderHandlerView.h"

@implementation FUSliderHandlerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect insetRect = CGRectInset(self.bounds, -12, -12);
    if (CGRectContainsPoint(insetRect, point)) {
        return self;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
