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
 
NS_ASSUME_NONNULL_BEGIN

@class FUSliderView;
@class FUSegmentedView;

@interface FUMainAndSegmentedDrawerToolbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) FUSegmentedView *segmentedControl;
@property (nonatomic, strong) FUSliderView *slider;
@property (nonatomic, strong) FUToolbarCollectionView *toolbarCollectionView;
@end

NS_ASSUME_NONNULL_END
