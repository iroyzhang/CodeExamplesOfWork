//
//  FUDrawerToolbarCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/18.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarSquareNormalCell.h"
#import "FUToolbarItem.h"
#import "FUTheme.h"
#import <Masonry/Masonry.h>
#import "FUToolbarIconNames.h"
#import "UIColor+Hex.h"

@implementation FUToolbarSquareNormalCell

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
    _titleLabel.text = nil;
    _valueLabel.text = nil;
    _iconImageView.image = nil;
    self.contentView.backgroundColor= [UIColor colorWithHexColorString:fuStr(383A4A)];;
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    _valueLabel.textColor = FUTheme.toolbarValueColor;
}

#pragma mark - Setups

- (void)setupViews {
    self.contentView.layer.cornerRadius = 6.0;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor colorWithHexColorString:fuStr(383A4A)];;
    [self setupTitleLabel];
    [self setupValueLabel];
    [self setupIconImageView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FUTheme.toolbarItemTitleFont;
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    [self addSubview:_titleLabel];
}

- (void)setupValueLabel {
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.font = FUTheme.toolbarItemValueFont;
    _valueLabel.textColor = FUTheme.toolbarValueColor;
    _valueLabel.adjustsFontSizeToFitWidth = YES;
    _valueLabel.minimumScaleFactor = 0.8;
    [self.contentView addSubview:_valueLabel];
}

- (void)setupIconImageView {
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
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
        make.bottom.equalTo(_titleLabel.mas_top).offset(-6);
        make.left.right.equalTo(self.contentView);
    }];
}

#pragma mark - Configrations

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    self.hidden = item.hidden;
    self.userInteractionEnabled = !item.disabled;
    _titleLabel.text = item.title;
    if (item.iconName && ![item.iconName isEqualToString:@""]) {
        _iconImageView.hidden = NO;
        _iconImageView.alpha = 1.0;
        _valueLabel.hidden = YES;
        NSString *iconName = item.iconName;
        if (item.highlighted) {
            iconName = [FUToolbarIconNames selectedNameWithIconName:iconName];
        }
        _iconImageView.image = [UIImage imageNamed:iconName];
    } else {
        _iconImageView.image = nil;
        _iconImageView.hidden = YES;
        _valueLabel.hidden = NO;
        if (item.isAdjustable) {
            if (item.displayFormat) {
                _valueLabel.text = [NSString stringWithFormat:item.displayFormat, (long)item.sliderValue.integerValue];
            } else {
                _valueLabel.text = [NSString stringWithFormat:fuStr(%ld), (long)item.sliderValue.integerValue];
            }
        } else if (item.isArrangeable) {
            _valueLabel.text = [NSString stringWithFormat:fuStr(%@), item.value];
        }
    }
    
    if (item.disabled) {
        self.contentView.backgroundColor= [UIColor colorWithHexColorString:fuStr(383A4A)];;
        _titleLabel.textColor = FUTheme.toolbarDisableColor;
        _valueLabel.textColor = FUTheme.toolbarDisableColor;
        _iconImageView.alpha = 0.3;
    } else if (item.highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.42 green:0.49 blue:1.0 alpha:1];
        _titleLabel.textColor = UIColor.whiteColor;
        _valueLabel.textColor = UIColor.whiteColor;
        _iconImageView.alpha = 1.0;
    } else {
        self.contentView.backgroundColor= [UIColor colorWithHexColorString:fuStr(383A4A)];;
        _titleLabel.textColor = FUTheme.toolbarTitleColor;
        _valueLabel.textColor = FUTheme.toolbarValueColor;
        _iconImageView.alpha = 1.0;
    }
}

@end
