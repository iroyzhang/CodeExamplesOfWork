//
//  FUGradientSliderView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2021/4/12.
//  Copyright © 2021 Faceunity. All rights reserved.
//

#import "FUGradientSliderView.h"

@interface FUGradientSliderView()
@property (nonatomic) CAGradientLayer *gradientLayer;
@end

@implementation FUGradientSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.filledColor = [UIColor colorWithWhite:1 alpha:0.4];
        [self setupGradientLayer];
    }
    return self;
}

- (void)setupGradientLayer {
    self.gradientView.hidden = NO;
    _gradientLayer = [CAGradientLayer layer];
    
    _gradientLayer.frame = self.gradientView.bounds;
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(1, 0);
    [self.gradientView.layer addSublayer:_gradientLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.gradientView.bounds;
}

- (void)setGradientColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations {
    NSMutableArray *cgColors = [NSMutableArray new];
    
    for (UIColor *color in colors) {
        UIColor *cgColor = (__bridge id)color.CGColor;
        [cgColors addObject:cgColor];
    }
    
    
    _gradientLayer.locations = locations;
    _gradientLayer.colors = [cgColors copy];
}

@end
