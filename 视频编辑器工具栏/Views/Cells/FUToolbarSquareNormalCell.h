//
//  FUToolbarSquareNormalCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/18.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarSquareNormalCell : UICollectionViewCell <FUToolbarCell>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

NS_ASSUME_NONNULL_END
