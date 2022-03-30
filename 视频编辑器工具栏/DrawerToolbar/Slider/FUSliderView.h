//
//  FUSliderView.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/17.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUSliderView;

@protocol FUSliderViewDelegate <NSObject>
- (void)sliderView:(FUSliderView *)sliderView valueChanged:(float)value isFinished:(BOOL)finished;
@end

typedef NS_ENUM(NSUInteger, FUSliderViewStyle) {
    /// 单向
    FUSliderViewStyleUnidirectional,
    /// 双向
    FUSliderViewStyleBidirectional,
};

@interface FUSliderView : UIView
@property (nonatomic, weak) id<FUSliderViewDelegate> delgate;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, assign, readonly) FUSliderViewStyle style;
//@property (nonatomic, assign) BOOL isIntStep;
@property (nonatomic, assign, getter=isContinuous) BOOL continuous;
@property (nonatomic, copy) NSString *displayFormat;
@property (nonatomic) UIColor *filledColor;
@property (nonatomic, readonly) UIView *gradientView;
@property (nonatomic) CGSize handlerSize;
/// 是否显示底部刻度
@property (nonatomic, assign) BOOL isShowDegreeScaleLabel;

- (void)reloadUIWithStyle:(FUSliderViewStyle)style;
- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue;
- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous;
- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue displayFormat:(NSString *)displayFormat;
- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(NSString *)displayFormat;

- (void)sliderValueChanged:(float)value isFinished:(BOOL)finished;
@end

NS_ASSUME_NONNULL_END
