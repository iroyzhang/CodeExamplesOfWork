//
//  GDVTPannelContainerView.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/23.
//

#import "GDVTPannelContainerView.h"
#import <Masonry/Masonry.h>
#import <GDFoundation/GDDefine.h>
#import <GDFoundation/UIColor+GDHex.h>
#import "GDVTViewUtils.h"

@interface GDVTPannelContainerView()

/// 主容器视图
@property (nonatomic, strong) UIView *mainContainerView;

/// 次容器视图
@property (nonatomic, strong) UIView *subContainerView;

/// 顶部的控制视图
@property (nonatomic, strong) UIControl *topControl;

@end

@implementation GDVTPannelContainerView

// MARK: - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame contentViewHeight:(CGFloat)contentViewHeight
                     tappedNonContentArea:(void (^)(void))tappedNonContentArea {
    self = [super initWithFrame:frame];
    if (self) {
        _contentViewHeight = contentViewHeight;
        _tappedNonContentArea = [tappedNonContentArea copy];
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame contentViewHeight:252.0 tappedNonContentArea:nil];
}

// MARK: - Public

- (void)setupMainView:(UIView *)mainView {
    [self addView:mainView toContainerView:self.mainContainerView];
}

- (void)setupSubview:(UIView *)subview {
    [self addView:subview toContainerView:self.subContainerView];
}

// MARK: - Private Setup

- (void)setupSubviews {
    [self setupContentView];
    [self setupMainContainerView];
    [self setupTopControl];
    [self setupSubContainerView];
    [self setupCoreSubviewsConstraints];
}

- (void)setupContentView {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_contentView];
}

- (void)setupMainContainerView {
    _mainContainerView = [[UIView alloc] init];
    [_contentView addSubview:_mainContainerView];
}

- (void)setupSubContainerView {
    _subContainerView = [[UIView alloc] init];
    [_contentView addSubview:_subContainerView];
}

- (void)setupTopControl {
    _topControl = [[UIControl alloc] init];
    [_topControl addTarget:self action:@selector(topControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_topControl];
}

- (void)setupCoreSubviewsConstraints {
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.equalTo(@(_contentViewHeight + XV_ViewControllerBottomSpace));
    }];
    
    [_topControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.bottom.equalTo(_contentView.mas_top).offset(-[GDVTViewUtils playerControlViewHeight]);
    }];
    
    [_mainContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(_contentView);
        make.bottom.equalTo(_subContainerView.mas_top);
    }];
    
    [_subContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_contentView);
        make.height.equalTo(@56);
        make.bottom.equalTo(_contentView).offset(-XV_ViewControllerBottomSpace);
    }];
}

// MARK: - UIEvents

- (void)topControlAction {
    GDBlockCall(self.tappedNonContentArea);
}

// MARK: - Private

- (void)addView:(UIView *)view toContainerView:(UIView *)containerView {
    [containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [containerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containerView);
    }];
}

// MARK: - Custom Accessors

- (void)setContentViewHeight:(CGFloat)contentViewHeight {
    if (!self.contentView || contentViewHeight == self.contentViewHeight) { return; }
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(contentViewHeight));
    }];
}

@end
