//
//  GDVTTimelineDurationSelectionHandlerView.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineDurationSelectionHandlerView.h"

@interface GDVTTimelineDurationSelectionHandlerView()

@property (nonatomic, strong) CALayer *iconLayer;

@end

@implementation GDVTTimelineDurationSelectionHandlerView

// MARK: - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _iconColor = UIColor.whiteColor;
        _iconSize = CGSizeMake(2, 16);
        [self setupIconLayer];
    }
    return self;
}

// MARK: - Override

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect hotAreaRect = UIEdgeInsetsInsetRect(self.bounds, _hotAreaInsets);
    return CGRectContainsPoint(hotAreaRect, point);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    
    if (self.layer != layer) { return; }
    _iconLayer.cornerRadius = _iconSize.width / 2.0;
    _iconLayer.frame = [self iconLayerFrameWithSize:_iconSize];
}

// MARK: - Private Setup

- (void)setupIconLayer {
    _iconLayer = [CALayer layer];
    _iconLayer.backgroundColor = _iconColor.CGColor;
    [self.layer addSublayer:_iconLayer];
}

// MARK: - Private

- (CGRect)iconLayerFrameWithSize:(CGSize)size {
    CGPoint origin = CGPointMake(CGRectGetMidX(self.layer.bounds) - size.width / 2.0, CGRectGetMidY(self.layer.bounds) - size.height / 2.0);
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

// MARK: - Custom Accessors

- (void)setIconSize:(CGSize)iconSize {
    if (CGSizeEqualToSize(_iconSize, iconSize)) { return; }
    _iconSize = iconSize;
    [self.layer setNeedsLayout];
}

- (void)setIconColor:(UIColor *)iconColor {
    if ([_iconColor isEqual:iconColor]) { return; }
    _iconColor = iconColor;
    _iconLayer.backgroundColor = iconColor.CGColor;
}

@end
