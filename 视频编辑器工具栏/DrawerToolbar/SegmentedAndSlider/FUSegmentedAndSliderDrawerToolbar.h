//
//  FUSegmentedAndSliderDrawerToolbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/7/30.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDrawerToolbar.h"
#import "FUSliderView.h"

NS_ASSUME_NONNULL_BEGIN

@class FUSegmentedView;

@interface FUSegmentedAndSliderDrawerToolbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) FUSegmentedView *segmentedControl;
@property (nonatomic, strong) FUSliderView *slider;
@end

NS_ASSUME_NONNULL_END
