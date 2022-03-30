//
//  GDVTTimelineThumbnailFetcher.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <Foundation/Foundation.h>

@class GDVEBaseCoat, GDVTTimelineFrame;

NS_ASSUME_NONNULL_BEGIN

@interface GDVTTimelineThumbnailFetcher : NSObject

/// 取帧间隔，单位毫秒
@property (nonatomic, assign) long intervalPerFrame;

/// 初始化方法
/// @param intervalPerFrame 取帧间隔，单位毫秒
- (instancetype)initWithIntervalPerFrame:(long)intervalPerFrame;

/// 获取缩略图
/// @param coat coat数据
/// @param frameIndex 帧序号
/// @param size 尺寸
/// @param completion 获取完成回调
- (void)fetchThumbnailForCoat:(GDVEBaseCoat *)coat
                   frameIndex:(NSUInteger)frameIndex
                         size:(CGSize)size
                   completion:(void(^)(GDVTTimelineFrame *frame, UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
