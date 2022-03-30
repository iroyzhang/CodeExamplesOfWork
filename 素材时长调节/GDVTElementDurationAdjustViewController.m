//
//  GDVTElementDurationAdjustViewController.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/23.
//

#import "GDVTElementDurationAdjustViewController.h"
#import <Masonry/Masonry.h>
#import <GDFoundation/GDDefine.h>
#import "GDVTPannelContainerView.h"
#import "GDVTElementDurationAdjustView.h"
#import "GDVEMaterialBottomTitleView.h"
#import "GDVTElementDurationAdjustViewModel.h"
#import "GDVEBaseCoat.h"
#import "GDTimeRange.h"
#import "GDVEResource.h"
#import "GDMVideoEditLocalizable.h"
#import "GDVTElementDurationAdjustService.h"

@interface GDVTElementDurationAdjustViewController() <
GDVTElementDurationAdjustViewDelegate,
GDVEMaterialBottomTitleViewDelegate
>

/// 容器视图
@property (nonatomic, strong) GDVTPannelContainerView *containerView;

/// 时长调节视图
@property (nonatomic, strong) GDVTElementDurationAdjustView *durationAdjustView;

/// 标题栏
@property (nonatomic, strong) GDVEMaterialBottomTitleView *titleBar;

/// 时长调节服务
@property (nonatomic, strong) GDVTElementDurationAdjustService *service;

@end

@implementation GDVTElementDurationAdjustViewController

// MARK: - GDVEFunctionProtocol

- (void)showInView:(UIView *)parentView {
    if (self.isShow) { return; }
    
    if (self.containerView.superview != parentView) {
        [parentView addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(parentView);
            make.top.equalTo(parentView.mas_top).offset(GDScreenHeight);
            make.height.mas_equalTo(GDScreenHeight);
        }];
    }
    
    if ([self.delegate respondsToSelector:@selector(functionViewControllerWillShow:)]) {
        [self.delegate functionViewControllerWillShow:self];
    }
    
    [self showPannelView:YES];
}

- (void)dismiss {
    if (!self.isShow) { return; }
    
    if ([self.delegate respondsToSelector:@selector(functionViewControllerWillDismiss:)]) {
        [self.delegate functionViewControllerWillDismiss:self];
    }
    
    [self showPannelView:NO];
}

// MARK: - Public

- (GDVEBaseCoat *)currentCoat {
    return self.durationAdjustView.viewModel.elementCoat;
}

- (void)adjustElementWithCoat:(GDVEBaseCoat *)coat {
    GDVTElementDurationAdjustViewModel *viewModel = [[GDVTElementDurationAdjustViewModel alloc] initWithTimelineCoat:self.timelineCoat elementCoat:coat intervalPerFrame:2000 imagePerFrameSize:CGSizeMake(60, 60)];
    [self.durationAdjustView updateWithViewModel:viewModel seekTime:self.service.currentPlayerTime];
    [self.service activePlayerLoop];
}

- (void)videoPlayerWithTime:(long)currentTime {
    [self.durationAdjustView seekTimelineToTime:currentTime animated:YES];
}

// MARK: - Private

- (void)showPannelView:(BOOL)isShow {
    self.show = isShow;
    UIView *parentView = [self.containerView superview];
    [parentView layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat offset = isShow ? 0 : GDScreenHeight;
        [self.containerView  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(parentView.mas_top).offset(offset);
        }];
        [parentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (isShow) {
            if ([self.delegate respondsToSelector:@selector(functionViewControllerDidShow:)]) {
                [self.delegate functionViewControllerDidShow:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(functionViewControllerDidDismiss:)]) {
                [self.delegate functionViewControllerDidDismiss:self];
            }
            [self.containerView removeFromSuperview];
            self.containerView = nil;
        }
    }];
}

- (long)seekTimeWithTimeRange:(GDTimeRange *)timeRange updateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    long seekTime = timeRange.delay;
    switch (updateReason) {
        case GDVTSelectionRangeUpdateReasonUpdateLengthOnly:
            seekTime = timeRange.endTime;
        default:
            break;
    }
    return seekTime;
}

- (void)saveResultAndDismiss {
    [self dismiss];
    [self.service inactivePlayerLoop];
    
    GDVEBaseCoat *elementCoat = self.durationAdjustView.viewModel.elementCoat;
    [self.service finishAdjustWithCoat:elementCoat];
    
    if ([self.delegate respondsToSelector:@selector(elementDurationAdjustViewController:didUpdatedWithCoatUuid:)]) {
        [self.delegate elementDurationAdjustViewController:self didUpdatedWithCoatUuid:elementCoat.uuid];
    }
}

- (void)didSeekToTime:(long)time {
    if ([self.delegate respondsToSelector:@selector(elementDurationAdjustViewController:didSeekToTime:)]) {
        [self.delegate elementDurationAdjustViewController:self didSeekToTime:time];
    }
}

// MARK: - GDVTElementDurationAdjustViewDelegate

- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
      beganUpdatingSelectionRange:(GDVTSelectionRange *)selectionRange
                     updateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    [self.service inactivePlayerLoop];
}

- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
           updatingSelectionRange:(GDVTSelectionRange *)selectionRange
                     updateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    GDTimeRange *timeRange = [elementDurationAdjustView.viewModel timeRangeForSelectionRange:selectionRange];
    GDVEBaseCoat *elementCoat = elementDurationAdjustView.viewModel.elementCoat;
    [self.service updateWithCoat:elementCoat
                       timeRange:timeRange
                    updateReason:updateReason];
    
    long seekTime = [self seekTimeWithTimeRange:timeRange updateReason:updateReason];
    [self didSeekToTime:seekTime];
}

- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
        endUpdatingSelectionRange:(GDVTSelectionRange *)selectionRange
                     updateReason:(GDVTSelectionRangeUpdateReason)updateReason {
    GDTimeRange *timeRange = [elementDurationAdjustView.viewModel timeRangeForSelectionRange:selectionRange];
    GDVEBaseCoat *elementCoat = elementDurationAdjustView.viewModel.elementCoat;
    [self.service updateWithCoat:elementCoat
                       timeRange:timeRange
                    updateReason:updateReason];
    
    long seekTime = [self seekTimeWithTimeRange:timeRange updateReason:updateReason];
    [self didSeekToTime:seekTime];
    [elementDurationAdjustView seekTimelineToTime:seekTime animated:YES];
    
    [self.service activePlayerLoop];
}

- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
                    didSeekToTime:(long)time {
    [self didSeekToTime:time];
}

// MARK: - GDVEMaterialBottomTitleViewDelegate

- (void)didClickConfirm {
    [self saveResultAndDismiss];
}

// MARK: - Custom Accessors

- (GDVTPannelContainerView *)containerView {
    if (!_containerView) {
        GDWeakify(self);
        _containerView = [[GDVTPannelContainerView alloc] initWithFrame:CGRectZero
                                                      contentViewHeight:252.0
                                                   tappedNonContentArea:^{
            GDStrongify(self);
            [self saveResultAndDismiss];
        }];
        
        [_containerView setupMainView:self.durationAdjustView];
        [_containerView setupSubview:self.titleBar];
    }
    return _containerView;
}

- (GDVEMaterialBottomTitleView *)titleBar {
    if (!_titleBar) {
        GDVEMaterialBottomTitleView *titleBar = [[GDVEMaterialBottomTitleView alloc] init];
        [titleBar hideCancelButton:YES];
        titleBar.title = GDMVideoEditLocalizedString(@"video_template_duration_adjust_title", @"时长调节");
        titleBar.delegate = self;
        _titleBar = titleBar;
    }
    return _titleBar;
}

- (GDVTElementDurationAdjustView *)durationAdjustView {
    if (!_durationAdjustView) {
        _durationAdjustView = [[GDVTElementDurationAdjustView alloc] init];
        _durationAdjustView.delegate = self;
    }
    return _durationAdjustView;
}

- (GDVTElementDurationAdjustService *)service {
    if (!_service) {
        _service = [[GDVTElementDurationAdjustService alloc] initWithTimelineCoat:self.timelineCoat];
    }
    return _service;
}

@end
