//
//  FUMainAndSliderDrawerToolbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCollectionView.h"
#import "FUDrawerToolbar.h"
#import "FUToolbarDrawerNode.h"

NS_ASSUME_NONNULL_BEGIN

@class FUSliderView;

@interface FUMainAndSliderDrawerToolbar : UIView <FUDrawerToolbar>
@property (nonatomic, assign, getter=isFullScreen) BOOL isSliderHidden;
@property (nonatomic, strong) FUToolbarCollectionView *toolbarCollectionView;
@property (nonatomic, strong) FUSliderView *slider;
@end

NS_ASSUME_NONNULL_END
