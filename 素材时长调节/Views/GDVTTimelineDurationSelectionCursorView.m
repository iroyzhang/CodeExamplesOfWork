//
//  GDVTTimelineDurationSelectionCursorView.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineDurationSelectionCursorView.h"

@interface GDVTTimelineDurationSelectionCursorView()

/// 游标背景图层
@property (nonatomic, strong) CALayer *cursorBackgroundLayer;

/// 游标图标图层
@property (nonatomic, strong) CAReplicatorLayer *cursorIconLayer;

/// 连接线图层
@property (nonatomic, strong) CALayer *jointLineLayer;

@end

@implementation GDVTTimelineDurationSelectionCursorView

// MARK: - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                   cursorSize:(CGSize)cursorSize
                jointLineSize:(CGSize)jointLineSize
             jointLineSpacing:(CGFloat)jointLineSpacing {
    self = [super initWithFrame:frame];
    if (self) {
        _cursorSize = cursorSize;
        _jointLineSize = jointLineSize;
        _jointLineSpacing = jointLineSpacing;
        _cursorColor = UIColor.yellowColor;
        _jointLineColor = UIColor.yellowColor;
        [self setupLayers];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame cursorSize:CGSizeMake(32, 26) jointLineSize:CGSizeMake(2, 12) jointLineSpacing:2];
}

// MARK: - Override

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (![layer isEqual:self.layer]) { return; }
    
    CGRect cursorBackgroundLayerRect = CGRectMake(0, 0, _cursorSize.width, _cursorSize.height);
    CGRect jointLineLayerRect = CGRectMake(CGRectGetMidX(cursorBackgroundLayerRect) - _jointLineSize.width / 2.0, CGRectGetMaxY(cursorBackgroundLayerRect) + _jointLineSpacing, _jointLineSize.width, _jointLineSize.height);
    CGRect cursorIconLayerRect = CGRectInset(cursorBackgroundLayerRect, 2.0, 2.0);
    
    _cursorBackgroundLayer.frame = cursorBackgroundLayerRect;
    _jointLineLayer.frame = jointLineLayerRect;
    _cursorIconLayer.frame = cursorIconLayerRect;
    
    [self updateIconLayer];
}

// MARK: - Private Setup

- (void)setupLayers {
    [self setupCursorBackgroundLayer];
    [self setupIconLayer];
    [self setupJointLineLayer];
}

- (void)setupCursorBackgroundLayer {
    _cursorBackgroundLayer = [CALayer layer];
    _cursorBackgroundLayer.cornerRadius = 6.0;
    _cursorBackgroundLayer.backgroundColor = _cursorColor.CGColor;
    [self.layer addSublayer:_cursorBackgroundLayer];
}

- (void)setupIconLayer {
    _cursorIconLayer = [CAReplicatorLayer layer];
    _cursorIconLayer.cornerRadius = 6.0;
    [self.layer addSublayer:_cursorIconLayer];
}

- (void)setupJointLineLayer {
    _jointLineLayer = [CALayer layer];
    _jointLineLayer.backgroundColor = _jointLineColor.CGColor;
    _jointLineLayer.cornerRadius = _jointLineSize.width / 2.0;
    [self.layer addSublayer:_jointLineLayer];
}

- (void)updateIconLayer {
    [self.cursorIconLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat offset = 6.0;
    CGSize rectangleLayerSize = CGSizeMake(2, 8);
    CGFloat rectangleStartOriginX = CGRectGetMidX(self.cursorIconLayer.bounds) - rectangleLayerSize.width / 2.0 - offset;
    CGFloat rectangleOriginY = CGRectGetMidY(self.cursorIconLayer.bounds) - rectangleLayerSize.height / 2.0;
    
    CALayer *rectangleLayer = [CALayer layer];
    rectangleLayer.backgroundColor = UIColor.whiteColor.CGColor;
    rectangleLayer.frame = CGRectMake(rectangleStartOriginX, rectangleOriginY, rectangleLayerSize.width, rectangleLayerSize.height);
    rectangleLayer.cornerRadius = rectangleLayerSize.width / 2.0;
    [_cursorIconLayer addSublayer:rectangleLayer];
    _cursorIconLayer.instanceCount = 3;
    _cursorIconLayer.instanceTransform = CATransform3DMakeTranslation(offset, 0, 0);
}

// MARK: - Custom Accessors

- (void)setCursorColor:(UIColor *)handlerColor {
    if ([_cursorColor isEqual:handlerColor]) { return; }
    _cursorColor = handlerColor;
    _cursorBackgroundLayer.backgroundColor = handlerColor.CGColor;
    _cursorIconLayer.backgroundColor = [handlerColor colorWithAlphaComponent:0.4].CGColor;
}

- (void)setJointLineColor:(UIColor *)jointLineColor {
    if ([_jointLineColor isEqual:jointLineColor]) { return; }
    _jointLineColor = jointLineColor;
    _jointLineLayer.backgroundColor = jointLineColor.CGColor;
}

@end
