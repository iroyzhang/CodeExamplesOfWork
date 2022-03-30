//
//  FUMainToolDrawerbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUMainToolDrawerbar.h"
#import "FUToolbarCollectionViewLayout.h"
#import "FUToolbarCollectionView.h"
#import "TransformConstants.h"
#import <Masonry/Masonry.h>
#import "FUTheme.h"
#import "FUTemplateMethods.h"

@implementation FUMainToolDrawerbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
        [FUTemplateMethods addDrawerStyleShadowForView:self];
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView {
    _toolbarCollectionView = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _toolbarCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 0);
    _toolbarCollectionView.showsVerticalScrollIndicator = NO;
    _toolbarCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_toolbarCollectionView];
    [_toolbarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@(FUToolbarHeight));
    }];
}

#pragma mark - FUDrawerToolbar

- (CGFloat)defaultHeight {
    return 80;
}

- (CGFloat)fullHeight {
    return 80;
}

@end
