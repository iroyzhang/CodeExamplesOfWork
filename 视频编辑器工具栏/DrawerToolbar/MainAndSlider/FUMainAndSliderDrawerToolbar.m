//
//  FUMainAndSliderDrawerToolbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUMainAndSliderDrawerToolbar.h"
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

@interface FUMainAndSliderDrawerToolbar()
@property (nonatomic, strong) UIView *sliderContainer;
@property (nonatomic, strong) UIView *collectionViewContainer;
@end

@implementation FUMainAndSliderDrawerToolbar

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSliderHidden = YES;
        [self setupViews];
    }
    return self;
}

#pragma mark - Layout

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self updateViewsFrame];
//}
//
//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    [self updateViewsFrame];
//}
//
//- (void)updateViewsFrame {
//    _collectionViewContainer.frame = CGRectMake(0, self.height - self.defaultHeight, self.width, self.defaultHeight);
//    _toolbarCollectionView.frame = CGRectMake(0, CGRectGetMidY(_collectionViewContainer.bounds) - FUToolbarHeight / 2.0, _collectionViewContainer.width, FUToolbarHeight);
//    CGFloat sliderMargin = 16;
//    CGFloat sliderHeight = 24;
//    _slider.frame = CGRectMake(sliderMargin, CGRectGetMidY(_sliderContainer.bounds) - sliderHeight / 2, self.width - sliderMargin * 2.0, 24);
//}

#pragma mark - Setups

- (void)setupViews {
    [self setupContainers];
    [self setupCollectionViewAndSlider];
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
    [_sliderContainer addSubview:_slider];
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
    
    CGFloat sliderHeight = 24;
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_sliderContainer).offset(48);
        make.trailing.equalTo(_sliderContainer).offset(-48);
        make.centerY.equalTo(_sliderContainer);
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
    if (!self.isSliderHidden) { return; }
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
        } completion:^(BOOL finished) {
            self.isSliderHidden = NO;
        }];
    } else {
        self.sliderContainer.originY = _collectionViewContainer.originY - sliderHeight;
    }
}

- (void)hideSlider:(BOOL)animated {
    if (self.isSliderHidden) { return; }
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
            self.isSliderHidden = YES;
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

@end
