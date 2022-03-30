//
//  GDVTTimelineFrameGenerator.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineFrameGenerator.h"
#import <GDFoundation/GDDefine.h>
#import "GDVTTimelineFrame.h"
#import "GDVEBaseCoat.h"
#import "GDVEImageCoat.h"
#import "GDVEAnimatedImageCoat.h"
#import "GDVEPlaceholderCoat.h"
#import "GDVEPathUtils.h"
#import "GDVECalculateUtils.h"

@implementation GDVTTimelineFrameGenerator

+ (NSArray<GDVTTimelineFrame *> *)generateFramesForMainTracks:(NSArray<GDVEBaseCoat *> *)mainTracks
                                             intervalPerFrame:(long)intervalPerFrame
                                                maxFrameWidth:(CGFloat)maxFrameWidth {
    if (mainTracks.count == 0 || intervalPerFrame <= 0.0) {
        return [NSArray new];
    }
    
    NSMutableArray *timelineFrames = [NSMutableArray new];
    
    long frameTime = 0;
    NSUInteger frameIndex = 0;
    for (NSUInteger index = 0; index < mainTracks.count; index++) {
        GDVEBaseCoat *track = mainTracks[index];
        while ([GDVECalculateUtils isTime:frameTime inTimeRange:track.timeRange]) {
            GDVTTimelineFrame *frame = [self generateFramesForCoat:track frameIndex:frameIndex frameWidth:maxFrameWidth];
            if (frame) {
                [timelineFrames addObject:frame];
            }
            frameIndex += 1;
            frameTime += intervalPerFrame;
        }
        
        if (index == mainTracks.count - 1) {
            // 最后一帧需要显示实际尺寸
            GDVTTimelineFrame *lastTimelineFrame = [timelineFrames lastObject];
            [timelineFrames removeLastObject];
            long endTime = track.timeRange.endTime;
            CGFloat frameWidth = ((endTime - (frameTime - intervalPerFrame)) / @(intervalPerFrame).floatValue) * maxFrameWidth;
            GDVTTimelineFrame *frame = [[GDVTTimelineFrame alloc] initWithIdentifier:lastTimelineFrame.identifier assetIdentifier:lastTimelineFrame.assetIdentifier frameIndex:lastTimelineFrame.frameIndex frameWidth:frameWidth];
            [timelineFrames addObject:frame];
        }
    }
    
    return [timelineFrames copy];
}

+ (nullable GDVTTimelineFrame *)generateFramesForCoat:(GDVEBaseCoat *)coat
                                           frameIndex:(NSUInteger)frameIndex
                                           frameWidth:(CGFloat)frameWidth {
    NSString *identifier = [GDVEPathUtils sourceThumbPathWithCoat:coat];
    return [[GDVTTimelineFrame alloc] initWithIdentifier:coat.uuid assetIdentifier:identifier frameIndex:frameIndex frameWidth:frameWidth];
}

@end
