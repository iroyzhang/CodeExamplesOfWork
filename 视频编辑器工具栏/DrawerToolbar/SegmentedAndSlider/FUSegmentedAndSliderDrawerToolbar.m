//
//  FUSegmentedAndSliderDrawerToolbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/7/30.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUSegmentedAndSliderDrawerToolbar.h"
#import <Masonry/Masonry.h>
#import "UIView+Convenient.h"
#import "FUTheme.h"
#import "FUTemplateMethods.h"
#import "FUSegmentedView.h"

@implementation FUSegmentedAndSliderDrawerToolbar

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    CGFloat sliderHeight = 24;
    CGFloat segmentedControl = 32;
    CGFloat singleSegmentedWidth = 46;
    
    CGFloat segmentedControlWidth = singleSegmentedWidth * _segmentedControl.numberOfSegments;
    _segmentedControl.frame = CGRectMake(8, 16, segmentedControlWidth, segmentedControl);
    
    CGFloat sliderOriginX = segmentedControlWidth + 8 + 16;
    _slider.frame = CGRectMake(sliderOriginX, CGRectGetMidY(_segmentedControl.frame) - 12, self.width - sliderOriginX - 8, sliderHeight);
}
#pragma mark - Setup

- (void)setupViews {
    self.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
    [FUTemplateMethods addDrawerStyleShadowForView:self];
    
    [self setupSegmentedControl];
    [self setupSlider];
}

- (void)setupSegmentedControl {
    self.segmentedControl = [[FUSegmentedView alloc] init];
    [self addSubview:_segmentedControl];
}

- (void)setupSlider {
    self.slider = [[FUSliderView alloc] init];
    [self addSubview:self.slider];
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
    
}

- (CGFloat)fullHeight {
    return 74;
}

- (CGFloat)defaultHeight {
    return 74;
}

@end
