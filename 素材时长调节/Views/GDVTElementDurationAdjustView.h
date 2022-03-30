//
//  GDVTElementDurationAdjustView.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import "GDVTSelectionRange.h"

@class GDVEBaseCoat, GDVTElementDurationAdjustViewModel;
@class GDVTElementDurationAdjustView, GDVTTimelineView, GDVTTimelineDurationSelectionView, GDVTTimelineDurationSelectionCursorView;

NS_ASSUME_NONNULL_BEGIN

@protocol GDVTElementDurationAdjustViewDelegate <NSObject>

@optional
/// 选择范围开始发生改变
/// @param elementDurationAdjustView 元素时长调节视图
/// @param selectionRange 选择范围
/// @param updateReason 更新原因
- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
         beganUpdatingSelectionRange:(GDVTSelectionRange *)selectionRange
                     updateReason:(GDVTSelectionRangeUpdateReason)updateReason;

/// 选择范围正在改变
/// @param elementDurationAdjustView 元素时长调节视图
/// @param selectionRange 选择范围
/// @param updateReason 更新原因
- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
           updatingSelectionRange:(GDVTSelectionRange *)selectionRange
                     updateReason:(GDVTSelectionRangeUpdateReason)updateReason;

/// 选择范围结束改变
/// @param elementDurationAdjustView 元素时长调节视图
/// @param selectionRange 选择范围
/// @param updateReason 更新原因
- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
        endUpdatingSelectionRange:(GDVTSelectionRange *)selectionRange
                     updateReason:(GDVTSelectionRangeUpdateReason)updateReason;

/// 调节到某时刻
/// @param elementDurationAdjustView 元素时长调节视图
/// @param time 时刻
- (void)elementDurationAdjustView:(GDVTElementDurationAdjustView *)elementDurationAdjustView
                    didSeekToTime:(long)time;

@end

/// 元素时长调节视图
@interface GDVTElementDurationAdjustView : UIView

/// 视图模型
@property (nonatomic, strong) GDVTElementDurationAdjustViewModel *viewModel;

/// 代理
@property (nonatomic, weak) id<GDVTElementDurationAdjustViewDelegate> delegate;

/// 初始化方法
/// @param viewModel 视图模型
- (instancetype)initWithViewModel:(GDVTElementDurationAdjustViewModel *)viewModel;

/// 通过SelectionRange更新
/// @param selectionRange 新的选择范围
- (void)updateWithSelectionRange:(GDVTSelectionRange *)selectionRange;

/// 更新视图模型，并指定起始时间
/// @param viewModel 视图模型
/// @param seekTime 时刻
- (void)updateWithViewModel:(GDVTElementDurationAdjustViewModel *)viewModel
                   seekTime:(long)seekTime;

/// 更新时间轴到指定时刻
/// @param time 时刻
/// @param animated 是否需要动画
- (void)seekTimelineToTime:(long)time animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
