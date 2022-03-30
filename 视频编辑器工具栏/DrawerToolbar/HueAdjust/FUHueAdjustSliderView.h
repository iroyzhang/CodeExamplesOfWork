//
//  FUHueAdjustSliderView.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/4/8.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FUSliderView;

@interface FUHueAdjustSliderView : UIView
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *valueLabel;
@property (nonatomic, readonly) FUSliderView *slider;

- (instancetype)initWithFrame:(CGRect)frame isGradientSliderView:(BOOL)isGradientSliderView;
- (void)updateGradientWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;
@end

NS_ASSUME_NONNULL_END
