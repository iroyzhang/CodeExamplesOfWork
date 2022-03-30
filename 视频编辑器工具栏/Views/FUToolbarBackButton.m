//
//  FUToolbarBackButton.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/8.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUToolbarBackButton.h"
#import <Masonry/Masonry.h>
#import "FUToolbarIconNames.h"

@interface FUToolbarBackButton()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FUToolbarBackButton

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

#pragma mark - Setups

- (void)setupImageView {
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:FUToolbarIconNames.back];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@30);
        make.height.equalTo(@38);
    }];
}

#pragma mark - Hit Test

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect insetRect = CGRectInset(self.bounds, -10, -6);
    if (CGRectContainsPoint(insetRect, point)) {
        return YES;
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end
