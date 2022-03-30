//
//  GDVTTimelineDurationSelectionViewModel.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/26.
//

#import <Foundation/Foundation.h>

@class GDVEBaseCoat, GDVTTimelineViewModel, GDTimeRange;

NS_ASSUME_NONNULL_BEGIN

/// 时长选择视图模型
@interface GDVTTimelineDurationSelectionViewModel : NSObject

/// 选中的元素Coat
@property (nonatomic, strong, readonly) GDVEBaseCoat *selectedCoat;

/// 时间轴模型
@property (nonatomic, strong) GDVTTimelineViewModel *timelineViewModel;

/// 选择视图颜色，由元素类型决定
@property (nonatomic, strong, readonly) UIColor *selectionViewColor;

/// 把手宽度
@property (nonatomic, assign) CGFloat handlerWidth;

/// 边框宽度
@property (nonatomic, assign) CGFloat borderWidth;

/// 初始化方法
/// @param coat 元素Coat
/// @param timelineViewModel 时间轴模型
- (instancetype)initWithCoat:(GDVEBaseCoat *)coat
           timelineViewModel:(GDVTTimelineViewModel *)timelineViewModel;


@end

NS_ASSUME_NONNULL_END
