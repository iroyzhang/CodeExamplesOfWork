//
//  FUDrawerToolbarView.h
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUDrawerToolbar.h"
#import "FUKeyFrameButton.h"

NS_ASSUME_NONNULL_BEGIN
@class FUToolbarCollectionView;
@class FUDrawerToolbarView;
@class FUToolbarDrawerSliderNode;
@class FUSlider;
@class FUSliderView;
@class FUAudioRecordButton;
@class FUSegmentedView;
@class FUHueAdjustDrawerToolbar;
@class FUHueAdjustSliderViewModel;

typedef NS_ENUM(NSUInteger, FUDrawerToolbarStyle) {
    FUDrawerToolbarStyleNone,
    FUDrawerToolbarStyleMainAndSlider,
    FUDrawerToolbarStyleMain,
    FUDrawerToolbarStyleSlider,
    FUDrawerToolbarStyleMainAndSegmented,
    FUDrawerToolbarStyleMainAndSub,
    FUDrawerToolbarStyleSegmentedAndSlider,
    FUDrawerToolbarStyleRecord,
    FUDrawerToolbarStyleHueAdjust,
    FUDrawerToolbarStyleMainAndSliderAndButton,
};

@protocol FUDrawerToolbarViewDataSource <NSObject>
@optional
- (NSInteger)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView numberOfItemsInMainCollectionView:(UICollectionView *)collectionView;
- (NSInteger)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView numberOfItemsInSubCollectionView:(UICollectionView *)collectionView;
- (NSInteger)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView numberOfItemsInSegmentedCollectionView:(UICollectionView *)collectionView;
- (NSArray<NSString *> *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView titlesForSegmentControl:(FUSegmentedView *)segmentControl;

- (UICollectionViewCell *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView getCellForMainCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView getCellForSubCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView getCellForSegmentedCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;

- (CGSize)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView itemSizeForMainCollectionViewAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView itemSizeForSubCollectionViewAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView itemSizeForSegmentedCollectionViewAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSString *)mainTitleForDrawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView;
- (nullable NSString *)subTitleForDrawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView;

- (nullable FUToolbarDrawerSliderNode *)sliderNodeForDrawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView;
@end

@protocol FUDrawerToolbarViewDelegate <NSObject>
@optional
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView didSelectedInMainCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView didSelectedInSubCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView didSelectedInSegmentedCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView segmentedControlDidSelectedAtIndex:(NSUInteger)index;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView sliderValueChanged:(NSNumber *)value isFinished:(NSNumber *)isFinished;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView audioRecordButtonDidTapped:(FUAudioRecordButton *)audioRecordButton;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView speedKeyframeButtonDidTapped:(UIButton *)speedKeyframeButton;
- (void)drawerToolbarView:(FUDrawerToolbarView *)drawerToolbarView speedRestButtonDidTapped:(UIButton *)speedRestButton;
@end

@interface FUDrawerToolbarView : UIView
@property (nonatomic, assign, readonly) FUDrawerToolbarStyle currentStyle;
@property (nonatomic, weak) UIView<FUDrawerToolbar> *currentToolbar;
@property (nonatomic, weak) FUSliderView *currentSlider;
@property (nonatomic, weak) id<FUDrawerToolbarViewDataSource> dataSource;
@property (nonatomic, weak) id<FUDrawerToolbarViewDelegate> delegate;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, readonly) FUHueAdjustDrawerToolbar *hueAdjustDrawerToolbar;

- (void)reloadToolbarRestPositionIfNeed:(BOOL)restPositionIfNeed;
- (void)reloadSlider;
- (void)reloadHueAdjustSliderWithViewModel:(FUHueAdjustSliderViewModel *)viewModel;
- (void)reloadSegmentedControl;
- (void)showDrawerWithStyle:(FUDrawerToolbarStyle)style;
- (void)hideDrawer;
- (NSUInteger)currentSegmentedIndex;
- (void)updateSpeedKeyframeButtonWithStatus:(FUKeyFrameButtonStatus)status;
- (void)hideSpeedButtonsWithFlag:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END
