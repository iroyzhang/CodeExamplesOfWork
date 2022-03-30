//
//  FUSurfaceTrackBar.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/8/12.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUSurfaceTrackBar.h"
#import <Masonry/Masonry.h>

@implementation FUSurfaceTrackBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor colorWithRed:23/255.0 green:24/255.0 blue:32/255.0 alpha:1.0];
    [self setupButtons];
}

- (void)setupButtons {
    _reselectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reselectButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_reselectButton addTarget:self action:@selector(reselectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_reselectButton setTitle:fuStr(重选表面).fuLocalized forState:UIControlStateNormal];
    [_reselectButton setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:206/255.0 alpha:1.0] forState:UIControlStateNormal];
    _reselectButton.layer.cornerRadius = 4;
    _reselectButton.backgroundColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:117/255.0 alpha:1.0];
    [self addSubview:_reselectButton];
    [_reselectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_centerX).offset(-32);
        make.centerY.equalTo(self);
        make.width.equalTo(@110);
        make.height.equalTo(@40);
    }];
    
    _addStickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addStickerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_addStickerButton setTitleColor:[UIColor colorWithRed:219/255.0 green:221/255.0 blue:244/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_addStickerButton addTarget:self action:@selector(addStickerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_addStickerButton setTitle:fuStr(添加贴图).fuLocalized forState:UIControlStateNormal];
    _addStickerButton.backgroundColor = [UIColor colorWithRed:82/255.0 green:92/255.0 blue:255/255.0 alpha:1.0];
    _addStickerButton.layer.cornerRadius = 4;
    [self addSubview:_addStickerButton];
    [_addStickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_reselectButton.mas_trailing).offset(16);
        make.centerY.equalTo(self);
        make.width.equalTo(@160);
        make.height.equalTo(@40);
    }];
}

- (void)reselectButtonTapped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(surfaceTrackBar:reselectButtonTapped:)]) {
        [_delegate surfaceTrackBar:self reselectButtonTapped:button];
    }
}

- (void)addStickerButtonTapped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(surfaceTrackBar:addStickerButtonTapped:)]) {
        [_delegate surfaceTrackBar:self addStickerButtonTapped:button];
    }
}

@end
