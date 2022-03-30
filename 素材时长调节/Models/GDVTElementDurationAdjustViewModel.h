//
//  GDVTElementDurationAdjustViewModel.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/29.
//

#import <Foundation/Foundation.h>

@class GDVETimelineCoat, GDVEBaseCoat, GDVTTimelineViewModel, GDVTTimelineDurationSelectionViewModel, GDTimeRange, GDVTSelectionRange;

NS_ASSUME_NONNULL_BEGIN

@interface GDVTElementDurationAdjustViewModel : NSObject

/// 时间轴Coat
@property (nonatomic, strong, readonly) GDVETimelineCoat *timelineCoat;

/// 元素Coat
@property (nonatomic, strong, readonly) GDVEBaseCoat *elementCoat;

/// 取帧间隔，单位毫秒
@property (nonatomic, assign, readonly) long intervalPerFrame;

/// 每帧图片尺寸
@property (nonatomic, assign, readonly) CGSize imagePerFrameSize;

/// 时间轴视图模型
@property (nonatomic, strong, readonly) GDVTTimelineViewModel *timelineViewModel;

/// 时长选择视图模型
@property (nonatomic, strong, readonly) GDVTTimelineDurationSelectionViewModel *durationSelectionViewModel;

/// 当前选择范围
@property (nonatomic, strong, readonly) GDVTSelectionRange *currentSelectionRange;

/// 选择范围发生变化
@property (nonatomic, copy, nullable) void(^selectionRangeChanged)(GDVTSelectionRange *);

/// 当前选择范围是否被初始化
@property (nonatomic, assign, readonly) BOOL isCurrentSelectionRangeInitialized;

/// 初始化方法
/// @param timelineCoat 时间轴Coat
/// @param elementCoat 元素Coat
/// @param intervalPerFrame 取帧间隔，单位毫秒
/// @param imagePerFrameSize 每帧图片尺寸
- (instancetype)initWithTimelineCoat:(GDVETimelineCoat *)timelineCoat
                         elementCoat:(GDVEBaseCoat *)elementCoat
                    intervalPerFrame:(long)intervalPerFrame
                   imagePerFrameSize:(CGSize)imagePerFrameSize;

/// 转换GDVTSelectionRange为GDTimeRange
/// @param selectionRange 选择范围
- (GDTimeRange *)timeRangeForSelectionRange:(GDVTSelectionRange *)selectionRange;

/// 增加选择范围位置
/// @param increment 增量
- (void)clampSelectionRangeLocation:(CGFloat)increment;

/// 增加选择范围长度
/// @param increment 增量
- (void)clampSelectionRangeLength:(CGFloat)increment;

/// 修改选择范围位置，不会改变长度
/// @param translationX 位移量
- (void)updateSelectionRangeLocationWithTranslationX:(CGFloat)translationX;

/// 更新当前选择范围
/// @discussion 时间和长度比例由时间轴决定，所以要等到时间轴刷新完数据才能进行初始化
- (void)updateCurrentSelectionRange;

/// 主轴时长范围
- (GDTimeRange *)mainTrackTimeRange;

@end

NS_ASSUME_NONNULL_END
