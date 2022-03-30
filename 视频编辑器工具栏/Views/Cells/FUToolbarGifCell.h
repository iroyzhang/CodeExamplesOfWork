//
//  FUToolbarGifCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/12/17.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@class FLAnimatedImageView;

@interface FUToolbarGifCell : UICollectionViewCell <FUToolbarCell>
@property (nonatomic, strong) FLAnimatedImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *coverView;
@end

NS_ASSUME_NONNULL_END
