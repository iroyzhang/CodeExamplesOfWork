//
//  FUSliderToolDrawerbar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/9.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUSliderToolDrawerbar.h"
#import "FUSliderView.h"
#import <Masonry/Masonry.h>
#import "FUSliderViewModel.h"
#import "FUValueFormatter.h"
#import "FUTheme.h"
#import "FUTemplateMethods.h"
#import "FUSliderView.h"
#import "UIView+Convenient.h"

@implementation FUSliderToolDrawerbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
//    _slider.frame = CGRectMake(16, CGRectGetMidY(self.bounds) - 12, self.width - 32, 24);
//}

#pragma mark - Setups

- (void)setupViews {
    self.backgroundColor = FUTheme.drawerToolbarBackgroundColor;
    [FUTemplateMethods addDrawerStyleShadowForView:self];
    _slider = [[FUSliderView alloc] init];
    [self addSubview:_slider];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(48);
        make.trailing.equalTo(self).offset(-48);
        make.height.equalTo(@24);
        make.center.equalTo(self);
    }];
}

#pragma mark - FUDrawerToolbar

- (void)reloadData { }

- (void)setSliderValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(nonnull NSString *)displayFormat {
    [self.slider setValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:continuous displayFormat:displayFormat];
}

- (CGFloat)defaultHeight {
    return 62.0;
}

- (CGFloat)fullHeight {
    return 62.0;
}

@end
