//
//  GDVTTimelineDurationSelectionView.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <UIKit/UIKit.h>

@class GDVTTimelineDurationSelectionViewModel, GDVTSelectionRange;

NS_ASSUME_NONNULL_BEGIN

/// 时间轴时长选择视图
@interface GDVTTimelineDurationSelectionView : UIView

/// 时长显示视图
@property (nonatomic, strong, readonly) UILabel *durationLabel;

/// 视图模型
@property (nonatomic, strong) GDVTTimelineDurationSelectionViewModel *viewModel;

/// 选择范围
@property (nonatomic, strong, readonly) GDVTSelectionRange *selectionRange;

/// 左边把手拖拽手势识别器
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *leftPanGestureRecognizer;

/// 右边把手拖拽手势识别器
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *rightPanGestureRecognizer;

/// 主要颜色
@property (nonatomic, strong) UIColor *mainColor;

/// 边框宽度
@property (nonatomic, assign) CGFloat borderWidth;

/// 初始化方法
/// @param viewModel 视图模型
- (instancetype)initWithViewModel:(GDVTTimelineDurationSelectionViewModel *)viewModel;

/// 修改时间视图显示位置是否在左边
/// @param isOnTheLeft 是否在左边
- (void)updateDurationLabelPositionWithIsOnTheLeft:(BOOL)isOnTheLeft;

@end

NS_ASSUME_NONNULL_END
