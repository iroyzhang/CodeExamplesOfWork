//
//  FUHueAdjustDrawerToolbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/4/7.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDrawerToolbar.h"
#import "FUHueAdjustSliderType.h"

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarCollectionView;

@interface FUHueAdjustDrawerToolbar : UIView <FUDrawerToolbar>
@property (nonatomic) FUToolbarCollectionView *collectionView;

- (void)sliderValueChanged:(float)value forType:(FUHueAdjustSliderType)type isFinished:(BOOL)isFinished;
- (void)setSliderValue:(float)value minValue:(float)minValue maxValue:(float)maxValue forType:(FUHueAdjustSliderType)type;
- (void)updateGradientWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations forType:(FUHueAdjustSliderType)type;
@end

NS_ASSUME_NONNULL_END
