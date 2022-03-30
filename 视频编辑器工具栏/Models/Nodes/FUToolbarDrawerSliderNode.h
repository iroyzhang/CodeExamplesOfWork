//
//  FUToolbarDrawerSliderNode.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/18.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarDrawerSliderNode : NSObject
@property (nonatomic) float value;
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic, assign, getter=isContinuous) BOOL continuous;
@property (nonatomic, copy) NSString *displayFormat;

- (instancetype)initWithValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous;
- (instancetype)initWithValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(NSString *)displayFormat;
@end

NS_ASSUME_NONNULL_END
