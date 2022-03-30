//
//  FUMainAndSegmentedDrawerToolbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCollectionView.h"
#import "FUDrawerToolbar.h"
#import "FUToolbarDrawerNode.h"

NS_ASSUME_NONNULL_BEGIN

@class FUSlider;

@interface FUMainAndSegmentedDrawerToolbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) FUSlider *slider;
@property (nonatomic, strong) FUToolbarCollectionView *toolbarCollectionView;
@end

NS_ASSUME_NONNULL_END
