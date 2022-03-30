//
//  FUToolbarSpeedCell.h
//  FUVideoEditor
//
//  Created by Lechech on 2021/6/24.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarSpeedCell : UICollectionViewCell<FUToolbarCell>
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *coverView;
@end

NS_ASSUME_NONNULL_END
