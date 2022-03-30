//
//  FUHueAdjustDrawerToolbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/4/7.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import "FUHueAdjustDrawerToolbar.h"
#import "FUHueAdjustSliderView.h"
#import <Masonry/Masonry.h>
#import "FUTheme.h"
#import "FUToolbarCollectionView.h"
#import "FUGradientSliderView.h"

@interface FUHueAdjustDrawerToolbar() <FUSliderViewDelegate>
@property (nonatomic) FUHueAdjustSliderView *hueSlider;
@property (nonatomic) FUHueAdjustSliderView *saturationSlider;
@property (nonatomic) FUHueAdjustSliderView *lightnessSlider;
@property (nonatomic) FUHueAdjustSliderView *scopeSlider;
@end

@implementation FUHueAdjustDrawerToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
    [self setupSliders];
    [self setupCollectionView];
    [self setupConstraints];
}

- (void)setupSliders {
    _hueSlider = [[FUHueAdjustSliderView alloc] init];
    _hueSlider.slider.delgate = self;
    _hueSlider.titleLabel.text = @"色调".fuLocalized;
    _hueSlider.valueLabel.text = @"0º";
    [self addSubview:_hueSlider];
    
    _saturationSlider = [[FUHueAdjustSliderView alloc] init];
    _saturationSlider.slider.delgate = self;
    _saturationSlider.titleLabel.text = @"饱和度".fuLocalized;
    _saturationSlider.valueLabel.text = @"0";
    [self addSubview:_saturationSlider];
    
    _lightnessSlider = [[FUHueAdjustSliderView alloc] init];
    _lightnessSlider.slider.delgate = self;
    _lightnessSlider.titleLabel.text = @"亮度".fuLocalized;
    _lightnessSlider.valueLabel.text = @"0";
    [self addSubview:_lightnessSlider];
    
    _scopeSlider = [[FUHueAdjustSliderView alloc] initWithFrame:CGRectZero isGradientSliderView:NO];
    _scopeSlider.slider.delgate = self;
    _scopeSlider.titleLabel.text = @"取色范围".fuLocalized;
    _scopeSlider.valueLabel.text = @"0";
    [self addSubview:_scopeSlider];
}

- (void)setupCollectionView {
    _collectionView = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 0);
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
}

- (void)setupConstraints {
    [_hueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self).offset(16);
        make.height.equalTo(@20);
    }];
    
    [_saturationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_hueSlider.mas_bottom).offset(16);
        make.height.equalTo(@20);
    }];
    
    [_lightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_saturationSlider.mas_bottom).offset(16);
        make.height.equalTo(@20);
    }];
    
    [_scopeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(_lightnessSlider.mas_bottom).offset(16);
        make.height.equalTo(@20);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@38);
        make.bottom.equalTo(self).offset(-16);
    }];
}

- (void)sliderValueChanged:(float)value forType:(FUHueAdjustSliderType)type isFinished:(BOOL)isFinished {
    
}

- (void)setSliderValue:(float)value minValue:(float)minValue maxValue:(float)maxValue forType:(FUHueAdjustSliderType)type {
    switch (type) {
        case FUHueAdjustSliderTypeHue:
            [_hueSlider.slider setValue:value minimumValue:minValue maximumValue:maxValue continuous:YES];
            _hueSlider.valueLabel.text = [NSString stringWithFormat:@"%.0fº", value];
            break;
        case FUHueAdjustSliderTypeSaturation:
            [_saturationSlider.slider setValue:value minimumValue:minValue maximumValue:maxValue continuous:YES];
            _saturationSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", value];
            break;
        case FUHueAdjustSliderTypeLightness:
            [_lightnessSlider.slider setValue:value minimumValue:minValue maximumValue:maxValue continuous:YES];
            _lightnessSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", value];
            break;
        case FUHueAdjustSliderTypeScope:
            [_scopeSlider.slider setValue:value minimumValue:minValue maximumValue:maxValue continuous:YES];
            _scopeSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", value];
            break;
    }
}

- (void)updateGradientWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations forType:(FUHueAdjustSliderType)type {
    switch (type) {
        case FUHueAdjustSliderTypeHue:
            [_hueSlider updateGradientWithColors:colors locations:locations];
            break;
        case FUHueAdjustSliderTypeSaturation:
            [_saturationSlider updateGradientWithColors:colors locations:locations];
            break;
        case FUHueAdjustSliderTypeLightness:
            [_lightnessSlider updateGradientWithColors:colors locations:locations];
            break;
        case FUHueAdjustSliderTypeScope:
            [_scopeSlider updateGradientWithColors:colors locations:locations];
            break;
    }
}

#pragma mark - FUDrawerToolbar

- (void)reloadData {
    [_collectionView reloadData];
}

- (CGFloat)defaultHeight {
    return 214;
}

#pragma mark - FUSliderViewDelegate

- (void)sliderView:(FUSliderView *)sliderView valueChanged:(float)value isFinished:(BOOL)finished {
    FUHueAdjustSliderType type;
    if (sliderView == _hueSlider.slider) {
        type = FUHueAdjustSliderTypeHue;
    } else if (sliderView == _saturationSlider.slider) {
        type = FUHueAdjustSliderTypeSaturation;
    } else if (sliderView == _lightnessSlider.slider) {
        type = FUHueAdjustSliderTypeLightness;
    } else {
        type = FUHueAdjustSliderTypeScope;
    }
    
    [self sliderValueChanged:value forType:type isFinished:finished];
}

@end
