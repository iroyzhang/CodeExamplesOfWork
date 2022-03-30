//
//  FUToolbarColorPaletteCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/22.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarColorPaletteCell : UICollectionViewCell <FUToolbarCell>
@property (nonatomic, strong) UIImageView *colorView;
@end

NS_ASSUME_NONNULL_END
