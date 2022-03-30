//
//  FUMainAndSliderAndButtonDrawerToolbar.m
//  FUVideoEditor
//
//  Created by Lechech on 2021/6/22.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import "FUMainAndSliderAndButtonDrawerToolbar.h"
#import "FUToolbarCollectionViewLayout.h"
#import "FUToolbarCollectionView.h"
#import "TransformConstants.h"
#import "FUToolbarFilterCell.h"
#import "FUSliderViewModel.h"
#import "FUValueFormatter.h"
#import "FUTheme.h"
#import "FUTemplateMethods.h"
#import "FUSliderView.h"
#import "UIView+Convenient.h"
#import <Masonry.h>
#import "FUSpeedKeyFrameButton.h"

@interface FUMainAndSliderAndButtonDrawerToolbar()
@property (nonatomic, strong) UIView *sliderContainer;
@property (nonatomic, strong) UIView *collectionViewContainer;
@end

@implementation FUMainAndSliderAndButtonDrawerToolbar

#pragma mark - Init

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
    [self setupContainers];
    [self setupCollectionViewAndSlider];
    [self setupButtons];
    [self makeContraints];
}

- (void)setupContainers {
    _collectionViewContainer = [[UIView alloc] init];
    _collectionViewContainer.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
    [FUTemplateMethods addDrawerStyleShadowForView:_collectionViewContainer];
    [self addSubview:_collectionViewContainer];
    
    _sliderContainer = [[UIView alloc] init];
    _sliderContainer.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
    _sliderContainer.hidden = YES;
    [self addSubview:_sliderContainer];
    
    [self bringSubviewToFront:_collectionViewContainer];
}

- (void)setupCollectionViewAndSlider {
    _toolbarCollectionView = [FUToolbarCollectionView toolbarCollectionViewWithFrame:CGRectZero];
    _toolbarCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 0);
    _toolbarCollectionView.showsVerticalScrollIndicator = NO;
    _toolbarCollectionView.showsHorizontalScrollIndicator = NO;
    [_collectionViewContainer addSubview:_toolbarCollectionView];
    
    self.slider = [[FUSliderView alloc] init];
    self.slider.handlerSize = CGSizeMake(14.0, 14.0);
    self.slider.isShowDegreeScaleLabel = YES;
    [_sliderContainer addSubview:_slider];
}

- (void)setupButtons {
    _keyFrameButton = [[FUSpeedKeyFrameButton alloc] init];
    [self addSubview:_keyFrameButton];
    
    _resetButton = [[UIButton alloc] init];
    _resetButton.backgroundColor = FUTheme.stateBarControlBackgroundColor;
    _resetButton.layer.cornerRadius = 13.0;
    _resetButton.layer.masksToBounds = YES;
    _resetButton.titleLabel.font = FUTheme.toolbarItemTitleFont;
    [_resetButton setTitleColor:[UIColor colorWithRed:218/255.0 green:219/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_resetButton setTitle:@"重置".fuLocalized forState:UIControlStateNormal];
    [self addSubview:_resetButton];
}

- (void)makeContraints{
    [_collectionViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@(self.defaultHeight));
    }];
    
    [_toolbarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_collectionViewContainer);
        make.height.equalTo(@(FUToolbarHeight));
        make.top.equalTo(_collectionViewContainer.mas_centerY).offset(-FUToolbarHeight / 2.0);
    }];
    
    CGFloat buttonWidth = 42;
    CGFloat buttonHeight = 26;
    [_keyFrameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.centerY.equalTo(_sliderContainer);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-8);
        make.centerY.equalTo(_sliderContainer);
        make.width.equalTo(@(buttonWidth));
        make.height.equalTo(@(buttonHeight));
    }];
    
    CGFloat sliderHeight = 24;
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_keyFrameButton.mas_trailing).offset(14);
        make.trailing.equalTo(_resetButton.mas_leading).offset(-14);
        make.centerY.equalTo(_sliderContainer).offset(-6);
        make.centerX.equalTo(_sliderContainer);
        make.height.equalTo(@(sliderHeight));
    }];
}

#pragma mark - Hit

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}

#pragma mark - FUToolDrawerbar

- (void)showSlider:(BOOL)animated {
    [FUTemplateMethods removeDrawerStyleShadowForView:_collectionViewContainer];
    [FUTemplateMethods addDrawerStyleShadowForView:_sliderContainer];
    
    CGFloat sliderHeight = self.fullHeight - self.defaultHeight;
    _sliderContainer.hidden = NO;
    
    [_sliderContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@(sliderHeight));
        make.top.equalTo(_collectionViewContainer);
    }];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.sliderContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.trailing.equalTo(self);
                
                make.height.equalTo(@(sliderHeight));
            }];
        }];
    } else {
        self.sliderContainer.originY = _collectionViewContainer.originY - sliderHeight;
    }
}

- (void)hideSlider:(BOOL)animated {
    [FUTemplateMethods removeDrawerStyleShadowForView:_sliderContainer];
    [FUTemplateMethods addDrawerStyleShadowForView:_collectionViewContainer];
    
    CGFloat sliderHeight = self.fullHeight - self.defaultHeight;
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.sliderContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                make.height.equalTo(@(sliderHeight));
                make.top.equalTo(self.collectionViewContainer);
            }];
            [self setNeedsLayout];
        } completion:^(BOOL finished) {
            self.sliderContainer.hidden = YES;
        }];
    } else {
        self.sliderContainer.originY = _collectionViewContainer.originY + sliderHeight;
    }
}

- (CGFloat)defaultHeight {
    return 80;
}

- (CGFloat)fullHeight {
    return 120;
}

- (void)setSliderValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(nonnull NSString *)displayFormat {
    [self.slider setValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:continuous displayFormat:displayFormat];
}

- (void)reloadData {
    [self.toolbarCollectionView reloadData];
}

- (void)isHideSliderButton:(BOOL)isHide {
    self.keyFrameButton.hidden = isHide;
    self.resetButton.hidden = isHide;
}

@end
