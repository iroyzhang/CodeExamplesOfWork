//
//  GDVTTimelineDurationSelectionView.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineDurationSelectionView.h"
#import <Masonry/Masonry.h>
#import <GDFoundation/GDDefine.h>
#import "GDVTTimelineDurationSelectionHandlerView.h"
#import "GDVTTimelineDurationSelectionCursorView.h"
#import "GDVTTimelineDurationSelectionViewModel.h"
#import "GDVTSelectionRange.h"

@interface GDVTTimelineDurationSelectionView()

/// 边框视图
@property (nonatomic, strong) UIView *borderView;

/// 半透明视图
@property (nonatomic, strong) UIView *translucentView;

/// 左把手
@property (nonatomic, strong) GDVTTimelineDurationSelectionHandlerView *leftHanderView;

/// 右把手
@property (nonatomic, strong) GDVTTimelineDurationSelectionHandlerView *rightHanderView;

@end

@implementation GDVTTimelineDurationSelectionView

// MARK: - Lifecycle

- (instancetype)initWithViewModel:(GDVTTimelineDurationSelectionViewModel *)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
        _mainColor = viewModel.selectionViewColor;
        _borderWidth = viewModel.borderWidth;
        [self setupSubviews];
    }
    return self;
}

// MARK: - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustHandlersHotAreaWithViewFrame:self.frame];
}

- (void)adjustHandlersHotAreaWithViewFrame:(CGRect)viewFrame {
    CGSize standardHotAreaSize = CGSizeMake(44.0, 44.0);
    CGFloat viewWidth = CGRectGetWidth(viewFrame);
    
    CGFloat handlerViewWidth = CGRectGetWidth(self.leftHanderView.frame);
    CGFloat handlerViewHeight = CGRectGetHeight(self.leftHanderView.frame);
    CGFloat handlerHotAreaWidth = handlerViewWidth;
    
    if (viewWidth >= standardHotAreaSize.width * 2.0) {
        if (handlerViewWidth < standardHotAreaSize.width) {
            handlerHotAreaWidth =standardHotAreaSize.width;
        }
    } else {
        handlerHotAreaWidth = viewWidth / 2.0;
    }
    
    CGFloat handlerWidth = self.viewModel.handlerWidth;
    CGFloat horizontalInset = handlerHotAreaWidth - handlerWidth;
    CGFloat verticalInset = -(handlerHotAreaWidth - handlerViewHeight) / 2.0;
    self.leftHanderView.hotAreaInsets = UIEdgeInsetsMake(verticalInset, 0, verticalInset, -horizontalInset);
    self.rightHanderView.hotAreaInsets = UIEdgeInsetsMake(verticalInset, -horizontalInset, verticalInset, 0.0);
    
}

// MARK: - Public

- (void)updateDurationLabelPositionWithIsOnTheLeft:(BOOL)isOnTheLeft {
    if (!self.durationLabel) { return; }
    if (isOnTheLeft) {
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).equalTo(@(5));
            make.leading.equalTo(self).equalTo(@(5));
            make.width.equalTo(@32);
            make.height.equalTo(@16);
        }];
    } else {
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).equalTo(@(5));
            make.trailing.equalTo(self).equalTo(@(-5));
            make.width.equalTo(@32);
            make.height.equalTo(@16);
        }];
    }
}

// MARK: - Private Setup

- (void)setupSubviews {
    [self setupTranslucentView];
    [self setupBorderView];
    [self setupDurationLabel];
    [self setupLeftHandlerView];
    [self setupRightHandlerView];
}

- (void)setupTranslucentView {
    UIView *translucentView = [[UIView alloc] init];
    translucentView.backgroundColor = _mainColor;
    translucentView.alpha = 0.4;
    translucentView.userInteractionEnabled = NO;
    [self addSubview:translucentView];
    [translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@(_borderWidth));
        make.trailing.bottom.equalTo(@(-_borderWidth));
    }];
    _translucentView = translucentView;
}

- (void)setupBorderView {
    UIView *borderView = [[UIView alloc] init];
    borderView.userInteractionEnabled = NO;
    borderView.layer.cornerRadius = 4.0;
    borderView.layer.borderColor = _mainColor.CGColor;
    borderView.layer.borderWidth = _borderWidth;
    borderView.userInteractionEnabled = NO;
    [self addSubview:borderView];
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _borderView = borderView;
}

- (void)setupLeftHandlerView {
    GDVTTimelineDurationSelectionHandlerView *leftHanderView = [[GDVTTimelineDurationSelectionHandlerView alloc] init];
    leftHanderView.hotAreaInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [self addSubview:leftHanderView];
    [leftHanderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.equalTo(@(self.viewModel.handlerWidth));
    }];
    _leftHanderView = leftHanderView;
}

- (void)setupRightHandlerView {
    GDVTTimelineDurationSelectionHandlerView *rightHanderView = [[GDVTTimelineDurationSelectionHandlerView alloc] init];
    rightHanderView.hotAreaInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self addSubview:rightHanderView];
    [rightHanderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.width.equalTo(@(self.viewModel.handlerWidth));
    }];
    _rightHanderView = rightHanderView;
}

- (void)setupDurationLabel {
    UILabel *durationLabel = [[UILabel alloc] init];
    durationLabel.textColor = UIColor.whiteColor;
    durationLabel.font = [UIFont systemFontOfSize:9];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.backgroundColor = UIColor.blackColor;
    durationLabel.alpha = 0.5;
    durationLabel.layer.cornerRadius = 1.0;
    durationLabel.layer.masksToBounds = YES;
    [self addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).equalTo(@(5));
        make.trailing.equalTo(self).equalTo(@(-5));
        make.width.equalTo(@32);
        make.height.equalTo(@16);
    }];
    _durationLabel = durationLabel;
}

// MARK: - Private

- (void)updateViewModel:(GDVTTimelineDurationSelectionViewModel *)viewModel {
    self.mainColor = viewModel.selectionViewColor;
    NSNumber *handlerWidth = @(viewModel.handlerWidth);
    [self.leftHanderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(handlerWidth);
    }];
    [self.rightHanderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(handlerWidth);
    }];
}

- (void)addPanGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer toHandlerView:(GDVTTimelineDurationSelectionHandlerView *)handlerView {
    [handlerView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [handlerView removeGestureRecognizer:obj];
    }];
    
    [handlerView addGestureRecognizer:gestureRecognizer];
}

// MARK: - Custom Accessors

- (void)setLeftPanGestureRecognizer:(UIPanGestureRecognizer *)leftPanGestureRecognizer {
    if (_leftPanGestureRecognizer == leftPanGestureRecognizer) { return; }
    _leftPanGestureRecognizer = leftPanGestureRecognizer;
    [self addPanGestureRecognizer:leftPanGestureRecognizer toHandlerView:_leftHanderView];
}

- (void)setRightPanGestureRecognizer:(UIPanGestureRecognizer *)rightPanGestureRecognizer {
    if (_rightPanGestureRecognizer == rightPanGestureRecognizer) { return; }
    _rightPanGestureRecognizer = rightPanGestureRecognizer;
    [self addPanGestureRecognizer:rightPanGestureRecognizer toHandlerView:_rightHanderView];
}

// MARK: - Custom Accessors

- (void)setMainColor:(UIColor *)mainColor {
    _mainColor = mainColor;
    _translucentView.backgroundColor = mainColor;
    _borderView.layer.borderColor = mainColor.CGColor;
    
    if (_translucentView.superview) {
        [_translucentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@(_borderWidth));
            make.trailing.bottom.equalTo(@(-_borderWidth));
        }];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    _borderView.layer.borderWidth = borderWidth;
}

- (void)setViewModel:(GDVTTimelineDurationSelectionViewModel *)viewModel {
    _viewModel = viewModel;
    [self updateViewModel:viewModel];
}

@end
