//
//  FUMainAndSubToolDrawerbar.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCollectionView.h"
#import "FUDrawerToolbar.h"

NS_ASSUME_NONNULL_BEGIN

@class FUToolbarCollectionView;

@interface FUMainAndSubToolDrawerbar : UIView <FUDrawerToolbar>
@property (nonatomic, strong) FUToolbarCollectionView *mainCollectionView;
@property (nonatomic, strong) FUToolbarCollectionView *subCollectionView;
@property (nonatomic, copy) UILabel *mainTitleLabel;
@property (nonatomic, copy) UILabel *subTitleLabel;
@end

NS_ASSUME_NONNULL_END
