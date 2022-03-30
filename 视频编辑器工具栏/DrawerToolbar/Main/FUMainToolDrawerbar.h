//
//  FUMainToolDrawerbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDrawerToolbar.h"

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarCollectionView;

@interface FUMainToolDrawerbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) FUToolbarCollectionView *toolbarCollectionView;
@end

NS_ASSUME_NONNULL_END
