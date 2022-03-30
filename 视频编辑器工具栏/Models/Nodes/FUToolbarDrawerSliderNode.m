//
//  FUToolbarDrawerSliderNode.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/18.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarDrawerSliderNode.h"

@implementation FUToolbarDrawerSliderNode

- (instancetype)initWithValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous {
    return [self initWithValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:continuous displayFormat:fuStr(%.0f)];
}

- (instancetype)initWithValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(nonnull NSString *)displayFormat {
    self = [super init];
    if (self) {
        _value = value;
        _minimumValue = minimumValue;
        _maximumValue = maximumValue;
        _continuous = continuous;
        _displayFormat = displayFormat;
    }
    return self;
}

@end
