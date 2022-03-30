//
//  FUMainAndSubToolDrawerbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUMainAndSubToolDrawerbar.h"
#import "FUToolbarCollectionViewLayout.h"
#import <Masonry/Masonry.h>
#import "FUTheme.h"
#import "FUTemplateMethods.h"

@interface FUMainAndSubToolDrawerbar()
@property (nonatomic, strong) FUToolbarCollectionViewLayout *mainToolbarCollectionViewLayout;
@property (nonatomic, strong) FUToolbarCollectionViewLayout *subToolbarCollectionViewLayout;
@end

@implementation FUMainAndSubToolDrawerbar

#pragma makr - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Setups

- (void)setupViews {
    self.backgroundColor = [FUTheme drawerToolbarBackgroundColor];
    [FUTemplateMethods addDrawerStyleShadowForView:self];
    [self setupCollectionViews];
    [self setupLabels];
    [self makeConstraints];
}

- (void)setupCollectionViews {
    _mainCollectionView = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _mainCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 0);
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    _mainCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_mainCollectionView];
    
    _subCollectionView = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _subCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 0);
    _subCollectionView.showsVerticalScrollIndicator = NO;
    _subCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_subCollectionView];
}

- (void)setupLabels {
    _mainTitleLabel = [[UILabel alloc] init];
    _mainTitleLabel.font = [UIFont systemFontOfSize:12];
    _mainTitleLabel.textColor = [UIColor colorWithRed:154/255.0 green:157/255.0 blue:184/255.0 alpha:1.0];
    [self addSubview:_mainTitleLabel];
    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.font = [UIFont systemFontOfSize:12];
    _subTitleLabel.textColor = [UIColor colorWithRed:154/255.0 green:157/255.0 blue:184/255.0 alpha:1.0];
    [self addSubview:_subTitleLabel];
}

- (void)makeConstraints {
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.top.offset(8);
        make.trailing.offset(-8);
    }];
    
    [_subCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(8);
        make.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    [_mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subCollectionView.mas_bottom).offset(8);
        make.leading.equalTo(self).offset(8);
        make.trailing.offset(-8);
    }];
    
    [_mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(_mainTitleLabel.mas_bottom).offset(8);
        make.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
}

#pragma mark - FUDrawerToolbar

- (void)reloadData {
    [_mainCollectionView reloadData];
    [_subCollectionView reloadData];
}

- (CGFloat)defaultHeight {
    return 174;
}

- (CGFloat)fullHeight {
    return 174;
}

@end
