//
//  FUDrawerToolbarView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUDrawerToolbarView.h"
#import <Masonry/Masonry.h>
#import "FUTheme.h"
#import "TransformConstants.h"
#import "FUSliderViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "FUToolbarDrawerSliderNode.h"
#import "FUMainAndSliderDrawerToolbar.h"
#import "FUSliderToolDrawerbar.h"
#import "FUMainToolDrawerbar.h"
#import "FUMainAndSegmentedDrawerToolbar.h"
#import "FUMainAndSubToolDrawerbar.h"
#import "UIView+Convenient.h"
#import "FUSliderView.h"
#import "FUSegmentedAndSliderDrawerToolbar.h"
#import "FUAudioRecordToolDrawerbar.h"
#import "FUAudioRecordButton.h"
#import "FUSegmentedView.h"
#import "FUHueAdjustDrawerToolbar.h"
#import "FUHueAdjustSliderViewModel.h"
#import "FUToneGradientColorsTool.h"
#import "FUMainAndSliderAndButtonDrawerToolbar.h"
#import "FUSpeedKeyFrameButton.h"

@interface FUDrawerToolbarView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, FUSegmentedViewDelegate>
@property (nonatomic, weak) UICollectionView *mainCollectionView;
@property (nonatomic, weak) UICollectionView *subCollectionView;
@property (nonatomic, weak) UICollectionView *segmentedCollectionView;
@property (nonatomic, weak) FUSliderView *mainSlider;
@property (nonatomic, weak) FUSegmentedView *segmentedControl;
@property (nonatomic, weak) UILabel *mainTitleLabel;
@property (nonatomic, weak) UILabel *subTitleLabel;
@property (nonatomic, weak) FUAudioRecordButton *audioRecordButton;

@property (nonatomic, weak) FUSpeedKeyFrameButton *speedKeyframeButton;
@property (nonatomic, weak) UIButton *speedRestButton;
@end

@implementation FUDrawerToolbarView

static const NSTimeInterval kAnimationDuration = 0.2;

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentStyle = FUDrawerToolbarStyleNone;
        _hueAdjustDrawerToolbar = [[FUHueAdjustDrawerToolbar alloc] init];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadToolbarRestPositionIfNeed:NO];
    [self reloadSlider];
}

#pragma mark - Custom Accessors

- (void)setMainCollectionView:(UICollectionView *)mainCollectionView {
    _mainCollectionView = mainCollectionView;
    if (mainCollectionView) {
        mainCollectionView.dataSource = self;
        mainCollectionView.delegate = self;
    }
}

- (void)setSubCollectionView:(UICollectionView *)subCollectionView {
    _subCollectionView = subCollectionView;
    if (subCollectionView) {
        subCollectionView.dataSource = self;
        subCollectionView.delegate = self;
    }
}

- (void)setSegmentedCollectionView:(UICollectionView *)segmentedCollectionView {
    _segmentedCollectionView = segmentedCollectionView;
    if (segmentedCollectionView) {
        segmentedCollectionView.dataSource = self;
        segmentedCollectionView.delegate = self;
    }
}

- (void)setMainSlider:(FUSliderView *)mainSlider {
    _mainSlider = mainSlider;
    if (mainSlider) {
        RACSignal *valueChanged = [mainSlider rac_signalForSelector:@selector(sliderValueChanged:isFinished:)];
        [valueChanged subscribeNext:^(id  _Nullable x) {
            RACTuple *tuple = (RACTuple *)x;
            [self.delegate drawerToolbarView:self sliderValueChanged:tuple.first isFinished:tuple.second];
        }];
    }
}

- (void)setSegmentedControl:(FUSegmentedView *)segmentedControl {
    _segmentedControl = segmentedControl;
    if (segmentedControl) {
        _segmentedControl.delegate = self;
    }
}

- (void)setAudioRecordButton:(FUAudioRecordButton *)audioRecordButton {
    _audioRecordButton = audioRecordButton;
    if (audioRecordButton) {
        [audioRecordButton addTarget:self action:@selector(audioRecordButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setSpeedKeyframeButton:(FUSpeedKeyFrameButton *)speedKeyframeButton {
    _speedKeyframeButton = speedKeyframeButton;
    if (speedKeyframeButton) {
        [speedKeyframeButton addTarget:self action:@selector(speedKeyframeButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setSpeedRestButton:(UIButton *)speedRestButton {
    _speedRestButton = speedRestButton;
    if (speedRestButton) {
        [speedRestButton addTarget:self action:@selector(speedRestButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)audioRecordButtonDidTapped:(FUAudioRecordButton *)button {
    if (button.recordStatus == FUAudioRecordStatusPlaying) {
        button.recordStatus = FUAudioRecordStatusPause;
    } else {
        button.recordStatus = FUAudioRecordStatusPlaying;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(drawerToolbarView:audioRecordButtonDidTapped:)]) {
        [_delegate drawerToolbarView:self audioRecordButtonDidTapped:button];
    }
}

- (void)speedKeyframeButtonDidTapped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(drawerToolbarView:speedKeyframeButtonDidTapped:)]) {
        [_delegate drawerToolbarView:self speedKeyframeButtonDidTapped:button];
    }
}

- (void)speedRestButtonDidTapped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(drawerToolbarView:speedRestButtonDidTapped:)]) {
        [_delegate drawerToolbarView:self speedRestButtonDidTapped:button];
    }
}

#pragma mark - Reload

- (void)reloadToolbarRestPositionIfNeed:(BOOL)restPositionIfNeed {
    if (_mainCollectionView) {
        [self adjustContentInsetForMainCollectionView];
        if (restPositionIfNeed) {
            [_mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }
        [_mainCollectionView reloadData];
    }
    if (_subCollectionView) {
        [self adjustContentInsetForSubCollectionView];
        if (restPositionIfNeed) {
            [_subCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }
        [_subCollectionView reloadData];
    }
    if (_segmentedCollectionView) {
        [self adjustContentInsetForSegmentedCollectionView];
        if (restPositionIfNeed) {
            [_segmentedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        }
        [_segmentedCollectionView reloadData];
    }
    
    if (_mainTitleLabel) {
        if ([_dataSource respondsToSelector:@selector(mainTitleForDrawerToolbarView:)]) {
            NSString *mainTitle = [_dataSource mainTitleForDrawerToolbarView:self];
            _mainTitleLabel.text = mainTitle;
        }
    }
    if (_subTitleLabel) {
        if ([_dataSource respondsToSelector:@selector(subTitleForDrawerToolbarView:)]) {
            NSString *subTitle = [_dataSource subTitleForDrawerToolbarView:self];
            _subTitleLabel.text = subTitle;
        }
    }
}

- (void)reloadSlider {
    if ([_currentToolbar respondsToSelector:@selector(setSliderValue:minimumValue:maximumValue:continuous:displayFormat:)] && [_dataSource respondsToSelector:@selector(sliderNodeForDrawerToolbarView:)]) {
        FUToolbarDrawerSliderNode *sliderNode = [_dataSource sliderNodeForDrawerToolbarView:self];
        if (sliderNode && (sliderNode.minimumValue < sliderNode.maximumValue)) {
            [_currentToolbar setSliderValue:sliderNode.value minimumValue:sliderNode.minimumValue maximumValue:sliderNode.maximumValue continuous:sliderNode.isContinuous displayFormat:sliderNode.displayFormat];
            if ([_currentToolbar respondsToSelector:@selector(showSlider:)]) {
                [_currentToolbar showSlider:YES];
            }
        } else {
            if ([_currentToolbar respondsToSelector:@selector(hideSlider:)]) {
                [_currentToolbar hideSlider:YES];
            }
        }
    }
}

- (void)reloadHueAdjustSliderWithViewModel:(FUHueAdjustSliderViewModel *)viewModel {
    [_hueAdjustDrawerToolbar setSliderValue:[viewModel valueForType:FUHueAdjustSliderTypeHue].floatValue minValue:[viewModel minimumValueForType:FUHueAdjustSliderTypeHue].floatValue  maxValue:[viewModel maximumValueForType:FUHueAdjustSliderTypeHue].floatValue  forType:FUHueAdjustSliderTypeHue];
    [_hueAdjustDrawerToolbar setSliderValue:[viewModel valueForType:FUHueAdjustSliderTypeSaturation].floatValue minValue:[viewModel minimumValueForType:FUHueAdjustSliderTypeSaturation].floatValue  maxValue:[viewModel maximumValueForType:FUHueAdjustSliderTypeSaturation].floatValue  forType:FUHueAdjustSliderTypeSaturation];
    [_hueAdjustDrawerToolbar setSliderValue:[viewModel valueForType:FUHueAdjustSliderTypeLightness].floatValue minValue:[viewModel minimumValueForType:FUHueAdjustSliderTypeLightness].floatValue  maxValue:[viewModel maximumValueForType:FUHueAdjustSliderTypeLightness].floatValue  forType:FUHueAdjustSliderTypeLightness];
    [_hueAdjustDrawerToolbar setSliderValue:[viewModel valueForType:FUHueAdjustSliderTypeScope].floatValue minValue:[viewModel minimumValueForType:FUHueAdjustSliderTypeScope].floatValue  maxValue:[viewModel maximumValueForType:FUHueAdjustSliderTypeScope].floatValue  forType:FUHueAdjustSliderTypeScope];
    
    CGFloat hueValue = [FUToneGradientColorsTool getHueValueWithColorName:viewModel.colorName];
    NSArray *hueColors = [FUToneGradientColorsTool getHueGradientColorsWithHueValue:hueValue];
    NSArray *saturationColors = [FUToneGradientColorsTool getSaturationGradientColorsWithHueValue:hueValue];
    NSArray *lightnessColors = [FUToneGradientColorsTool getLightnessGradientColorsWithHueValue:hueValue];
    NSArray *locations = @[@0.0, @0.5, @1.0];
    [_hueAdjustDrawerToolbar updateGradientWithColors:hueColors locations:locations forType:FUHueAdjustSliderTypeHue];
    [_hueAdjustDrawerToolbar updateGradientWithColors:saturationColors locations:locations forType:FUHueAdjustSliderTypeSaturation];
    [_hueAdjustDrawerToolbar updateGradientWithColors:lightnessColors locations:locations forType:FUHueAdjustSliderTypeLightness];
}

- (void)reloadSegmentedControl {
    if (_segmentedControl) {
        if (_dataSource && [_dataSource drawerToolbarView:self titlesForSegmentControl:_segmentedControl]) {
            NSArray<NSString *> *titles = [_dataSource drawerToolbarView:self titlesForSegmentControl:_segmentedControl];
            [_segmentedControl removeAllSegments];
            [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_segmentedControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
            }];
        }
        [_segmentedControl setSelectedSegmentIndex:0];
    }
    [_currentToolbar setNeedsLayout];
}

- (void)adjustContentInsetForMainCollectionView {
    if (!_mainCollectionView) { return; }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(drawerToolbarView:numberOfItemsInMainCollectionView:)]) {
        NSUInteger itemsCount = [self.dataSource drawerToolbarView:self numberOfItemsInMainCollectionView:_mainCollectionView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CGSize cellSize = [self.dataSource drawerToolbarView:self itemSizeForMainCollectionViewAtIndexPath:indexPath];
        [self adjustContentInsetForCollectionView:_mainCollectionView itemsCount:itemsCount cellWidth:cellSize.width margin:FUDrawerToolbarHorizontalMargin cellSpacing:FUToolbarCellSpacing];
    }
}

- (void)adjustContentInsetForSubCollectionView {
    if (!_subCollectionView) { return; }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(drawerToolbarView:numberOfItemsInSubCollectionView:)]) {
        NSUInteger itemsCount = [self.dataSource drawerToolbarView:self numberOfItemsInSubCollectionView:_subCollectionView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CGSize cellSize = [self.dataSource drawerToolbarView:self itemSizeForSubCollectionViewAtIndexPath:indexPath];
        [self adjustContentInsetForCollectionView:_subCollectionView itemsCount:itemsCount cellWidth:cellSize.width margin:FUDrawerToolbarHorizontalMargin cellSpacing:FUToolbarCellSpacing];
    }   
}

- (void)adjustContentInsetForSegmentedCollectionView {
    if (!_segmentedCollectionView) { return; }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(drawerToolbarView:numberOfItemsInSegmentedCollectionView:)]) {
        NSUInteger itemsCount = [self.dataSource drawerToolbarView:self numberOfItemsInSegmentedCollectionView:_segmentedCollectionView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        CGSize cellSize = [self.dataSource drawerToolbarView:self itemSizeForSegmentedCollectionViewAtIndexPath:indexPath];
        [self adjustContentInsetForCollectionView:_segmentedCollectionView itemsCount:itemsCount cellWidth:cellSize.width margin:FUDrawerToolbarHorizontalMargin cellSpacing:FUToolbarCellSpacing];
    }
}

- (void)adjustContentInsetForCollectionView:(UICollectionView *)collectionView itemsCount:(NSUInteger)itemsCount cellWidth:(CGFloat)cellWidth margin:(CGFloat)margin cellSpacing:(CGFloat)cellSpacing {
    CGFloat collectionViewWidth = CGRectGetWidth(self.frame);
    CGFloat totalSpacing = (itemsCount - 1) * cellSpacing;
//    CGFloat contentWidth = collectionView.contentSize.width;
//    if (contentWidth == 0) {
    CGFloat contentWidth = totalSpacing + 2 * margin + itemsCount * cellWidth;
//    }
    if (contentWidth < collectionViewWidth) {
        CGFloat centerMargin = (contentWidth - collectionViewWidth) / 2.0;
        collectionView.contentInset = UIEdgeInsetsMake(0.0, -centerMargin, 0.0, centerMargin);
    } else {
        collectionView.contentInset = UIEdgeInsetsMake(0.0, margin, 0.0, 8.0);
    }
}

#pragma mark - Show

- (void)showDrawerWithStyle:(FUDrawerToolbarStyle)style {
    if (_currentStyle == style) {
        [self reloadToolbarRestPositionIfNeed:YES];
        return;
    }
    [self removeOtherToolbar];
    _currentStyle = style;
    switch (style) {
        case FUDrawerToolbarStyleMainAndSlider:
            [self presentMainAndSliderToolbar];
            break;
        case FUDrawerToolbarStyleSlider:
            [self presentSliderToolbar];
            break;
        case FUDrawerToolbarStyleMain:
            [self presentMainToolbar];
            break;
        case FUDrawerToolbarStyleMainAndSegmented:
            [self presentMainAndSegmentedToolbar];
            break;
        case FUDrawerToolbarStyleMainAndSub:
            [self presentMainAndSubToolbar];
            break;
        case FUDrawerToolbarStyleSegmentedAndSlider:
            [self presentSegmentedAndSliderToolbar];
            break;
        case FUDrawerToolbarStyleRecord:
            [self presentAudioRecordToolbar];
            break;
        case FUDrawerToolbarStyleHueAdjust:
            [self presentHueAdjustToolbar];
            break;
        case FUDrawerToolbarStyleMainAndSliderAndButton:
            [self presentMainAndSliderAndButtonToolbar];
            break;
        default:
            break;
    }
    [self reloadToolbarRestPositionIfNeed:NO];
}

- (void)presentMainAndSliderToolbar {
    FUMainAndSliderDrawerToolbar *toolbar = [[FUMainAndSliderDrawerToolbar alloc] initWithFrame:CGRectZero];
    self.mainCollectionView = toolbar.toolbarCollectionView;
    self.mainSlider = toolbar.slider;
    CGFloat toolbarHeight = toolbar.fullHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
    self.currentSlider = toolbar.slider;
}

- (void)presentMainToolbar {
    FUMainToolDrawerbar *toolbar = [[FUMainToolDrawerbar alloc] init];
    self.mainCollectionView = toolbar.toolbarCollectionView;
    CGFloat toolbarHeight = toolbar.fullHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
}

- (void)presentSliderToolbar {
    FUSliderToolDrawerbar *toolbar = [[FUSliderToolDrawerbar alloc] initWithFrame:CGRectZero];
    self.mainSlider = toolbar.slider;
    CGFloat toolbarHeight = toolbar.fullHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
}

- (void)presentMainAndSegmentedToolbar {
    FUMainAndSegmentedDrawerToolbar *toolbar = [[FUMainAndSegmentedDrawerToolbar alloc] initWithFrame:CGRectZero];
    self.segmentedCollectionView = toolbar.toolbarCollectionView;
    self.mainSlider = toolbar.slider;
    self.segmentedControl = toolbar.segmentedControl;
    CGFloat toolbarHeight = toolbar.defaultHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
}

- (void)presentMainAndSubToolbar {
    FUMainAndSubToolDrawerbar *toolbar = [[FUMainAndSubToolDrawerbar alloc] initWithFrame:CGRectZero];
    self.mainCollectionView = toolbar.mainCollectionView;
    self.subCollectionView = toolbar.subCollectionView;
    self.mainTitleLabel = toolbar.mainTitleLabel;
    self.subTitleLabel = toolbar.subTitleLabel;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbar.fullHeight];
    self.currentToolbar = toolbar;
}

- (void)presentSegmentedAndSliderToolbar {
    FUSegmentedAndSliderDrawerToolbar *toolbar = [[FUSegmentedAndSliderDrawerToolbar alloc] initWithFrame:CGRectZero];
    self.mainSlider = toolbar.slider;
    self.segmentedControl = toolbar.segmentedControl;
    CGFloat toolbarHeight = toolbar.defaultHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
}

- (void)presentAudioRecordToolbar {
    FUAudioRecordToolDrawerbar *toolbar = [[FUAudioRecordToolDrawerbar alloc] initWithFrame:CGRectZero];
    CGFloat toolbarHeight = toolbar.defaultHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
    self.audioRecordButton = toolbar.recordButton;
}

- (void)presentHueAdjustToolbar {
    FUHueAdjustDrawerToolbar *toolbar = _hueAdjustDrawerToolbar;
    CGFloat toolbarHeight = toolbar.defaultHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
    self.mainCollectionView = toolbar.collectionView;
}

- (void)presentMainAndSliderAndButtonToolbar {
    FUMainAndSliderAndButtonDrawerToolbar *toolbar = [[FUMainAndSliderAndButtonDrawerToolbar alloc] initWithFrame:CGRectZero];
    self.mainCollectionView = toolbar.toolbarCollectionView;
    self.mainSlider = toolbar.slider;
    CGFloat toolbarHeight = toolbar.fullHeight;
    [self showDrawerWithToolbar:toolbar toolbarHeight:toolbarHeight];
    self.currentToolbar = toolbar;
    self.currentSlider = toolbar.slider;
    self.speedKeyframeButton = toolbar.keyFrameButton;
    self.speedRestButton = toolbar.resetButton;
}

- (void)removeOtherToolbar {
    for (UIView *subview in self.subviews) {
        if ([subview conformsToProtocol:@protocol(FUDrawerToolbar)]) {
            [subview removeFromSuperview];
        }
    }
    self.mainCollectionView = nil;
    self.subCollectionView = nil;
    self.segmentedCollectionView = nil;
    self.mainSlider = nil;
    self.segmentedControl = nil;
    self.mainTitleLabel = nil;
    self.subTitleLabel = nil;
    _currentToolbar = nil;
    _currentStyle = FUDrawerToolbarStyleNone;
}

#pragma mark - Show Or Hide

- (void)showDrawerWithToolbar:(UIView *)toolbar toolbarHeight:(CGFloat)toolbarHeight {
//    toolbar.frame = CGRectMake(0, CGRectGetHeight(self.frame) - FUSubToolbarHeight, CGRectGetWidth(self.frame), toolbarHeight);
    [self addSubview:toolbar];
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-FUSubToolbarHeight);
        make.height.equalTo(@(toolbarHeight));
    }];
    self.isAnimating = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        toolbar.transform = CGAffineTransformMakeTranslation(0.0, -toolbarHeight);
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

- (void)hideDrawer {
    if (self.currentStyle == FUDrawerToolbarStyleNone) { return; }
     
    self.isAnimating = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.currentToolbar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeOtherToolbar];
        self.isAnimating = NO;
    }];
}

- (void)updateSpeedKeyframeButtonWithStatus:(FUKeyFrameButtonStatus)status {
    [_speedKeyframeButton setStatus:status];
}

- (void)hideSpeedButtonsWithFlag:(BOOL)flag {
    _speedKeyframeButton.hidden = flag;
    _speedRestButton.hidden = flag;
}

#pragma mark - Helpers

- (NSUInteger)currentSegmentedIndex {
    if (_segmentedControl) {
        return _segmentedControl.selectedSegmentIndex;
    } else {
        return 0;
    }
}

#pragma mark - FUSegmentedViewDelegate

- (void)segmentedView:(FUSegmentedView *)segmentedView didSelectedAtIndex:(NSUInteger)index {
    if (_delegate && [_delegate respondsToSelector:@selector(drawerToolbarView:segmentedControlDidSelectedAtIndex:)]) {
        [_delegate drawerToolbarView:self segmentedControlDidSelectedAtIndex:index];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:_mainCollectionView]) {
        return [_dataSource drawerToolbarView:self numberOfItemsInMainCollectionView:collectionView];
    } else if ([collectionView isEqual:_subCollectionView]) {
        return [_dataSource drawerToolbarView:self numberOfItemsInSubCollectionView:collectionView];
    } else if ([collectionView isEqual:_segmentedCollectionView]) {
        return [_dataSource drawerToolbarView:self numberOfItemsInSegmentedCollectionView:collectionView];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_mainCollectionView]) {
        return [_dataSource drawerToolbarView:self getCellForMainCollectionView:collectionView atIndexPath:indexPath];
    } else if ([collectionView isEqual:_subCollectionView]) {
        return [_dataSource drawerToolbarView:self getCellForSubCollectionView:collectionView atIndexPath:indexPath];
    } else if ([collectionView isEqual:_segmentedCollectionView]) {
        return [_dataSource drawerToolbarView:self getCellForSegmentedCollectionView:collectionView atIndexPath:indexPath];
    } else {
        return [UICollectionViewCell new];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_mainCollectionView]) {
        return [_dataSource drawerToolbarView:self itemSizeForMainCollectionViewAtIndexPath:indexPath];
    } else if ([collectionView isEqual:_subCollectionView]) {
        return [_dataSource drawerToolbarView:self itemSizeForSubCollectionViewAtIndexPath:indexPath];
    } else if ([collectionView isEqual:_segmentedCollectionView]) {
        return [_dataSource drawerToolbarView:self itemSizeForSegmentedCollectionViewAtIndexPath:indexPath];
    } else {
        return CGSizeMake(FUToolbarCellSize, FUToolbarCellSize);
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:_mainCollectionView]) {
        [self.delegate drawerToolbarView:self didSelectedInMainCollectionView:collectionView atIndexPath:indexPath];
    } else if ([collectionView isEqual:_subCollectionView]) {
        [self.delegate drawerToolbarView:self didSelectedInSubCollectionView:collectionView atIndexPath:indexPath];
    } else if ([collectionView isEqual:_segmentedCollectionView]) {
        [self.delegate drawerToolbarView:self didSelectedInSegmentedCollectionView:collectionView atIndexPath:indexPath];
    } else {
        return;
    }
}

@end
