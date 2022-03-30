//
//  GDVTElementDurationAdjustView.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/26.
//

#import "GDVTElementDurationAdjustView.h"
#import <Masonry/Masonry.h>
#import <GDFoundation/GDDefine.h>
#import "GDVTTimelineView.h"
#import "GDVTTimelineDurationSelectionView.h"
#import "GDVTTimelineDurationSelectionCursorView.h"
#import "GDVTElementDurationAdjustViewModel.h"
#import "GDVTTimelineViewModel.h"
#import "GDVTTimelineDurationSelectionViewModel.h"
#import "GDVTTimelineViewConfiguration.h"
#import "GDVTSelectionRange.h"
#import "GDTimeRange.h"
#import "NSString+GDVEAddtions.h"

@interface GDVTElementDurationAdjustView() <GDVTTimelineViewDelegate>

/// 时间轴视图
@property (nonatomic, strong) GDVTTimelineView *timelineView;

/// 时长选择视图
@property (nonatomic, strong) GDVTTimelineDurationSelectionView *selectionView;

/// 游标视图
@property (nonatomic, strong) GDVTTimelineDurationSelectionCursorView *cursorView;

/// 时刻指示器
@property (nonatomic, strong) UIView *timeIndicatorView;

/// 是否正在拖拽
@property (nonatomic, assign) BOOL isPanning;

/// 是否向左拖拽
@property (nonatomic, assign) BOOL isPanningToLeft;

/// 正在更新的原因
@property (nonatomic, assign) GDVTSelectionRangeUpdateReason updatingReason;

/// 自动滚动计时器
@property (nonatomic, strong) CADisplayLink *panningTimer;

@end

@implementation GDVTElementDurationAdjustView

// MARK: - Lifecycle

- (instancetype)initWithViewModel:(GDVTElementDurationAdjustViewModel *)viewModel {
    self = [super init];
    if (self) {
        [self updateWithViewModel:viewModel];
    }
    return self;
}

// MARK: - Public

- (void)updateWithSelectionRange:(GDVTSelectionRange *)selectionRange {
    CGRect newSelectionViewFrame = [self frameForSelectionViewWithSelectionRange:selectionRange];
    if (!CGRectEqualToRect(self.selectionView.frame, newSelectionViewFrame)) {
        self.selectionView.frame = newSelectionViewFrame;
    }
    
    CGRect newCursorViewFrame = [self frameForCursorViewWithSelectionRange:selectionRange];
    if (!CGRectEqualToRect(self.cursorView.frame, newCursorViewFrame)) {
        self.cursorView.frame = newCursorViewFrame;
    }
    
    // 修改时间显示
    GDTimeRange *timeRange = [self.viewModel timeRangeForSelectionRange:selectionRange];
    NSString *durationText = [NSString formatTime:timeRange.duration];
    if (![durationText isEqualToString:self.selectionView.durationLabel.text]) {
        self.selectionView.durationLabel.text = durationText;
    }
    
    // 判断是否需要显示时间视图
    CGFloat minWidthForShowDurationLabel = 38.0;
    CGFloat selectionViewWidth = CGRectGetWidth(self.selectionView.frame);
    self.selectionView.durationLabel.hidden = selectionViewWidth < minWidthForShowDurationLabel ? YES : NO;
}

- (void)updateWithViewModel:(GDVTElementDurationAdjustViewModel *)viewModel seekTime:(long)seekTime {
    [self updateWithViewModel:viewModel];
    [self.timelineView reloadDataWithSeekTime:seekTime];
}

- (void)seekTimelineToTime:(long)time animated:(BOOL)animated {
    if (self.isPanning) { return; }
    [self.timelineView seekToTime:time animated:NO];
}

// MARK: - Private

- (void)updateWithViewModel:(GDVTElementDurationAdjustViewModel *)viewModel {
    _viewModel = viewModel;
    
    GDWeakify(self);
    _viewModel.selectionRangeChanged = ^(GDVTSelectionRange * selectionRange) {
        GDStrongify(self);
        [self updateWithSelectionRange:selectionRange];
    };
    
    [self updateTimelineViewWithViewModel:viewModel.timelineViewModel];
    [self updateSelectionViewWithViewModel:viewModel.durationSelectionViewModel];
    [self updateCursorViewWithViewModel:viewModel.durationSelectionViewModel];
    [self updateWithSelectionRange:viewModel.currentSelectionRange];
    [self updateTimeIndicatorView];
}

- (void)updateTimelineViewWithViewModel:(GDVTTimelineViewModel *)viewModel {
    if (!_timelineView) {
        _timelineView = [[GDVTTimelineView alloc] initWithViewModel:viewModel];
        _timelineView.delegate = self;
        [self addSubview:_timelineView];
        [_timelineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        _timelineView.viewModel = viewModel;
    }
}

- (void)updateSelectionViewWithViewModel:(GDVTTimelineDurationSelectionViewModel *)viewModel {
    if (!_selectionView) {
        self.selectionView = [[GDVTTimelineDurationSelectionView alloc] initWithViewModel:viewModel];
        self.selectionView.leftPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnLeftHandler:)];
        self.selectionView.rightPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnRightHandler:)];
        [self.timelineView addSubviewToScrollView:self.selectionView];
    } else {
        self.selectionView.viewModel = viewModel;
    }
}

- (void)updateCursorViewWithViewModel:(GDVTTimelineDurationSelectionViewModel *)viewModel {
    if (!_cursorView) {
        _cursorView = [[GDVTTimelineDurationSelectionCursorView alloc] initWithFrame:CGRectZero cursorSize:CGSizeMake(32, 26) jointLineSize:CGSizeMake(2, 12) jointLineSpacing:2];
        [_cursorView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnCursorView:)]];
        [_cursorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnCursorView:)]];
        [self.timelineView addSubviewToScrollView:_cursorView];
    }
    
    _cursorView.cursorColor = viewModel.selectionViewColor;
    _cursorView.jointLineColor = viewModel.selectionViewColor;
}

- (CGRect)frameForSelectionViewWithSelectionRange:(GDVTSelectionRange *)selectionRange {
    GDVTTimelineViewConfiguration *timelineViewConfiguration = self.timelineView.viewModel.viewConfiguration;
    
    CGFloat width = selectionRange.length;
    CGFloat height = timelineViewConfiguration.contentHeight + self.selectionView.borderWidth * 2.0;
    CGFloat originY = CGRectGetMidY(self.bounds) - height / 2.0;
    CGFloat originX = selectionRange.location;
    
    return CGRectMake(originX, originY, width, height);
}

- (CGRect)frameForCursorViewWithSelectionRange:(GDVTSelectionRange *)selectionRange {
    CGRect selectionViewFrame = [self frameForSelectionViewWithSelectionRange:selectionRange];
    
    CGFloat height = self.cursorView.cursorSize.height + self.cursorView.jointLineSize.height + self.cursorView.jointLineSpacing;
    CGFloat width = MAX(self.cursorView.cursorSize.width, self.cursorView.jointLineSize.width);
    CGFloat originY = CGRectGetMinY(selectionViewFrame) - height;
    CGFloat originX = selectionRange.location - width / 2.0;
    
    return CGRectMake(originX, originY, width, height);
}

- (void)updateTimeIndicatorView {
    if (!_timeIndicatorView) {
        UIView *timeIndicatorView = [[UIView alloc] init];
        timeIndicatorView.backgroundColor = UIColor.blackColor;
        timeIndicatorView.layer.borderColor = UIColor.whiteColor.CGColor;
        timeIndicatorView.layer.borderWidth = 0.5;
        timeIndicatorView.layer.cornerRadius = 0.5;
        [self addSubview:timeIndicatorView];
        [timeIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@3);
            make.height.equalTo(@50);
        }];
    }
}

- (void)notifyDelegateWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer selectionRange:(GDVTSelectionRange *)selectionRange updateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    UIGestureRecognizerState state = panGestureRecognizer.state;
    CGPoint translation = [panGestureRecognizer translationInView:self];
    [panGestureRecognizer setTranslation:CGPointZero inView:self];
    switch (state) {
        case UIGestureRecognizerStateBegan:
            self.isPanning = YES;
            [self startPanningTimer];
            [self updateWhenBeganPanWithUpdateReason:updateReason panGestureRecognizer:panGestureRecognizer];
            if ([self.delegate respondsToSelector:@selector(elementDurationAdjustView:beganUpdatingSelectionRange:updateReason:)]) {
                [self.delegate elementDurationAdjustView:self beganUpdatingSelectionRange:selectionRange updateReason:updateReason];
            }
            break;
        case UIGestureRecognizerStateChanged:
            self.isPanningToLeft = translation.x < 0.0;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            self.updatingReason = GDVTSelectionRangeUpdateReasonNone;
            self.isPanning = NO;
            [self stopPanningTimer];
            [self updateWhenEndPanWithUpdateReason:updateReason];
            if ([self.delegate respondsToSelector:@selector(elementDurationAdjustView:endUpdatingSelectionRange:updateReason:)]) {
                [self.delegate elementDurationAdjustView:self endUpdatingSelectionRange:selectionRange updateReason:updateReason];
            }
            break;
        default:
            break;
    }
}

- (void)notifyDelegateUpdatingSelectionRange:(GDVTSelectionRange *)selectionRange updateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    if ([self.delegate respondsToSelector:@selector(elementDurationAdjustView:updatingSelectionRange:updateReason:)]) {
        [self.delegate elementDurationAdjustView:self updatingSelectionRange:selectionRange updateReason:updateReason];
    }
}

- (void)panningTimerTriggered:(CADisplayLink *)displayLink {
    if (!self.isPanning) { return; }
    [self notifyDelegateUpdatingSelectionRange:self.viewModel.currentSelectionRange updateReason:self.updatingReason];
    [self checkToAutoScrollTimeline];
}

- (void)checkToAutoScrollTimeline {
    if (!self.isPanning) { return; }
    
    CGFloat velocityX = [self velocityXWithUpdateReason:self.updatingReason isPanningToLeft:self.isPanningToLeft];
    if (velocityX == 0.0) { return; }
    
    [self.timelineView seekWithOffset:CGPointMake(velocityX, 0)];
    
    switch (self.updatingReason) {
        case GDVTSelectionRangeUpdateReasonUpdateLocationOnly:
            [self.viewModel updateSelectionRangeLocationWithTranslationX:velocityX];
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLengthOnly:
            [self.viewModel clampSelectionRangeLength:velocityX];
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLocationAndLength:
            [self.viewModel clampSelectionRangeLocation:velocityX];
            break;
        default:
            break;
    }
}

- (CGFloat)velocityXWithUpdateReason:(GDVTSelectionRangeUpdateReason)updateReason isPanningToLeft:(BOOL)isPanningToLeft {
    if (updateReason == GDVTSelectionRangeUpdateReasonNone) { return 0.0; }
    
    CGFloat distance = [self distanceFromEdgeWithUpdateReason:updateReason isPanningToLeft:isPanningToLeft];
    
    CGFloat neededSpacing = 0.0;
    if (isPanningToLeft) {
        neededSpacing = self.timelineView.contentInset.left / 2.0;
    } else {
        neededSpacing = self.timelineView.contentInset.right / 2.0;
    }
    
    if (neededSpacing < 30.0) {
        neededSpacing = 30.0;
    }
    
    CGFloat velocityX = [self autoScrollVelocityXWithDistance:distance neededSpacing:neededSpacing];
    
    if (isPanningToLeft) {
        velocityX = -velocityX;
    }
    
    return velocityX;
}

- (CGFloat)distanceFromEdgeWithUpdateReason:(GDVTSelectionRangeUpdateReason)updateReason isPanningToLeft:(BOOL)isPanningToLeft {
    if (updateReason == GDVTSelectionRangeUpdateReasonNone) { return 0.0; }
    
    CGRect visibleRect = [self.timelineView visibleRect];
    UIEdgeInsets contentInset = self.timelineView.contentInset;
    CGFloat visibleMinOriginX = CGRectGetMinX(visibleRect);
    CGFloat visibleMaxOriginX = CGRectGetMaxX(visibleRect);
    CGFloat distance = 0.0;
    switch (updateReason) {
        case GDVTSelectionRangeUpdateReasonUpdateLocationOnly:
            if (isPanningToLeft) {
                distance = CGRectGetMinX(self.cursorView.frame) + contentInset.left - visibleMinOriginX;
            } else {
                distance = visibleMaxOriginX - CGRectGetMaxX(self.cursorView.frame)- contentInset.left;
            }
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLengthOnly:
            if (isPanningToLeft) {
                distance = CGRectGetMaxX(self.selectionView.frame) + contentInset.left - visibleMinOriginX;
            } else {
                distance = visibleMaxOriginX - CGRectGetMaxX(self.selectionView.frame) - contentInset.left;
            }
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLocationAndLength:
            if (isPanningToLeft) {
                distance = CGRectGetMinX(self.selectionView.frame) + contentInset.left - visibleMinOriginX;
            } else {
                distance = visibleMaxOriginX - CGRectGetMinX(self.selectionView.frame) - contentInset.left;
            }
            break;
        default:
            break;
    }
    
    return distance;
}

- (CGFloat)autoScrollVelocityXWithDistance:(CGFloat)distance neededSpacing:(CGFloat)neededSpacing {
    CGFloat offset = neededSpacing - distance;
    if (offset < 0) {
        return 0;
    }
    CGFloat velocityX = 2.0 + offset / 5.0;
    return velocityX;
}

- (void)updateWhenBeganPanWithUpdateReason:(GDVTSelectionRangeUpdateReason)updateReason panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    BOOL needUpdateDurationLabelPosition = NO;
    BOOL isDurationLabelPositionOnTheLeft = NO;
    switch (updateReason) {
        case GDVTSelectionRangeUpdateReasonNone:
            isDurationLabelPositionOnTheLeft = NO;
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLengthOnly:
            needUpdateDurationLabelPosition = YES;
            isDurationLabelPositionOnTheLeft = NO;
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLocationOnly:
            needUpdateDurationLabelPosition = NO;
            break;
        case GDVTSelectionRangeUpdateReasonUpdateLocationAndLength:
            needUpdateDurationLabelPosition = YES;
            isDurationLabelPositionOnTheLeft = YES;
            break;
    }
    
    if (panGestureRecognizer.view == self.cursorView) {
        [self makeFeedbackImpact];
    }
    if (needUpdateDurationLabelPosition) {
        [self.selectionView updateDurationLabelPositionWithIsOnTheLeft:isDurationLabelPositionOnTheLeft];
    }
}

- (void)updateWhenEndPanWithUpdateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    [self.selectionView updateDurationLabelPositionWithIsOnTheLeft:NO];
}

- (void)makeFeedbackImpact {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impact = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
        [impact prepare];
        [impact impactOccurred];
    }
}

- (void)startPanningTimer {
    if (_panningTimer) {
        [self stopPanningTimer];
    }
    _panningTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(panningTimerTriggered:)];
    [_panningTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopPanningTimer {
    [_panningTimer invalidate];
    _panningTimer = nil;
}

// MARK: - Gestures

- (void)panOnLeftHandler:(UIPanGestureRecognizer *)panGestureRecognizer {
    self.updatingReason = GDVTSelectionRangeUpdateReasonUpdateLocationAndLength;
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    [self.viewModel clampSelectionRangeLocation:translation.x];
    [self notifyDelegateWithPanGestureRecognizer:panGestureRecognizer selectionRange:self.viewModel.currentSelectionRange updateReason:GDVTSelectionRangeUpdateReasonUpdateLocationAndLength];
}

- (void)panOnRightHandler:(UIPanGestureRecognizer *)panGestureRecognizer {
    self.updatingReason = GDVTSelectionRangeUpdateReasonUpdateLengthOnly;
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    [self.viewModel clampSelectionRangeLength:translation.x];
    [self notifyDelegateWithPanGestureRecognizer:panGestureRecognizer selectionRange:self.viewModel.currentSelectionRange updateReason:GDVTSelectionRangeUpdateReasonUpdateLengthOnly];
}

- (void)panOnCursorView:(UIPanGestureRecognizer *)panGestureRecognizer {
    self.updatingReason = GDVTSelectionRangeUpdateReasonUpdateLocationOnly;
    CGPoint translation = [panGestureRecognizer translationInView:self];
    [self.viewModel updateSelectionRangeLocationWithTranslationX:translation.x];
    [self notifyDelegateWithPanGestureRecognizer:panGestureRecognizer selectionRange:self.viewModel.currentSelectionRange updateReason:GDVTSelectionRangeUpdateReasonUpdateLocationOnly];
}

- (void)tappedOnCursorView:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self makeFeedbackImpact];
}

// MARK: - GDVTTimelineViewDelegate

- (void)timelineViewDidScroll:(GDVTTimelineView *)timelineView {
    if ([self.delegate respondsToSelector:@selector(elementDurationAdjustView:didSeekToTime:)]) {
        long time = [self.viewModel.timelineViewModel timeForOffset:timelineView.contentOffset.x + timelineView.contentInset.left];
        [self.delegate elementDurationAdjustView:self didSeekToTime:time];
    }
}

- (void)timelineViewDidReloadData:(GDVTTimelineView *)timelineView {
    [self.viewModel updateCurrentSelectionRange];
    [self updateWithSelectionRange:self.viewModel.currentSelectionRange];
}

// MARK: - Custom Accessors

- (void)setViewModel:(GDVTElementDurationAdjustViewModel *)viewModel {
    [self updateWithViewModel:viewModel seekTime:0];
}

@end
