//
//  GDVTTimelineView.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/23.
//

#import <UIKit/UIKit.h>

@class GDVTTimelineViewModel, GDVTTimelineView;

NS_ASSUME_NONNULL_BEGIN

@protocol GDVTTimelineViewDelegate <NSObject>

@optional

/// 时间轴滚动了
/// @param timelineView 时间轴视图
- (void)timelineViewDidScroll:(GDVTTimelineView *)timelineView;

/// 时间轴刷新了数据
/// @param timelineView 时间轴视图
- (void)timelineViewDidReloadData:(GDVTTimelineView *)timelineView;

@end

/// 时间轴视图
@interface GDVTTimelineView : UIView

/// 视图配置
@property (nonatomic, strong) GDVTTimelineViewModel *viewModel;

/// 内容间隙
@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;

/// 内容尺寸
@property (nonatomic, assign, readonly) CGSize contentSize;

/// 内容偏移
@property (nonatomic, assign, readonly) CGPoint contentOffset;

/// 代理
@property (nonatomic, weak) id<GDVTTimelineViewDelegate> delegate;

/// 初始化方法
/// @param viewModel 视图模型
- (instancetype)initWithViewModel:(GDVTTimelineViewModel *)viewModel;

/// 修改播放时刻
/// @param time 播放时刻
/// @param animated 是否做动画
- (void)seekToTime:(long)time animated:(BOOL)animated;

/// 通过位移滚动
/// @param offset 位移
- (void)seekWithOffset:(CGPoint)offset;

/// 刷新数据
- (void)reloadData;

/// 刷新数据并滑动到指定时刻
/// @param seekTime 需要滑动到时刻
- (void)reloadDataWithSeekTime:(long)seekTime;

/// 基于临时缓存刷新
- (void)reloadDataByCache;

/// 添加视图到滚动视图
/// @param subview 需要添加的视图
- (void)addSubviewToScrollView:(UIView *)subview;

/// 可见区域
- (CGRect)visibleRect;

@end

NS_ASSUME_NONNULL_END
