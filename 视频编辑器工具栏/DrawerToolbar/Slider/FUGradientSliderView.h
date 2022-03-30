//
//  FUGradientSliderView.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/4/12.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import "FUSliderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUGradientSliderView : FUSliderView
- (void)setGradientColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;
@end

NS_ASSUME_NONNULL_END
