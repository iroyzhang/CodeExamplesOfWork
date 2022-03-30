//
//  FUToolbarColorCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/3.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarColorCell.h"
#import "FUToolbarItem.h"
#import "FUTheme.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@implementation FUToolbarColorCell

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
    [self setupColorView];
    [self setupTitleLabel];
    [self makeConstraints];
}

- (void)setupColorView {
    _colorView = [[UIView alloc] init];
    _colorView.layer.masksToBounds = YES;
    _colorView.layer.cornerRadius = 2.0;
    _colorView.layer.borderColor = [UIColor colorWithHexColorString:fuStr(E6E8FF)].CGColor;
    _colorView.layer.borderWidth = 2.f;
    [self addSubview:_colorView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FUTheme.toolbarItemTitleFont;
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    [self.contentView addSubview:_titleLabel];
}

- (void)makeConstraints {
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@24);
        make.bottom.equalTo(_titleLabel.mas_top).offset(-2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
}

#pragma mark - Prepare

- (void)prepareForReuse {
    _titleLabel.textColor = FUTheme.toolbarTitleColor;
    _colorView.backgroundColor = UIColor.whiteColor;
}

#pragma mark - FUToolbarCell

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    _titleLabel.text = item.title;
    if ([item.value isKindOfClass:[UIColor class]]) {
        _colorView.backgroundColor = (UIColor *)(item.value);
    }
    if (item.isHighlighted) {
        _titleLabel.textColor = FUTheme.toolbarHighlightColor;
    }
}

@end
