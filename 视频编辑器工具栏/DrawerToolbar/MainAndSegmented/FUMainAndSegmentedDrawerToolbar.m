//
//  FUMainAndSegmentedDrawerToolbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUMainAndSegmentedDrawerToolbar.h"
#import "FUToolbarCollectionViewLayout.h"
#import "FUToolbarCollectionView.h"
#import <Masonry/Masonry.h>
#import "TransformConstants.h"
#import "FUToolbarFilterCell.h"
#import "FUSliderView.h"
#import "FUSliderViewModel.h"
#import "FUValueFormatter.h"
#import "FUTheme.h"
#import "UIView+Convenient.h"
#import "FUSegmentedView.h"
#import "FUTemplateMethods.h"

@implementation FUMainAndSegmentedDrawerToolbar

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
        [FUTemplateMethods addDrawerStyleShadowForView:self];
        [self setupViews];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reMakeConstraints];
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    [self updateViewsFrame];
//}
//
//- (void)updateViewsFrame {
//    CGFloat sliderHeight = 24;
//    CGFloat segmentedControl = 32;
//    CGFloat singleSegmentedWidth = 46;
//    CGFloat collectionViewHeight = 50;
//
//    CGFloat segmentedControlWidth = singleSegmentedWidth * _segmentedControl.numberOfSegments;
//    _segmentedControl.frame = CGRectMake(8, 16, segmentedControlWidth, segmentedControl);
//
//    CGFloat sliderOriginX = segmentedControlWidth + 8 + 16;
//    _slider.frame = CGRectMake(sliderOriginX, CGRectGetMidY(_segmentedControl.frame) - 12, self.width - sliderOriginX - 8, sliderHeight);
//
//    _toolbarCollectionView.frame = CGRectMake(8, self.height - collectionViewHeight - 8, self.width - 16, collectionViewHeight);
//}

#pragma mark - Setups

- (void)setupViews {
    self.backgroundColor = FUTheme.toolbarBackgroundColor;
    [self setupSegmentedControl];
    [self setupSlider];
    [self setupCollectionView];
    [self makeConstraints];
}

- (void)setupSegmentedControl {
    self.segmentedControl = [[FUSegmentedView alloc] init];
    [self addSubview:_segmentedControl];
}

- (void)setupSlider {
    self.slider = [[FUSliderView alloc] init];
    [self addSubview:_slider];
}

- (void)setupCollectionView {
    _toolbarCollectionView = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _toolbarCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 0);
    _toolbarCollectionView.showsVerticalScrollIndicator = NO;
    _toolbarCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_toolbarCollectionView];
}

- (void)makeConstraints {
    CGFloat segmentedControl = 32;
    CGFloat singleSegmentedWidth = 46;

    CGFloat segmentedControlWidth = singleSegmentedWidth * _segmentedControl.numberOfSegments;
    
    [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.top.equalTo(self).offset(16);
        make.width.equalTo(@(segmentedControlWidth));
        make.height.equalTo(@(segmentedControl));
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_segmentedControl.mas_centerY);
        make.centerX.equalTo(self).offset(segmentedControlWidth + 16);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(@20);
    }];
    
    [_toolbarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.trailing.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-8);
        make.height.equalTo(@50);
    }];
}

- (void)reMakeConstraints {
    CGFloat segmentedControl = 32;
    CGFloat singleSegmentedWidth = 46;

    CGFloat segmentedControlWidth = singleSegmentedWidth * _segmentedControl.numberOfSegments;
    
    [_segmentedControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.top.equalTo(self).offset(16);
        make.width.equalTo(@(segmentedControlWidth));
        make.height.equalTo(@(segmentedControl));
    }];
    
    [_slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_segmentedControl.mas_centerY);
        make.centerX.equalTo(self).offset(segmentedControlWidth * 0.5 + 8);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(@20);
    }];
}

#pragma mark - FUDrawerToolbar

- (void)setSliderValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(nonnull NSString *)displayFormat {
    if (value == 0.0 && minimumValue == 0.0 && maximumValue == 0.0) {
        _slider.hidden = YES;
    } else {
        _slider.hidden = NO;
        [_slider setValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:continuous displayFormat:displayFormat];
    }
}

- (void)showSlider:(BOOL)animated {
    _slider.hidden = NO;
}

- (void)hideSlider:(BOOL)animated {
    _slider.hidden = YES;
}

- (void)reloadData {
    [_toolbarCollectionView reloadData];
}

- (CGFloat)fullHeight {
    return 122;
}

- (CGFloat)defaultHeight {
    return 122;
}

@end
