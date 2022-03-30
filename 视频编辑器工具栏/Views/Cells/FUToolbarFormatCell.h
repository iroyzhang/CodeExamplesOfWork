//
//  FUToolbarFormatCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/29.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarFormatCell : UICollectionViewCell <FUToolbarCell>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

NS_ASSUME_NONNULL_END
