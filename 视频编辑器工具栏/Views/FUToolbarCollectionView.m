//
//  FUToolbarCollectionView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarCollectionView.h"
#import "FUToolbarCollectionViewLayout.h"
#import "FUToolbarNormalCell.h"
#import "FUToolbarColorCell.h"
#import "FUToolbarFilterCell.h"
#import "FUToolbarSquareNormalCell.h"
#import "FUToolbarColorPaletteCell.h"
#import "FUToolbarFormatCell.h"
#import "FUToolbarResourceCell.h"
#import "FUToolbarGifCell.h"
#import "FUToolbarSpeedCell.h"
#import "FUTheme.h"
#import "TransformConstants.h"

@interface FUToolbarCollectionView()
@property (nonatomic, strong) FUToolbarCollectionViewLayout *toolbarCollectionViewLayout;
@end

@implementation FUToolbarCollectionView

+ (instancetype)toolbarCollectionViewWithFrame:(CGRect)frame {
    FUToolbarCollectionViewLayout *collectionViewLayout = [[FUToolbarCollectionViewLayout alloc] init];
    collectionViewLayout.itemSize = CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
    FUToolbarCollectionView *toolbarCollectionView = [[FUToolbarCollectionView alloc] initWithFrame:frame collectionViewLayout:collectionViewLayout];
    return toolbarCollectionView;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        if ([layout isKindOfClass:[FUToolbarCollectionViewLayout class]]) {
            self.toolbarCollectionViewLayout = (FUToolbarCollectionViewLayout *)layout;
        }
        [self registerClass:[FUToolbarNormalCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarNormalCell class])];
        [self registerClass:[FUToolbarColorCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarColorCell class])];
        [self registerClass:[FUToolbarFilterCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarFilterCell class])];
        [self registerClass:[FUToolbarSquareNormalCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarSquareNormalCell class])];
        [self registerClass:[FUToolbarColorPaletteCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarColorPaletteCell class])];
        [self registerClass:[FUToolbarFormatCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarFormatCell class])];
        [self registerClass:[FUToolbarResourceCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarResourceCell class])];
        [self registerClass:[FUToolbarGifCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarGifCell class])];
        [self registerClass:[FUToolbarSpeedCell class] forCellWithReuseIdentifier:NSStringFromClass([FUToolbarSpeedCell class])];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

@end
