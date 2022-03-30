//
//  FUToolbarColorPaletteCell.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/22.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarColorPaletteCell.h"
#import <Masonry/Masonry.h>
#import "FUToolbarItem.h"
#import "UIColor+Hex.h"
#import "FUToneGradientColorsTool.h"
#import "FUToneGradientColorInfo.h"

@interface FUToolbarColorPaletteCell()
@property (nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation FUToolbarColorPaletteCell

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
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.cornerRadius = 4;
    _gradientLayer.frame = CGRectMake(0, 0, 24, 36);
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    _gradientLayer.locations = @[@0.0, @0.5, @1.0];
    [self.contentView.layer addSublayer:_gradientLayer];
    
    _colorView = [[UIImageView alloc] init];
    _colorView.layer.cornerRadius = 4.0;
    [self.contentView addSubview:_colorView];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@36);
        make.center.equalTo(self.contentView);
    }];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint origin = CGPointMake((CGRectGetWidth(self.contentView.bounds) - 24) / 2.0, (CGRectGetHeight(self.bounds) - 36) / 2.0);
    _gradientLayer.frame = CGRectMake(origin.x, origin.y, 24, 36);
}

#pragma mark - Prepare

- (void)prepareForReuse {
    [super prepareForReuse];
    _colorView.image = nil;
    _colorView.backgroundColor = nil;
    _colorView.layer.borderColor = nil;
    _colorView.layer.borderWidth = 0.0;
    _gradientLayer.colors = nil;
}

#pragma mark - Update

- (void)updateGradientLayerWithToneGradientColorName:(NSString *)toneGradientColorName scope:(CGFloat)scope {
    NSArray *colors = [FUToneGradientColorsTool getColorsWithToneGradientColorName:toneGradientColorName scope:scope / 2];
    NSMutableArray *cgColors = [NSMutableArray new];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    _gradientLayer.colors = cgColors.copy;
    [CATransaction commit];
}

#pragma mark - FUToolbarCell

- (void)configureWithToolbarItem:(FUToolbarItem *)item {
    if (item.iconName) {
        self.colorView.image = [UIImage imageNamed:item.iconName];
    } else if (item.toneGradientColorName) {
        [self updateGradientLayerWithToneGradientColorName:item.toneGradientColorName scope:item.toneGradientColorScope];
    } else if ([item.value isKindOfClass:[UIColor class]]) {
        UIColor *color = (UIColor *)item.value;
        self.colorView.backgroundColor = color;
    }
    if (item.highlighted) {
        UIColor *highlightedColor = [UIColor colorWithHexColorString:fuStr(E6E8FF)];
        _colorView.layer.borderColor = highlightedColor.CGColor;
        _colorView.layer.borderWidth = 2.0;
    }
}

@end
