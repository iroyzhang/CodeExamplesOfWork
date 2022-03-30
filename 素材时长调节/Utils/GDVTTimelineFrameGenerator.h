//
//  GDVTTimelineFrameGenerator.h
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import <Foundation/Foundation.h>
#import "GDVECoatTimeCapability.h"
#import "GDVECoatPathCapability.h"

@class GDVTTimelineFrame, GDVEBaseCoat;

NS_ASSUME_NONNULL_BEGIN

/// 时间轴序列帧生成器
@interface GDVTTimelineFrameGenerator : NSObject

/// 生成序列帧数组
/// @param mainTracks 主轴视频数组
/// @param intervalPerFrame 取帧间隔，单位毫秒
/// @param maxFrameWidth 最大帧宽度
+ (NSArray<GDVTTimelineFrame *> *)generateFramesForMainTracks:(NSArray<GDVEBaseCoat *> *)mainTracks
                                             intervalPerFrame:(long)intervalPerFrame
                                                maxFrameWidth:(CGFloat)maxFrameWidth;

/// 通过帧序号生成序列帧
/// @param coat coat数据
/// @param frameIndex 帧序号
/// @param frameWidth 帧宽度
+ (nullable GDVTTimelineFrame *)generateFramesForCoat:(GDVEBaseCoat *)coat
                                           frameIndex:(NSUInteger)frameIndex
                                           frameWidth:(CGFloat)frameWidth;

@end

NS_ASSUME_NONNULL_END
