//
//  FUMainAndSliderAndButtonDrawerToolbar.h
//  FUVideoEditor
//
//  Created by Lechech on 2021/6/22.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCollectionView.h"
#import "FUDrawerToolbar.h"
#import "FUToolbarDrawerNode.h"

NS_ASSUME_NONNULL_BEGIN

@class FUSliderView;
@class FUMainAndSliderAndButtonDrawerToolbar;
@class FUSpeedKeyFrameButton;

@interface FUMainAndSliderAndButtonDrawerToolbar : UIView<FUDrawerToolbar>

@property (nonatomic, strong) FUToolbarCollectionView *toolbarCollectionView;
@property (nonatomic, strong) FUSliderView *slider;
@property (nonatomic, strong) FUSpeedKeyFrameButton *keyFrameButton;
@property (nonatomic, strong) UIButton *resetButton;

@end

NS_ASSUME_NONNULL_END
