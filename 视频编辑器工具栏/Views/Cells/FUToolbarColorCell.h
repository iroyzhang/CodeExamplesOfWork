//
//  FUToolbarColorCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbarCell-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarColorCell : UICollectionViewCell <FUToolbarCell>
@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configureWithToolbarItem:(FUToolbarItem *)item;
@end

NS_ASSUME_NONNULL_END
