//
//  FUSliderView.m
//  FUVideoEditor
//
//  Created by Roy Zhang on 2020/6/17.
//  Copyright © 2020 Faceunity. All rights reserved.
//

#import "FUSliderView.h"
#import "UIColor+Hex.h"
#import "UIButton+ResponseRegion.h"
#import "UIView+Convenient.h"
#import "FUSliderHandlerView.h"

static const CGFloat kDefaultHandlerWidth = 24;
static const CGFloat kSliderHeight = 4;
static const CGFloat kLabelSpacing = 10;
static const NSInteger degreeScaleLabelCount = 6;

@interface FUSliderView()
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIView *filledView;
@property (nonatomic, strong) FUSliderHandlerView *handlerView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, assign) CGFloat filledWidth;
@property (nonatomic, copy) NSString *defaultDisplayFormat;
@property (nonatomic, strong) NSMutableArray *degreeScaleLabelArray;
@end

@implementation FUSliderView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _maxValue = 0;
        _value = 0;
        _style = FUSliderViewStyleUnidirectional;
        _handlerSize = CGSizeMake(kDefaultHandlerWidth, kDefaultHandlerWidth);
        _continuous = YES;
        _defaultDisplayFormat = fuStr(%.0f);
        _displayFormat = _defaultDisplayFormat;
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)degreeScaleLabelArray {
    if (_degreeScaleLabelArray == nil) {
        _degreeScaleLabelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _degreeScaleLabelArray;
}

#pragma mark - Layout

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViewsFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateViewsFrame];
    
    if (self.isShowDegreeScaleLabel) {
        [self showDegreeScaleLabel];
    }
}

- (void)updateViewsFrame {
    _emptyView.frame = CGRectMake(0, self.height / 2.0 - kSliderHeight / 2.0, self.width, kSliderHeight);
    _gradientView.frame = CGRectMake(0, self.height / 2.0 - kSliderHeight / 2.0, self.width, kSliderHeight);
    _filledView.originY = self.height / 2.0 - kSliderHeight / 2.0;
    _handlerView.originY = (self.height - _handlerSize.height) / 2.0;
    _handlerView.width = _handlerSize.width;
    _handlerView.height = _handlerSize.height;
    _handlerView.layer.cornerRadius = _handlerSize.height / 2.0;
    self.filledWidth = self.width - _handlerSize.width;
}

- (void)setFilledWidth:(CGFloat)filledWidth {
    _filledWidth = filledWidth;
    [self setValue:_value minimumValue:_minValue maximumValue:_maxValue];
}

#pragma mark - Setups

- (void)setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self setupEmptySliderView];
    [self setupGradientView];
    [self setupFilledSliderView];
    [self setupHandlerView];
    [self setupValueLabel];
    [self setupDegreeScaleLabel];
    [self updateViewsFrame];
}

- (void)setupEmptySliderView {
    _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2.0 - kSliderHeight / 2.0, self.width, kSliderHeight)];
    _emptyView.backgroundColor = [UIColor colorWithHexColorString:fuStr(ECEFF4)];
    _emptyView.layer.masksToBounds = YES;
    _emptyView.layer.cornerRadius = 2.0;
    [self addSubview:_emptyView];
}

- (void)setupGradientView {
    _gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2.0 - kSliderHeight / 2.0, self.width, kSliderHeight)];
    _gradientView.hidden = YES;
    _gradientView.layer.masksToBounds = YES;
    _gradientView.layer.cornerRadius = 2.0;
    [self addSubview:_gradientView];
}

- (void)setupFilledSliderView {
    _filledView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height / 2.0 - kSliderHeight / 2.0, 0.0, kSliderHeight)];
    _filledView.backgroundColor = [UIColor colorWithHexColorString:fuStr(5266FF)];
    _filledView.layer.masksToBounds = YES ;
    _filledView.layer.cornerRadius = 1.0 ;
    [self addSubview:_filledView];
}

- (void)setupHandlerView {
    CGSize handlerSize = _handlerSize;
    _handlerView = [[FUSliderHandlerView alloc] initWithFrame:CGRectMake(0, (self.height - handlerSize.height) / 2.0, handlerSize.width, handlerSize.height)];
    _handlerView.backgroundColor = [UIColor colorWithHexColorString:fuStr(ECEFF4)];
    _handlerView.layer.cornerRadius = handlerSize.height / 2.0;
    _handlerView.layer.masksToBounds = YES;
    [self addSubview:_handlerView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerViewWithGestureRecognizer:)];
    [_handlerView addGestureRecognizer:panGestureRecognizer];
}

- (void)setupValueLabel {
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40.0, 18.0)];
    _valueLabel.hidden = YES;
    _valueLabel.font = [UIFont systemFontOfSize:14.0];
    _valueLabel.textColor = [UIColor whiteColor];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_valueLabel];
}

- (void)setupDegreeScaleLabel {
    for (NSInteger i = 0; i < degreeScaleLabelCount; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithRed:66/255.0 green:61/255.0 blue:82/255.0 alpha:1.0];
        label.hidden = YES;
        [self.degreeScaleLabelArray addObject:label];
        [self addSubview:label];
    }
}

- (void)showDegreeScaleLabel {
    //CGFloat degreeNumber = (_minValue + _maxValue) / (degreeScaleLabelCount*1.0);
    CGFloat labelWidth = 20.0;
    CGFloat labelHight = 10.0;
    //CGFloat margin = (self.width - labelWidth*degreeScaleLabelCount) / (degreeScaleLabelCount-1);
    CGFloat margin = self.width / (degreeScaleLabelCount-1);
    for (NSInteger i = 0; i < degreeScaleLabelCount; i++) {
        UILabel *label = self.degreeScaleLabelArray[i];
        label.hidden = NO;
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"%.1f",_minValue];
        }else if (i == 1) {
            label.text = [NSString stringWithFormat:@"1.0"];
        }else if (i == 2) {
            label.text = [NSString stringWithFormat:@"3.0"];
        }else if (i == 3) {
            label.text = [NSString stringWithFormat:@"5.0"];
        }else if (i == 4) {
            label.text = [NSString stringWithFormat:@"7.0"];
        }else if (i == degreeScaleLabelCount - 1) {
            label.text = [NSString stringWithFormat:@"%.1f",_maxValue];
        }
        // 0.1~1这段的间距为总长度的1/5
        if (i == 0 || i == 1) {
            label.frame = CGRectMake(i*margin, 24.0, labelWidth, labelHight);
        }else {
            // 剩下的长度每1个速度值占的长度
            CGFloat otherMargin = (self.width - margin) / _maxValue;
            CGFloat value = label.text.floatValue;
            label.frame = CGRectMake(margin+otherMargin*value-labelWidth, 24.0, labelWidth, labelHight);
        }
        
    }
}

#pragma mark - Custom Accessors

- (void)setValue:(float)value {
    if (value < _minValue) {
        value = _minValue;
    } else if (value > _maxValue) {
        value = _maxValue;
    }
       
    double currentValue = [self formatedValueForValue:_value];
    double newValue = [self formatedValueForValue:value];
    if (currentValue != newValue) {
        _value = newValue;
        [self reloadUI];
    }

}

- (void)setMinValue:(float)minValue {
    _minValue = minValue;
    [self reloadUI];
}

- (void)setMaxValue:(float)maxValue {
    _maxValue = maxValue;
    [self reloadUI];
}

- (void)setHandlerSize:(CGSize)handlerSize {
    _handlerSize = handlerSize;
    [self setNeedsLayout];
}

#pragma mark - Gesture Events

- (void)panHandlerViewWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    [self updateWithPanGestureRecognizer:gestureRecognizer];
}

- (void)updateWithPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat panOriginX = [self validPanOriginXWithPanOriginX:[gestureRecognizer locationInView:self].x];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _valueLabel.hidden = NO;
            CGPoint valueLabelCenter = CGPointMake(panOriginX, _handlerView.originY - kLabelSpacing);
            
            if (!_continuous) {
                CGFloat newHandleX = [self originXWithValue:_value];
                valueLabelCenter = CGPointMake(newHandleX, valueLabelCenter.y);
            }
            _valueLabel.center = valueLabelCenter;
            [self updateValueLabelWithNewValue:_value displayFormat:_displayFormat];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint handlerCenter = CGPointMake(panOriginX, _handlerView.center.y);
            float newValue = [self newValueWithPanOriginX:panOriginX];
            if (!_continuous) {
                newValue = roundf(newValue);
                CGFloat newHandleX = [self originXWithValue:newValue];
                handlerCenter = CGPointMake(newHandleX, _handlerView.center.y);
            }
            if (_value != newValue) {
                _handlerView.center = handlerCenter;
                _valueLabel.center = CGPointMake(handlerCenter.x, _handlerView.originY - kLabelSpacing);
                [self updateValueLabelWithNewValue:newValue displayFormat:_displayFormat];
                [self reloadUI];
                [self sliderValueChanged:newValue isFinished:NO];
            }
        }
            break;
        default: {
            _valueLabel.hidden = YES;
            [self sliderValueChanged:_value isFinished:YES];
        }
            break;
    }
}

- (CGFloat)validPanOriginXWithPanOriginX:(CGFloat)panOriginX {
    if (panOriginX < _handlerSize.width / 2.0) {
        return _handlerSize.width / 2.0;
    } else if (panOriginX > self.width - _handlerSize.width / 2.0) {
        return self.width - _handlerSize.width / 2.0;
    } else {
        return panOriginX;
    }
}

- (float)newValueWithPanOriginX:(CGFloat)panOriginX {
    return (panOriginX - _handlerSize.width / 2.0) / _filledWidth * (_maxValue - _minValue) + _minValue;
}

- (CGFloat)originXWithValue:(float)value {
    value = fminf(fmaxf(value, _minValue), _maxValue);
    if (_maxValue - _minValue == 0) {
        return 0;
    }
    return (value - _minValue) / (_maxValue - _minValue) * _filledWidth + _handlerSize.width / 2.0;
}

#pragma mark - Update

- (void)sliderValueChanged:(float)value isFinished:(BOOL)finished {
    double currentValue = [self formatedValueForValue:_value];
    double newValue = [self formatedValueForValue:value];
    if (currentValue != newValue) {
        _value = newValue;
        [self reloadUI];
    }
    [_delgate sliderView:self valueChanged:value isFinished:finished];
}

#pragma mark - Reload

- (void)reloadUI {
    [self reloadUIWithStyle:_style];
}

- (void)reloadUIWithStyle:(FUSliderViewStyle)style {
    _style = style;
    switch (style) {
        case FUSliderViewStyleUnidirectional: {
            _filledView.originX = 0.0;
            _filledView.width = _handlerView.center.x;
        }
            break;
        case FUSliderViewStyleBidirectional: {
            if (_value < 0.0) {
                _filledView.originX = _handlerView.center.x;
                _filledView.width = self.width / 2.0 - _filledView.originX;
            } else {
                _filledView.originX = self.width / 2.0;
                _filledView.width = _handlerView.center.x - _filledView.originX;
            }
        }
            break;
    }
}

- (void)updateValueLabelWithNewValue:(float)newValue displayFormat:(NSString *)displayFormat {
    float validValue = newValue;
    if ([displayFormat isEqualToString:@"%.0f"]) {
        if (newValue > -1 && newValue < 0.0) {
            validValue = 0.0;
        }
    }
    
    NSString *newTextString = [NSString stringWithFormat:displayFormat, validValue];
    _valueLabel.text = newTextString;
    NSLog(@"slider value %f", newValue);
}

- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue {
    [self setValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:YES];
}

- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue displayFormat:(NSString *)displayFormat {
    [self setValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:YES displayFormat:displayFormat];
}

- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous {
    [self setValue:value minimumValue:minimumValue maximumValue:maximumValue continuous:continuous displayFormat:_displayFormat];
}

- (void)setValue:(float)value minimumValue:(float)minimumValue maximumValue:(float)maximumValue continuous:(BOOL)continuous displayFormat:(NSString *)displayFormat {
    _minValue = minimumValue;
    _maxValue = maximumValue;
    _displayFormat = displayFormat;
    self.value = value;
    _continuous = continuous;
    
    if (_minValue < 0 && _maxValue > 0) {
        _style = FUSliderViewStyleBidirectional;
    } else {
        _style = FUSliderViewStyleUnidirectional;
    }
    
    if (_minValue < _maxValue) {
        CGFloat handlerCenterX = (_value - _minValue) / (_maxValue - _minValue) * _filledWidth + _handlerSize.width / 2.0;
        _valueLabel.center = CGPointMake(handlerCenterX, _handlerView.originY - kLabelSpacing);
        _handlerView.center = CGPointMake(handlerCenterX, _handlerView.center.y);
        [self reloadUI];
    }
}

- (double)formatedValueForValue:(double)value{
    if (_displayFormat) {
        NSString *valueStr = [NSString stringWithFormat:_displayFormat, value];
        return valueStr.doubleValue;
    }
    return value;
}

- (void)setFilledColor:(UIColor *)filledColor {
    _filledView.backgroundColor = filledColor;
}

@end
