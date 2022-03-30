//
//  FUToolbarGifCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/12/17.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarGifCell.h"
#import "FUToolbarItem.h"
#import <Masonry/Masonry.h>
#import "FUTheme.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface FUToolbarGifCell()
@property (nonatomic, strong) UIView *bottomContainerView;
@end

@implementation FUToolbarGifCell

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
    self.contentView.layer.cornerRadius = 6.0;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.29 alpha:1.00];
    [self setupThumbnailImageView];
    [self setupBottomContainerView];
    [self setupTitleLabel];
    [self setupCoverView];
    [self setupValueLabel];
}

- (void)setupThumbnailImageView {
    _imageView = [[FLAnimatedImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@34);
    }];
}

- (void)setupBottomContainerView {
    _bottomContainerView = [[UIView alloc] init];
    _bottomContainerView.backgroundColor = nil;
    [self.contentView addSubview:_bottomContainerView];
    [_bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FUTheme.toolbarItemTitleFont;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomContainerView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bottomContainerView);
        make.left.right.equalTo(_bottomContainerView);
    }];
}

- (void)setupCoverView {
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor colorWithRed:0.49 green:0.58 blue:1.0 alpha:0.5];
    _coverView.hidden = YES;
    [self.contentView addSubview:_coverView];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_imageView);
    }];
}

- (void)setupValueLabel {
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.font = FUTheme.toolbarItemValueFont;
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_imageView);
        make.left.right.equalTo(self);
    }];
}

#pragma mark - FUToolbarCell

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:item.imageName withExtension:@"gif"];
    NSData *gifData = [[NSData alloc] initWithContentsOfURL:gifURL];
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    _imageView.animatedImage = animatedImage;
    
    _titleLabel.text = item.title;
    if (item.highlighted) {
        _coverView.hidden = NO;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.42 green:0.49 blue:1.0 alpha:1];
        if (item.isAdjustable && item.sliderValue) {
            _valueLabel.text = [NSString stringWithFormat:fuStr(%ld), (long)item.sliderValue.integerValue];
        }
    } else {
        _coverView.hidden = YES;
        _valueLabel.text = @"";
        self.contentView.backgroundColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.29 alpha:1.00];
    }
}

@end
