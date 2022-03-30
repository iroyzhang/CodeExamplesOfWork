//
//  GDVTTimelineViewModel.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <Foundation/Foundation.h>

@class GDVETimelineCoat, GDVTTimelineViewConfiguration, GDVTTimelineFrame;

NS_ASSUME_NONNULL_BEGIN

/// 时间轴视图配置
@interface GDVTTimelineViewModel : NSObject 

/// 时间轴数据
@property (nonatomic, strong) GDVETimelineCoat *timelineCoat;

/// 视图配置
@property (nonatomic, strong) GDVTTimelineViewConfiguration *viewConfiguration;

/// 取帧间隔，单位毫秒
@property (nonatomic, assign) long intervalPerFrame;

/// 每帧图片尺寸
@property (nonatomic, assign) CGSize imagePerFrameSize;

/// 时间与位移比例
@property (nonatomic, assign, readonly) CGFloat timeOffsetRatio;

/// 最小偏移
@property (nonatomic, assign, readonly) CGFloat minContentOffset;

/// 最大偏移
@property (nonatomic, assign, readonly) CGFloat maxContentOffset;

/// 初始化方法
/// @param timelineCoat 时间轴数据
/// @param viewConfiguration 视图配置
/// @param intervalPerFrame 取帧间隔，单位毫秒
/// @param imagePerFrameSize 每帧图片尺寸
- (instancetype)initWithTimelineCoat:(GDVETimelineCoat *)timelineCoat
                   viewConfiguration:(GDVTTimelineViewConfiguration *)viewConfiguration
                    intervalPerFrame:(long)intervalPerFrame
                   imagePerFrameSize:(CGSize)imagePerFrameSize;

/// 标记是否需要更新
- (void)setNeedUpdate;

/// 获取所有的帧，根据内部标记判断是重新生成还是直接从缓存里取
- (void)fetchTimelineFrames:(void(^)(NSArray<GDVTTimelineFrame *> *frames))completion;

/// 通过帧数据获取缩略图
/// @param size 尺寸
/// @param timelineFrame 帧模型
/// @param completion 完成回调
- (void)fetchThumbnailForTimelineFrame:(GDVTTimelineFrame *)timelineFrame
                          size:(CGSize)size
                    completion:(void(^)(GDVTTimelineFrame *timelineFrameForImage, UIImage *image))completion;

/// 通过偏移获取时刻
/// @param offset 偏移
- (long)timeForOffset:(CGFloat)offset;

/// 通过时刻获取偏移
/// @param time 时刻
- (CGFloat)offsetForTime:(long)time;

/// 内容宽度
- (CGFloat)contentWidth;

@end

NS_ASSUME_NONNULL_END
