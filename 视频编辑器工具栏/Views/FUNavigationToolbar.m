//
//  FUNavigationToolbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/6.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUNavigationToolbar.h"
#import "FUTheme.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@implementation FUNavigationToolbar

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark - Setups

- (void)setupView {
    self.backgroundColor = FUTheme.toolbarBackgroundColor;
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,-0.5);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 0;
    [self setupCloseButton];
    [self setupTitleLabel];
    [self setupNextButton];
    [self makeConstraints];
}

- (void)setupCloseButton {
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setImage:[UIImage imageNamed:fuStr(navigation_icon_close)] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:206/255.0 alpha:1.0];
    [self addSubview:_titleLabel];
}

- (void)setupNextButton {
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    _nextButton.layer.cornerRadius = 4;
    _nextButton.layer.backgroundColor = [UIColor colorWithHexColorString:@"525EFF"].CGColor;
    [_nextButton setTitle:@"下一步".fuLocalized forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextButton];
}


- (void)makeConstraints {
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(44));
        make.leading.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@(64));
        make.height.equalTo(@(32));
        make.trailing.equalTo(self).offset(-8);
    }];
}

#pragma mark - Actions

- (void)closeButtonTapped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(navigationToolbarViewDidTappedCloseButton:)]) {
        [_delegate navigationToolbarViewDidTappedCloseButton:self];
    }
}

- (void)nextButtonTapped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(navigationToolbarViewDidTappedNextButton:)]) {
        [_delegate navigationToolbarViewDidTappedNextButton:self];
    }
}

@end
