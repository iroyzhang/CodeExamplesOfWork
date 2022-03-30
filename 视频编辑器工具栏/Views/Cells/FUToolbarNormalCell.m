//
//  FUToolbarNormalCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarNormalCell.h"
#import "FUToolbarItem.h"
#import "FUTheme.h"
#import <Masonry/Masonry.h>
#import "FUToolbarIconNames.h"

@implementation FUToolbarNormalCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Prepare

- (void)prepareForReuse {
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    _valueLabel.textColor = FUTheme.toolbarValueColor;
    _iconImageView.image = nil;
    _cornerImageView.image = nil;
}

#pragma mark - Setups

- (void)setupViews {
    [self setupTitleLabel];
    [self setupValueLabel];
    [self setupIconImageView];
    [self setupCornerImageView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FUTheme.toolbarItemTitleFont;
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 0.6;
    [self addSubview:_titleLabel];
}

- (void)setupValueLabel {
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.font = FUTheme.toolbarItemValueFont;
    _valueLabel.textColor = FUTheme.toolbarValueColor;
    [self.contentView addSubview:_valueLabel];
}

- (void)setupIconImageView {
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
}

- (void)setupCornerImageView {
    _cornerImageView = [[UIImageView alloc] init];
//    _cornerImageView.backgroundColor = UIColor.redColor;
    [self.contentView addSubview:_cornerImageView];
}

- (void)setupConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@24);
        make.bottom.equalTo(_titleLabel.mas_top).offset(-2);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(_titleLabel.mas_top).offset(-2);
        make.left.right.equalTo(self.contentView);
    }];
    
    [_cornerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).with.offset(-8);
        make.width.equalTo(@20);
        make.height.equalTo(@12);
        make.bottom.equalTo(_iconImageView.mas_top).offset(8);
    }];
}

#pragma mark - FUToolbarCell

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    self.hidden = item.hidden;
    self.userInteractionEnabled = !item.disabled;
    _titleLabel.text = item.title;
    _valueLabel.hidden = (item.isAdjustable == NO && item.value == nil);
    _iconImageView.hidden = item.isAdjustable;
    if (item.isAdjustable) {
        _valueLabel.text = [NSString stringWithFormat:fuStr(%ld), (long)item.sliderValue.integerValue];
    } else {
        _valueLabel.text = [NSString stringWithFormat:fuStr(%@), item.value];
    }
    if (item.iconName && ![item.iconName isEqualToString:@""]) {
        NSString *iconName = item.iconName;
        if (item.isHighlighted) {
            iconName = [FUToolbarIconNames selectedNameWithIconName:iconName];
        }
        
        _iconImageView.image = [UIImage imageNamed:iconName];
        _valueLabel.text = nil;
    } else {
        _iconImageView.image = nil;
    }
    
    if (item.cornerName && ![item.cornerName isEqualToString:@""]) {
        NSString *cornerName = item.cornerName;
        _cornerImageView.image = [UIImage imageNamed:cornerName];
    } else {
        _cornerImageView.image = nil;
    }
    
    if (item.disabled) {
        _titleLabel.textColor = FUTheme.toolbarDisableColor;
        _valueLabel.textColor = FUTheme.toolbarDisableColor;
    } else if (item.highlighted) {
        _titleLabel.textColor = FUTheme.toolbarHighlightColor;
        _valueLabel.textColor = FUTheme.toolbarHighlightColor;
    }
}

@end
