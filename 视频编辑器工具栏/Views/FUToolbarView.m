//
//  FUToolbarView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarView.h"
#import <Masonry/Masonry.h>
#import "FUToolbarCollectionViewLayout.h"
#import "FUToolbarBackButton.h"
#import "TransformConstants.h"
#import "FUToolbarCollectionView.h"
#import "FUTheme.h"
#import "UIView+Convenient.h"

@interface FUToolbarView()
@end

static const NSTimeInterval kAnimationDuration = 0.2;
static const CGFloat kDefaultLeftMargin = 44;
static const CGFloat kBackButtonWidth = 44;
static const CGFloat kBackButtonHeight = 50;

@implementation FUToolbarView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentLevel = FUToolbarViewLevelMain;
        [self setupViews];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateViewsFrame];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    _mainToolbar.originX = 0;
    _mainToolbar.width = self.width;
    _mainToolbar.height = self.height;
    _subToolbar.originX = 0;
    _subToolbar.width = self.width;
    _subToolbar.height = FUSubToolbarHeight;
    _backButton.originX = 0;
    _backButton.width = kBackButtonWidth;
    _backButton.height = kBackButtonHeight;
    
    switch (_currentLevel) {
        case FUToolbarViewLevelMain:
            _mainToolbar.originY = 0;
            _subToolbar.originY = self.height;
            break;
        case FUToolbarViewLevelSub:
            _mainToolbar.originY = self.height;
            _subToolbar.originY = self.height - FUSubToolbarHeight;
            break;
    }
    _backButton.originY = CGRectGetMidY(_subToolbar.frame) - kBackButtonHeight / 2.0;
}

#pragma mark - Setups

- (void)setupViews {
    [self setupMainToolbar];
    [self setupSubToolbar];
    [self setupBackButton];
}

- (void)setupMainToolbar {
    _mainToolbar = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _mainToolbar.backgroundColor = FUTheme.toolbarBackgroundColor;
    [self addSubview:_mainToolbar];
}

- (void)setupSubToolbar {
    _subToolbar = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _subToolbar.backgroundColor = FUTheme.toolbarBackgroundColor;
    _subToolbar.contentInset = UIEdgeInsetsMake(0, kDefaultLeftMargin, 0, 0);
    [self addSubview:_subToolbar];
}

- (void)setupBackButton {
    _backButton = [[FUToolbarBackButton alloc] init];
    _backButton.backgroundColor = FUTheme.toolbarBackgroundColor;
    [_backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
}

#pragma mark - Actions

- (void)backButtonTapped:(FUToolbarBackButton *)backButton {
    [_delegate toolbarView:self backButtonTapped:backButton];
}

#pragma mark - Custom Accessors

- (void)setDataSource:(id<FUToolbarViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self resetDataSource];
}

- (void)setDelegate:(id<FUToolbarViewDelegate>)delegate {
    _delegate = delegate;
    [self resetDelegate];
}

#pragma mark - Reload

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    switch (_currentLevel) {
        case FUToolbarViewLevelMain:
            cell = [_mainToolbar dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            break;
        case FUToolbarViewLevelSub:
            cell = [_subToolbar dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            break;
    }
    return cell;
}

- (void)reloadData {
    switch (_currentLevel) {
        case FUToolbarViewLevelMain:
            [self adjustContentInsetForMainCollectionView];
            [_mainToolbar reloadData];
            break;
        case FUToolbarViewLevelSub:
            [self adjustContentInsetForSubCollectionView];
            [_subToolbar reloadData];
            break;
    }
}

- (void)adjustContentInsetForMainCollectionView {
    NSUInteger itemsCount = [_dataSource collectionView:_mainToolbar numberOfItemsInSection:0];
    CGFloat cellSpacing = 10;
    CGFloat collectionViewWidth = CGRectGetWidth(self.frame);
    CGFloat totalSpacing = (itemsCount - 1) * cellSpacing;
    CGFloat contentWidth = totalSpacing + itemsCount * 50.0;
    
    if (contentWidth < collectionViewWidth) {
        CGFloat centerMargin = (collectionViewWidth - contentWidth) / 2.0;
        _mainToolbar.contentInset = UIEdgeInsetsMake(0.0, centerMargin, 0.0, centerMargin);
    } else {
        _mainToolbar.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
}

- (void)adjustContentInsetForSubCollectionView {
    NSUInteger itemsCount = [_dataSource collectionView:_subToolbar numberOfItemsInSection:0];
    CGFloat cellSpacing = 10;
    CGFloat collectionViewWidth = CGRectGetWidth(self.frame) - kDefaultLeftMargin;
    CGFloat totalSpacing = (itemsCount - 1) * cellSpacing;
    CGFloat contentWidth = totalSpacing + itemsCount * 50.0;
    
    if (contentWidth < collectionViewWidth) {
        CGFloat centerMargin = (collectionViewWidth - contentWidth) / 2.0;
        _subToolbar.contentInset = UIEdgeInsetsMake(0.0, centerMargin + kDefaultLeftMargin, 0.0, centerMargin);
    } else {
        _subToolbar.contentInset = UIEdgeInsetsMake(0.0, kDefaultLeftMargin, 0.0, 0.0);
    }
}

#pragma mark - Switch

- (void)showToolbarWithLevel:(FUToolbarViewLevel)level {
    if (_currentLevel == level) { return; }
    _currentLevel = level;
    [self resetDataSource];
    [self resetDelegate];
    
    switch (level) {
        case FUToolbarViewLevelMain: {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.mainToolbar.originY = 0;
                self.subToolbar.originY = self.height;
                self.backButton.originY = CGRectGetMidY(self.subToolbar.frame) - kBackButtonHeight / 2.0;
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case FUToolbarViewLevelSub: {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.mainToolbar.originY = self.height;
                self.subToolbar.originY = self.height - FUSubToolbarHeight;
                self.backButton.originY = CGRectGetMidY(self.subToolbar.frame) - kBackButtonHeight / 2.0;
            } completion:^(BOOL finished) {
            }];
        }
            break;
    }
}

- (void)resetDataSource {
    switch (_currentLevel) {
        case FUToolbarViewLevelMain:
            _mainToolbar.dataSource = self.dataSource;
            _subToolbar.dataSource = nil;
            break;
        case FUToolbarViewLevelSub:
            _mainToolbar.dataSource = nil;
            _subToolbar.dataSource = self.dataSource;
            break;
    }
}

- (void)resetDelegate {
    switch (_currentLevel) {
        case FUToolbarViewLevelMain:
            _mainToolbar.delegate = self.delegate;
            _subToolbar.delegate = nil;
            break;
        case FUToolbarViewLevelSub:
            _mainToolbar.delegate = nil;
            _subToolbar.delegate = self.delegate;
            break;
    }
}

@end
