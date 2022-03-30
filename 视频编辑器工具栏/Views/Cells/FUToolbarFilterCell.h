//
//  FUToolbarFilterCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarFilterCell: UICollectionViewCell <FUToolbarCell>
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *coverView;
@end

NS_ASSUME_NONNULL_END
