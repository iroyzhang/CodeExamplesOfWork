//
//  FUToolbarCollectionView.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUToolbar-Protocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarCollectionView : UICollectionView <FUToolbar>
+ (instancetype)toolbarWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
