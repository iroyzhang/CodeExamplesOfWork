//
//  FUSliderToolDrawerbar.h
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

@interface FUSliderToolDrawerbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) FUSliderView *slider;
@end

NS_ASSUME_NONNULL_END
