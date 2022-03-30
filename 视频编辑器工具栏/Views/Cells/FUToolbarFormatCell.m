//
//  FUToolbarFormatCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/29.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarFormatCell.h"
#import "FUTheme.h"
#import <Masonry/Masonry.h>
#import "FUToolbarItem.h"
#import "FUToolbarIconNames.h"

@implementation FUToolbarFormatCell

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
    _iconImageView.image = nil;
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
}

#pragma mark - Setups

- (void)setupViews {
    self.contentView.backgroundColor = UIColor.clearColor;
    [self setupTitleLabel];
    [self setupIconImageView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FUTheme.toolbarItemTitleFont;
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    [self addSubview:_titleLabel];
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
}

#pragma mark - Configrations

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    self.hidden = item.hidden;
    self.userInteractionEnabled = !item.disabled;
    _titleLabel.text = item.title;
    _iconImageView.hidden = item.isAdjustable;
    if (item.iconName && ![item.iconName isEqualToString:@""]) {
        NSString *iconName = item.iconName;
        if (item.isHighlighted) {
            iconName = [FUToolbarIconNames selectedNameWithIconName:iconName];
        }
        _iconImageView.image = [UIImage imageNamed:iconName];
    } else {
        _iconImageView.image = nil;
    }
    
    if (item.highlighted) {
        _titleLabel.textColor = FUTheme.toolbarHighlightColor;
    } else {
        _titleLabel.textColor = FUTheme.toolbarTitleColor;
    }
}

@end
