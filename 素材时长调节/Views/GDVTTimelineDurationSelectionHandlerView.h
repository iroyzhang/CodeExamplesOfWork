//
//  GDVTTimelineDurationSelectionHandlerView.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 时间轴时长选择把手视图
@interface GDVTTimelineDurationSelectionHandlerView : UIView

/// 图标颜色
@property (nonatomic, strong) UIColor *iconColor;

/// 图标尺寸
@property (nonatomic, assign) CGSize iconSize;

/// 热区间隙
@property (nonatomic, assign) UIEdgeInsets hotAreaInsets;

@end

NS_ASSUME_NONNULL_END
