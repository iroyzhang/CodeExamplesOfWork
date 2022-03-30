//
//  GDVTTimelineViewModel.m
//  GDMVideoEdit
//
//  Created by buze on 2021/11/25.
//

#import "GDVTTimelineViewModel.h"
#import <GDFoundation/GDDefine.h>
#import <GDFoundation/GDDebug.h>
#import "GDVETimelineCoat.h"
#import "GDVTTimelineThumbnailFetcher.h"
#import "GDVTTimelineFrameGenerator.h"
#import "GDVTTimelineFrame.h"
#import "GDVTTimelineViewConfiguration.h"
#import "GDVTCoatUtils.h"
#import "GDVECalculateUtils.h"
#import "GDVETimelineCoat+ElementEdit.h"

@interface GDVTTimelineViewModel()

/// 标记是否更新
@property (nonatomic, assign) BOOL markNeedUpdate;

/// 临时缓存的序列帧
@property (nonatomic, copy) NSArray<GDVTTimelineFrame *> *cachedTimelineFrames;

/// 缓存的内容宽度
@property (nonatomic, assign) CGFloat cachedContentWidth;

/// 缩略图获取器
@property (nonatomic, strong) GDVTTimelineThumbnailFetcher *fetcher;

@end

@implementation GDVTTimelineViewModel

// MARK: - Lifecycle

- (instancetype)initWithTimelineCoat:(GDVETimelineCoat *)timelineCoat viewConfiguration:(GDVTTimelineViewConfiguration *)viewConfiguration intervalPerFrame:(long)intervalPerFrame imagePerFrameSize:(CGSize)imagePerFrameSize {
    self = [super init];
    if (self) {
        _timelineCoat = timelineCoat;
        _viewConfiguration = viewConfiguration;
        _intervalPerFrame = intervalPerFrame;
        _imagePerFrameSize = imagePerFrameSize;
        _markNeedUpdate = YES;
    }
    return self;
}

// MARK: - Public

- (void)setNeedUpdate {
    _markNeedUpdate = YES;
}

- (void)fetchTimelineFrames:(void (^)(NSArray<GDVTTimelineFrame *> *frames))completion {
    if (!self.markNeedUpdate) {
        GDBlockCall(completion, self.cachedTimelineFrames);
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *mainTracks = [self.timelineCoat coatsByServiceType:GDVECoatServiceTypeMainTrack];
            
            NSArray<GDVTTimelineFrame *> *timelineFrames = [GDVTTimelineFrameGenerator generateFramesForMainTracks:mainTracks intervalPerFrame:self.intervalPerFrame maxFrameWidth:self.imagePerFrameSize.width];
            
            self.cachedTimelineFrames = timelineFrames;
            self.markNeedUpdate = NO;
            
            __block CGFloat contentWidth = 0.0;
            [timelineFrames enumerateObjectsUsingBlock:^(GDVTTimelineFrame * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                contentWidth = contentWidth + obj.frameWidth;
            }];
            self.cachedContentWidth = contentWidth;
            
            GDBlockCallInMain(completion, [timelineFrames copy]);
        });
    }
}

- (void)fetchThumbnailForTimelineFrame:(GDVTTimelineFrame *)timelineFrame
                                  size:(CGSize)size
                            completion:(void (^)(GDVTTimelineFrame * _Nonnull, UIImage * _Nonnull))completion {
    if (!timelineFrame) { return; }
    
    GDVEBaseCoat *coat = [self.timelineCoat coatByUuid:timelineFrame.identifier];
    if (!coat) { return; }
    
    CGSize contentSize = CGSizeZero;
    if ([coat conformsToProtocol:@protocol(GDVECoatVisibleCapability)]) {
        contentSize = [(GDVEBaseCoat<GDVECoatVisibleCapability> *)coat naturalSize];
    } else {
        GDAssert(0);
    }
    CGSize imageSize = [GDVECalculateUtils sizeForMakeAspectFillWithContentSize:contentSize
                                                                 inBoundingSize:size];
    
    [self.fetcher fetchThumbnailForCoat:coat frameIndex:timelineFrame.frameIndex size:imageSize completion:^(GDVTTimelineFrame * _Nonnull frame, UIImage * _Nonnull image) {
        completion(timelineFrame, image);
    }];
}

- (long)timeForOffset:(CGFloat)offset {
    long time = offset / self.timeOffsetRatio;
    
    GDTimeRange *mainTrackTimeRange = [GDVTCoatUtils mainTrackTimeRangeForTimelineCoat:self.timelineCoat];
    
    if (time < mainTrackTimeRange.delay) {
        time = mainTrackTimeRange.delay;
    }
    if (time > mainTrackTimeRange.endTime) {
        time = mainTrackTimeRange.endTime;
    }
    
    return time;
}

- (CGFloat)offsetForTime:(long)time {
    CGFloat offset = time * self.timeOffsetRatio + self.minContentOffset;
    
    if (offset < self.minContentOffset) {
        offset = self.minContentOffset;
    }
    if (offset > self.maxContentOffset) {
        offset = self.maxContentOffset;
    }
    
    return offset;
}

- (CGFloat)contentWidth {
    return self.cachedContentWidth;
}

// MARK: - Private

- (long)maxEndTimeOnMainTrack {
    NSUInteger mainTrackCount = [self.timelineCoat numberOfCoatsByServiceType:GDVECoatServiceTypeMainTrack];
    
    if (mainTrackCount <= 0) {
        return 0;
    }
    
    GDVEBaseCoat *lastMainTrack = [self.timelineCoat mainTrackCoatAtIndex:mainTrackCount - 1];
    long mainTrackEndTime = lastMainTrack.timeRange.endTime;
    return mainTrackEndTime;
}

// MARK: - Custom Accessors

- (GDVTTimelineThumbnailFetcher *)fetcher {
    if (!_fetcher) {
        _fetcher = [[GDVTTimelineThumbnailFetcher alloc] initWithIntervalPerFrame:self.intervalPerFrame];
    }
    return _fetcher;
}

- (CGFloat)timeOffsetRatio {
    GDTimeRange *mainTrackTimeRange = [GDVTCoatUtils mainTrackTimeRangeForTimelineCoat:self.timelineCoat];
    if (mainTrackTimeRange.duration <= 0.0 || self.contentWidth <= 0.0) { return 1.0; }
    return self.contentWidth / mainTrackTimeRange.duration;
}

- (CGFloat)minContentOffset {
    return -self.viewConfiguration.contentInset.left;
}

- (CGFloat)maxContentOffset {
    CGFloat screenWidth = CGRectGetWidth(UIScreen.mainScreen.bounds);
    CGFloat offset = self.contentWidth + self.viewConfiguration.contentInset.left + self.viewConfiguration.contentInset.right - screenWidth;
    return offset;
}

@end
