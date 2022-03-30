//
//  FUToolbarResourceCell.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/12/1.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarFilterCell.h"
#import "FUResourceState.h"
#import "FUToolbarItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface FUToolbarResourceCell : FUToolbarFilterCell

@property (nonatomic, assign) FUResourceState state;
@property (nonatomic, strong) FUToolbarItem *item;
@property (nonatomic, strong) RACDisposable *disposable;
@end

NS_ASSUME_NONNULL_END
