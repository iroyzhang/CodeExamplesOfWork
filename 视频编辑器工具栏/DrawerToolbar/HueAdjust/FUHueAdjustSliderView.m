//
//  FUHueAdjustSliderView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/4/8.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import "FUHueAdjustSliderView.h"
#import "FUGradientSliderView.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface FUHueAdjustSliderView()
@property (nonatomic) BOOL isGradientSliderView;
@end

@implementation FUHueAdjustSliderView

- (instancetype)initWithFrame:(CGRect)frame isGradientSliderView:(BOOL)isGradientSliderView {
    self = [super initWithFrame:frame];
    if (self) {
        _isGradientSliderView = isGradientSliderView;
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero isGradientSliderView:YES];
}

- (void)setup {
    [self setupLabels];
    [self setupSlider];
    [self setupConstraints];
}

- (void)setupLabels {
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor colorWithHexColorString:@"9A9DB8"];
    _titleLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_titleLabel];
    
    _valueLabel = [UILabel new];
    _valueLabel.font = [UIFont systemFontOfSize:11];
    _valueLabel.textColor = [UIColor colorWithHexColorString:@"9A9DB8"];
    [self addSubview:_valueLabel];
}

- (void)setupSlider {
    if (_isGradientSliderView) {
        _slider = [[FUGradientSliderView alloc] init];
    } else {
        _slider = [[FUSliderView alloc] init];
    }
    _slider.handlerSize = CGSizeMake(14, 14);
    [self addSubview:_slider];
}

- (void)setupConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(16);
        make.centerY.equalTo(self);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(88);
        make.trailing.equalTo(self).offset(-79);
        make.centerY.equalTo(self);
        make.height.equalTo(@20);
    }];
}

- (void)updateGradientWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations {
    if (![_slider isMemberOfClass:[FUGradientSliderView class]]) { return; }
    FUGradientSliderView *gradientSliderView = (FUGradientSliderView *)_slider;
    [gradientSliderView setGradientColors:colors locations:locations];
}

@end
